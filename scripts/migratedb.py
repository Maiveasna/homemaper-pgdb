#!/usr/bin/env python3
"""
SQL Server -> PostgreSQL DATA migration into an EXISTING PostgreSQL schema.

* Connection settings come from environment variables / a .env file.
* No tables, indexes or constraints are created. Only data is copied.
* Tables and columns are matched by name, ignoring case and underscores:
      UserID == userId == user_id == userid
* Every warning / error (with traceback) goes to a log file (LOG_FILE).

Install:  pip install "psycopg[binary]" pymssql python-dotenv   (dotenv optional)
Usage:    python migratedb.py [--env-file .env] [--dry-run]
"""
import argparse
import logging
import os
import re
import sys
import time
from contextlib import closing

import psycopg
import pymssql
from psycopg import sql

log = logging.getLogger("migrate")

INT_TYPES = {"smallint", "integer", "bigint"}


# --------------------------------------------------------------------------
# .env / config
# --------------------------------------------------------------------------
def load_env_file(path):
    """Load KEY=VALUE pairs from path into os.environ (real env vars win)."""
    if not os.path.isfile(path):
        return False
    try:
        from dotenv import load_dotenv
        load_dotenv(path, override=False)
        return True
    except ImportError:
        pass
    with open(path, encoding="utf-8") as fh:  # minimal fallback parser
        for line in fh:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, _, v = line.partition("=")
            k, v = k.strip(), v.strip()
            if k.startswith("export "):
                k = k[7:].strip()
            if len(v) >= 2 and v[0] == v[-1] and v[0] in "\"'":
                v = v[1:-1]
            os.environ.setdefault(k, v)
    return True


def env_bool(name, default):
    v = os.getenv(name)
    return default if v is None else v.strip().lower() in ("1", "true", "yes", "y", "on")


def env_list(name):
    return [x.strip() for x in os.getenv(name, "").split(",") if x.strip()]


def env_map(name):
    """'a:b,c:d' -> {'a': 'b', 'c': 'd'} (keys lower-cased)."""
    out = {}
    for item in env_list(name):
        k, _, v = item.partition(":")
        if k and v:
            out[k.strip().lower()] = v.strip()
    return out


def load_config():
    required = ["MSSQL_HOST", "MSSQL_USER", "MSSQL_PASSWORD", "MSSQL_DATABASE"]
    if not os.getenv("PG_DSN"):
        required += ["PG_HOST", "PG_USER", "PG_PASSWORD", "PG_DATABASE"]
    missing = [k for k in required if not os.getenv(k)]
    if missing:
        sys.exit("Missing required environment variable(s): " + ", ".join(missing))
    return {
        "mssql": dict(
            server=os.environ["MSSQL_HOST"],
            port=os.getenv("MSSQL_PORT", "1433"),
            user=os.environ["MSSQL_USER"],
            password=os.environ["MSSQL_PASSWORD"],
            database=os.environ["MSSQL_DATABASE"],
            charset=os.getenv("MSSQL_CHARSET", "UTF-8"),
        ),
        "pg_dsn": os.getenv("PG_DSN"),
        "pg": dict(
            host=os.getenv("PG_HOST"),
            port=os.getenv("PG_PORT", "5432"),
            user=os.getenv("PG_USER"),
            password=os.getenv("PG_PASSWORD"),
            dbname=os.getenv("PG_DATABASE"),
            sslmode=os.getenv("PG_SSLMODE") or None,
        ),
        "schemas": env_list("MIGRATE_SCHEMAS"),
        "tables": [t.lower() for t in env_list("MIGRATE_TABLES")],
        "schema_map": env_map("SCHEMA_MAP") or {"dbo": "public"},
        "table_map": env_map("TABLE_MAP"),
        "column_map": env_map("COLUMN_MAP"),
        "batch_size": int(os.getenv("BATCH_SIZE", "5000")),
        "truncate": env_bool("TRUNCATE_TARGET", False),
        "row_fallback": env_bool("ROW_FALLBACK", True),
        "reset_sequences": env_bool("RESET_SEQUENCES", True),
        "log_row_values": env_bool("LOG_ROW_VALUES", True),
        "log_file": os.getenv("LOG_FILE", "migration_errors.log"),
    }


# --------------------------------------------------------------------------
# logging (console = info, file = warnings + errors with tracebacks)
# --------------------------------------------------------------------------
class CountHandler(logging.Handler):
    def __init__(self):
        super().__init__(logging.WARNING)
        self.warnings = 0
        self.errors = 0

    def emit(self, record):
        if record.levelno >= logging.ERROR:
            self.errors += 1
        else:
            self.warnings += 1


class ConsoleFormatter(logging.Formatter):
    """Console stays readable: no tracebacks (they go to the log file)."""

    def format(self, record):
        saved = record.exc_info, record.exc_text
        record.exc_info = record.exc_text = None
        try:
            return super().format(record)
        finally:
            record.exc_info, record.exc_text = saved


def setup_logging(log_file):
    log.setLevel(logging.DEBUG)
    console = logging.StreamHandler(sys.stdout)
    console.setLevel(logging.INFO)
    console.setFormatter(ConsoleFormatter("%(message)s"))
    log.addHandler(console)

    fh = logging.FileHandler(log_file, mode="w", encoding="utf-8")
    fh.setLevel(logging.WARNING)
    fh.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(message)s"))
    log.addHandler(fh)

    counter = CountHandler()
    log.addHandler(counter)
    return counter


def err_text(e):
    diag = getattr(e, "diag", None)
    msg = getattr(diag, "message_primary", None) or str(e)
    detail = getattr(diag, "message_detail", None)
    return f"{msg} ({detail})" if detail else msg


# --------------------------------------------------------------------------
# name matching
# --------------------------------------------------------------------------
def normalize(name):
    return re.sub(r"[^a-z0-9]", "", name.lower())


def match_name(name, candidates):
    """exact -> case-insensitive -> ignore case/underscores. None if no unique hit."""
    candidates = list(candidates)
    if name in candidates:
        return name
    low = name.lower()
    hits = [c for c in candidates if c.lower() == low]
    if len(hits) == 1:
        return hits[0]
    norm = normalize(name)
    hits = [c for c in candidates if normalize(c) == norm]
    return hits[0] if len(hits) == 1 else None


def qs(name):
    """Quote a SQL Server identifier."""
    return "[" + name.replace("]", "]]") + "]"


# --------------------------------------------------------------------------
# value conversion (source python value -> target column type)
# --------------------------------------------------------------------------
def make_converter(pg_type):
    def conv(v):
        if v is None:
            return None
        if isinstance(v, str):
            return v.replace("\x00", "") if "\x00" in v else v  # PG rejects NUL
        if pg_type == "boolean" and not isinstance(v, bool):
            return bool(v)
        if pg_type in INT_TYPES and isinstance(v, bool):
            return int(v)
        return v
    return conv


# --------------------------------------------------------------------------
# source (SQL Server)
# --------------------------------------------------------------------------
class Source:
    def __init__(self, connect):
        self.connect = connect
        self.conn = connect()  # metadata / counts

    def q(self, query, *params):
        cur = self.conn.cursor(as_dict=True)
        cur.execute(query, params or None)
        rows = cur.fetchall()
        cur.close()
        return rows

    def tables(self):
        return self.q("""
            SELECT s.name AS [schema], t.name AS [table], t.object_id
            FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id
            WHERE t.is_ms_shipped = 0
            ORDER BY s.name, t.name""")

    def columns(self, object_id):
        return self.q("""
            SELECT c.name, c.is_computed
            FROM sys.columns c WHERE c.object_id = %s
            ORDER BY c.column_id""", object_id)

    def count(self, schema, table):
        return self.q(f"SELECT COUNT_BIG(*) AS n FROM {qs(schema)}.{qs(table)}")[0]["n"]

    def stream(self, schema, table, cols, batch_size):
        """Stream rows on a dedicated connection so a failed copy can't leave
        the metadata connection busy."""
        conn = self.connect()
        try:
            cur = conn.cursor()
            cur.execute(f"SELECT {', '.join(qs(c) for c in cols)} "
                        f"FROM {qs(schema)}.{qs(table)}")
            while True:
                rows = cur.fetchmany(batch_size)
                if not rows:
                    break
                yield from rows
        finally:
            conn.close()

    def close(self):
        self.conn.close()


# --------------------------------------------------------------------------
# target (existing PostgreSQL schema)
# --------------------------------------------------------------------------
def load_target(pg):
    rows = pg.execute("""
        SELECT c.table_schema, c.table_name, c.column_name, c.data_type,
               c.is_generated, c.identity_generation
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema AND t.table_name = c.table_name
        WHERE t.table_type = 'BASE TABLE'
          AND c.table_schema NOT IN ('pg_catalog', 'information_schema')
        ORDER BY c.table_schema, c.table_name, c.ordinal_position""").fetchall()
    target = {}
    for schema, table, col, dtype, generated, identity in rows:
        target.setdefault(schema, {}).setdefault(table, {})[col] = {
            "type": dtype,
            "generated": generated == "ALWAYS",
            "identity_always": identity == "ALWAYS",
        }
    return target


def load_fk_deps(pg):
    """{(schema, table): {(parent_schema, parent_table), ...}}"""
    rows = pg.execute("""
        SELECT n1.nspname, c1.relname, n2.nspname, c2.relname
        FROM pg_constraint con
        JOIN pg_class c1 ON c1.oid = con.conrelid
        JOIN pg_namespace n1 ON n1.oid = c1.relnamespace
        JOIN pg_class c2 ON c2.oid = con.confrelid
        JOIN pg_namespace n2 ON n2.oid = c2.relnamespace
        WHERE con.contype = 'f'""").fetchall()
    deps = {}
    for s1, t1, s2, t2 in rows:
        deps.setdefault((s1, t1), set()).add((s2, t2))
    return deps


def build_plan(cfg, src, target):
    plan = []
    for t in src.tables():
        s_schema, s_table = t["schema"], t["table"]
        if cfg["schemas"] and s_schema.lower() not in [x.lower() for x in cfg["schemas"]]:
            continue
        if cfg["tables"] and s_table.lower() not in cfg["tables"] \
                and f"{s_schema}.{s_table}".lower() not in cfg["tables"]:
            continue

        want_schema = cfg["schema_map"].get(s_schema.lower(), s_schema)
        pg_schema = match_name(want_schema, target)
        if not pg_schema:
            log.warning(f"{s_schema}.{s_table}: PostgreSQL schema '{want_schema}' not found; skipped")
            continue

        want_table = (cfg["table_map"].get(f"{s_schema}.{s_table}".lower())
                      or cfg["table_map"].get(s_table.lower()) or s_table)
        pg_table = match_name(want_table, target[pg_schema])
        if not pg_table:
            log.warning(f"{s_schema}.{s_table}: no matching table in PostgreSQL "
                        f"schema '{pg_schema}'; skipped")
            continue

        tcols = target[pg_schema][pg_table]
        used, mapped, unmapped = set(), [], []
        for c in src.columns(t["object_id"]):
            want = (cfg["column_map"].get(f"{s_table}.{c['name']}".lower()) or c["name"])
            pg_col = match_name(want, [n for n in tcols if n not in used])
            if not pg_col:
                unmapped.append(c["name"])
                continue
            if tcols[pg_col]["generated"]:
                log.warning(f"{s_table}.{c['name']} -> {pg_table}.{pg_col}: target is a "
                            f"GENERATED column; skipped")
                used.add(pg_col)
                continue
            used.add(pg_col)
            mapped.append({"src": c["name"], "pg": pg_col, **tcols[pg_col]})

        if unmapped:
            log.warning(f"{s_schema}.{s_table}: source column(s) with no match in "
                        f"{pg_schema}.{pg_table}, NOT migrated: {', '.join(unmapped)}")
        if not mapped:
            log.warning(f"{s_schema}.{s_table}: no columns matched; skipped")
            continue
        plan.append({"src_schema": s_schema, "src_table": s_table,
                     "pg_schema": pg_schema, "pg_table": pg_table, "cols": mapped})
    return plan


def order_tables(plan, deps):
    """Load parent tables first so foreign keys are satisfied."""
    key = lambda p: (p["pg_schema"], p["pg_table"])
    nodes = {key(p): p for p in plan}
    pending = {k: {d for d in deps.get(k, ()) if d in nodes and d != k} for k in nodes}
    ordered = []
    while pending:
        ready = sorted(k for k, v in pending.items() if not v)
        if not ready:
            ready = sorted(pending)
            log.warning("Circular foreign-key dependency between: "
                        + ", ".join(f"{s}.{t}" for s, t in ready)
                        + " - FK errors are possible for these tables")
        for k in ready:
            ordered.append(nodes[k])
            del pending[k]
        for v in pending.values():
            v.difference_update(ready)
    return ordered


# --------------------------------------------------------------------------
# copying
# --------------------------------------------------------------------------
def ident(p):
    return sql.Identifier(p["pg_schema"], p["pg_table"])


def label(p):
    return f"{p['src_schema']}.{p['src_table']} -> {p['pg_schema']}.{p['pg_table']}"


def bulk_copy(cfg, pg, src, p, convs):
    stmt = sql.SQL("COPY {} ({}) FROM STDIN").format(
        ident(p), sql.SQL(", ").join(sql.Identifier(c["pg"]) for c in p["cols"]))
    n = 0
    with pg.cursor() as cur, cur.copy(stmt) as cp, closing(src.stream(
            p["src_schema"], p["src_table"], [c["src"] for c in p["cols"]],
            cfg["batch_size"])) as rows:
        for row in rows:
            cp.write_row([f(v) for f, v in zip(convs, row)])
            n += 1
            if n % 100000 == 0:
                log.info(f"    ... {n} rows")
    return n


def row_by_row(cfg, pg, src, p, convs):
    override = any(c["identity_always"] for c in p["cols"])
    stmt = sql.SQL("INSERT INTO {} ({}) {} VALUES ({})").format(
        ident(p),
        sql.SQL(", ").join(sql.Identifier(c["pg"]) for c in p["cols"]),
        sql.SQL("OVERRIDING SYSTEM VALUE" if override else ""),
        sql.SQL(", ").join([sql.Placeholder()] * len(p["cols"])))
    ok = bad = 0
    with pg.transaction(), closing(src.stream(
            p["src_schema"], p["src_table"], [c["src"] for c in p["cols"]],
            cfg["batch_size"])) as rows:
        for i, row in enumerate(rows, 1):
            try:
                values = [f(v) for f, v in zip(convs, row)]
                with pg.transaction():  # savepoint: a bad row doesn't abort the table
                    pg.execute(stmt, values)
                ok += 1
            except Exception as e:
                bad += 1
                msg = f"{label(p)}: row #{i} failed: {err_text(e)}"
                if cfg["log_row_values"]:
                    msg += " | values: " + repr(
                        dict(zip([c["pg"] for c in p["cols"]], row)))[:500]
                log.error(msg)
    return ok, bad


def load_table(cfg, pg, src, p):
    """Returns (rows_loaded, rows_failed, table_failed)."""
    convs = [make_converter(c["type"]) for c in p["cols"]]
    try:
        with pg.transaction():
            return bulk_copy(cfg, pg, src, p, convs), 0, False
    except Exception as e:
        log.error(f"{label(p)}: bulk COPY failed, table rolled back: {err_text(e)}",
                  exc_info=True)
    if not cfg["row_fallback"]:
        return 0, 0, True
    log.info("    retrying row by row (bad rows will be skipped and logged)")
    try:
        ok, bad = row_by_row(cfg, pg, src, p, convs)
        return ok, bad, False
    except Exception as e:
        log.error(f"{label(p)}: row-by-row load failed: {err_text(e)}", exc_info=True)
        return 0, 0, True


def truncate_targets(pg, plan):
    tables = sql.SQL(", ").join(ident(p) for p in plan)
    with pg.transaction():
        pg.execute(sql.SQL("TRUNCATE {} RESTART IDENTITY").format(tables))
    log.info("Target tables truncated")


def reset_sequences(pg, plan):
    for p in plan:
        for c in p["cols"]:
            try:
                seq = pg.execute(
                    "SELECT pg_get_serial_sequence(%s, %s)",
                    (ident(p).as_string(pg), c["pg"])).fetchone()[0]
                if not seq:
                    continue
                col = sql.Identifier(c["pg"])
                pg.execute(sql.SQL(
                    "SELECT setval(%s::regclass, COALESCE(MAX({c}), 1), MAX({c}) IS NOT NULL) "
                    "FROM {t}").format(c=col, t=ident(p)), (seq,))
                log.info(f"  {p['pg_table']}.{c['pg']}")
            except Exception as e:
                log.error(f"{label(p)}: could not reset sequence for {c['pg']}: {err_text(e)}",
                          exc_info=True)


def verify(src, pg, plan):
    ok = True
    for p in plan:
        try:
            s = src.count(p["src_schema"], p["src_table"])
            d = pg.execute(sql.SQL("SELECT COUNT(*) FROM {}").format(ident(p))).fetchone()[0]
        except Exception as e:
            log.error(f"{label(p)}: row count check failed: {err_text(e)}", exc_info=True)
            ok = False
            continue
        if s == d:
            log.info(f"  {label(p)}: {s} OK")
        else:
            ok = False
            log.error(f"{label(p)}: ROW COUNT MISMATCH source={s} target={d} "
                      "(if the target already held rows, enable TRUNCATE_TARGET)")
    return ok


# --------------------------------------------------------------------------
# main flow
# --------------------------------------------------------------------------
def run(cfg, src, pg, dry_run):
    start = time.time()
    target = load_target(pg)
    plan = build_plan(cfg, src, target)
    if not plan:
        log.error("No source table could be matched to a PostgreSQL table. Nothing to do.")
        return False

    log.info(f"Matched {len(plan)} table(s):")
    for p in plan:
        log.info(f"  {label(p)} ({len(p['cols'])} columns)")
        for c in p["cols"]:
            if c["src"] != c["pg"]:
                log.info(f"      {c['src']} -> {c['pg']}")
    if dry_run:
        log.info("\nDry run: nothing was written.")
        return True

    plan = order_tables(plan, load_fk_deps(pg))

    if cfg["truncate"]:
        try:
            truncate_targets(pg, plan)
        except Exception as e:
            log.critical(f"TRUNCATE failed, aborting: {err_text(e)}", exc_info=True)
            return False
    else:
        for p in plan:
            if pg.execute(sql.SQL("SELECT EXISTS (SELECT 1 FROM {})").format(
                    ident(p))).fetchone()[0]:
                log.warning(f"{label(p)}: target table is not empty; rows will be appended "
                            "(duplicates / key violations possible)")

    log.info("\nCopying data")
    total_rows = failed_rows = failed_tables = 0
    for p in plan:
        log.info(f"  {label(p)}")
        n, bad, table_failed = load_table(cfg, pg, src, p)
        total_rows += n
        failed_rows += bad
        failed_tables += table_failed
        log.info(f"    {n} row(s) loaded" + (f", {bad} failed" if bad else "")
                 + (" - TABLE FAILED" if table_failed else ""))

    if cfg["reset_sequences"]:
        log.info("\nResetting sequences")
        reset_sequences(pg, plan)

    log.info("\nVerifying row counts")
    counts_ok = verify(src, pg, plan)

    log.info(f"\nDone in {time.time() - start:.1f}s: {total_rows} row(s) loaded, "
             f"{failed_rows} row(s) failed, {failed_tables} table(s) failed.")
    return counts_ok and not failed_rows and not failed_tables


def main():
    ap = argparse.ArgumentParser(description="Copy data from SQL Server into an existing PostgreSQL schema.")
    ap.add_argument("--env-file", default=".env", help="path to .env (default: ./.env)")
    ap.add_argument("--dry-run", action="store_true",
                    help="only show the table/column mapping, write nothing")
    args = ap.parse_args()

    found = load_env_file(args.env_file)
    cfg = load_config()
    counter = setup_logging(cfg["log_file"])
    if not found:
        log.info(f"({args.env_file} not found; using process environment)")

    src = pg = None
    ok = False
    try:
        src = Source(lambda: pymssql.connect(**cfg["mssql"]))
        if cfg["pg_dsn"]:
            pg = psycopg.connect(cfg["pg_dsn"], autocommit=True)
        else:
            pg = psycopg.connect(autocommit=True,
                                 **{k: v for k, v in cfg["pg"].items() if v})
        ok = run(cfg, src, pg, args.dry_run)
    except Exception as e:
        log.critical(f"Unhandled error: {err_text(e)}", exc_info=True)
    finally:
        if src:
            src.close()
        if pg:
            pg.close()

    if counter.errors or counter.warnings:
        log.info(f"\n{counter.errors} error(s), {counter.warnings} warning(s) "
                 f"written to {cfg['log_file']}")
    sys.exit(0 if ok and not counter.errors else 1)


if __name__ == "__main__":
    main()