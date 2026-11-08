#!/usr/bin/env python3
"""
Convert SQL Server (T-SQL) DDL schemas into PostgreSQL tables and migration scripts.
Applies universal camelCase conversion and outputs clean single-line table opening parentheses.
"""
import argparse
import glob
import os
import re
import sys

# SQL Server -> PostgreSQL Type Mapping
TYPE_MAP = [
    (r"\bUNIQUEIDENTIFIER\b", "UUID"),
    (r"\bNVARCHAR\s*\((?:MAX|\d+)\)", lambda m: "TEXT" if "MAX" in m.group(0).upper() else m.group(0).replace("NVARCHAR", "VARCHAR")),
    (r"\bVARCHAR\s*\(MAX\)", "TEXT"),
    (r"\bNTEXT\b", "TEXT"),
    (r"\bDATETIME2?\b(?:\s*\(\d*\))?", "TIMESTAMPTZ"),
    (r"\bDATETIME\b", "TIMESTAMPTZ"),
    (r"\bSMALLDATETIME\b", "TIMESTAMPTZ"),
    (r"\bBIT\b", "BOOLEAN"),
    (r"\bTINYINT\b", "SMALLINT"),
    (r"\bMONEY|SMALLMONEY\b", "NUMERIC(19,4)"),
    (r"\bFLOAT\b(?:\s*\(\d+\))?", "DOUBLE PRECISION"),
    (r"\bREAL\b", "REAL"),
    (r"\bIMAGE|VARBINARY\s*\(MAX\)\b", "BYTEA"),
    (r"\bVARBINARY\s*\(\d+\)\b", "BYTEA"),
]

# SQL Server -> PostgreSQL Function Defaults Mapping
DEFAULT_MAP = [
    (r"\(?sysutcdatetime\(\)\)?", "clock_timestamp()"),
    (r"\(?sysdatetime\(\)\)?", "clock_timestamp()"),
    (r"\(?getutcdate\(\)\)?", "clock_timestamp()"),
    (r"\(?getdate\(\)\)?", "clock_timestamp()"),
    (r"\(?newid\(\)\)?", "gen_random_uuid()"),
    (r"\(?newsequentialid\(\)\)?", "gen_random_uuid()"),
]

def to_camel_case(name: str) -> str:
    if not name:
        return name
    name = name.strip('"[]')
    if "_" in name or "-" in name:
        parts = re.split(r'[_\-]+', name)
        if not parts:
            return name
        result_parts = [parts[0].lower()]
        for p in parts[1:]:
            if not p:
                continue
            if p.lower() == 'id':
                result_parts.append('Id')
            else:
                result_parts.append(p.capitalize())
        return "".join(result_parts)

    if name.lower().endswith('id') and len(name) > 2 and not name.islower():
        base = name[:-2]
        return to_camel_case(base) + 'Id'

    words = re.findall(r'[A-Z][a-z]*|[a-z]+|[0-9]+', name)
    if not words:
        return name[0].lower() + name[1:]

    result_words = []
    for i, word in enumerate(words):
        if i == 0:
            result_words.append(word.lower())
        else:
            if word.upper() == 'ID':
                result_words.append('Id')
            else:
                result_words.append(word.capitalize())
    return "".join(result_words)

def clean_sql_server_syntax(sql: str) -> str:
    sql = re.sub(r"^\s*-- Converted from SQL Server to PostgreSQL\s*\n?", "", sql, flags=re.M)
    sql = re.sub(r"^\s*GO\s*$", "", sql, flags=re.M | re.I)
    sql = re.sub(r"\[dbo\]\.", "", sql, flags=re.I)
    sql = re.sub(r"\[([^\]]+)\]", lambda m: f'"{to_camel_case(m.group(1))}"', sql)
    sql = re.sub(r"DEFAULT\s*\((.*?)\)", r"DEFAULT \1", sql, flags=re.I)
    return sql

def split_line_and_comment(line: str) -> tuple[str, str]:
    tokens = re.split(r"(--.*$)", line, maxsplit=1)
    if len(tokens) > 1:
        return tokens[0].rstrip(), tokens[1].strip()
    return line.strip(), ""

def convert_column(line: str) -> tuple[str, dict | None]:
    code_part, comment_part = split_line_and_comment(line)
    if not code_part:
        return line, None

    has_comma = code_part.endswith(",")
    clean_code = code_part.rstrip(",").strip()

    m = re.match(r"^\s*(?:\"(?P<quoted_name>[^\"]+)\"|(?P<raw_name>[^\s]+))\s+(?P<rest>.*)$", clean_code)
    if not m:
        return line, None

    raw_name = m.group("quoted_name") or m.group("raw_name")
    name = to_camel_case(raw_name)
    rest = m.group("rest")

    rest = re.sub(r"\(\((.*?)\)\)", r"\1", rest)

    if re.search(r"\bIDENTITY\s*\(\d+,\s*\d+\)", rest, re.I):
        rest = re.sub(r"\bIDENTITY\s*\(\d+,\s*\d+\)", "GENERATED ALWAYS AS IDENTITY", rest, flags=re.I)
        rest = re.sub(r"\bINT\b", "INTEGER", rest, flags=re.I)

    for pat, repl in TYPE_MAP:
        rest = re.sub(pat, repl, rest, flags=re.I)

    for pat, repl in DEFAULT_MAP:
        rest = re.sub(pat, repl, rest, flags=re.I)

    if re.search(r"\bBOOLEAN\b", rest, re.I):
        rest = re.sub(r"DEFAULT\s+'?0'?", "DEFAULT FALSE", rest, flags=re.I)
        rest = re.sub(r"DEFAULT\s+'?1'?", "DEFAULT TRUE", rest, flags=re.I)

    rest = re.sub(r"\s+", " ", rest).strip()
    comma_str = "," if has_comma else ""

    if comment_part:
        formatted_line = f'    "{name}" {rest}{comma_str} {comment_part}'
    else:
        formatted_line = f'    "{name}" {rest}{comma_str}'

    col_info = {"name": name, "definition": rest, "comment": comment_part}
    return formatted_line, col_info

def parse_ddl(sql: str) -> tuple[str, dict]:
    sql = clean_sql_server_syntax(sql)
    out = []
    deferred = []
    inside = False
    tables_meta = {}
    current_table = None

    for raw in sql.splitlines():
        line = raw.rstrip()
        if line.strip().startswith("--"):
            out.append(line)
            continue
        if not line.strip():
            # Keep blank lines only when not immediately following table header opening
            if inside and out and out[-1].endswith("("):
                continue
            out.append("")
            continue

        # Match CREATE TABLE statement
        match_table = re.match(r"^\s*CREATE\s+TABLE(?:\s+IF\s+NOT\s+EXISTS)?\s+\"?(?P<name>[^\s\"\(\)]+)\"?", line, re.I)
        if match_table:
            inside = True
            current_table = to_camel_case(match_table.group("name"))
            tables_meta[current_table] = []
            # Output table name and opening parenthesis on the SAME line
            out.append(f'CREATE TABLE IF NOT EXISTS "{current_table}" (')
            continue

        if inside:
            # Skip standalone opening parenthesis lines
            if line.strip() == '(':
                continue

            if re.match(r"^\s*\)", line):
                out.append(");")
                out.extend(deferred)
                deferred = []
                inside = False
                current_table = None
                continue

            if re.match(r"^\s*(CONSTRAINT|PRIMARY KEY|FOREIGN KEY|UNIQUE)\b", line, re.I):
                deferred.append("    -- Constraint: " + line.strip().rstrip(","))
                continue

            converted_line, col_info = convert_column(line)
            out.append(converted_line)
            if col_info and current_table:
                tables_meta[current_table].append(col_info)

    text = "\n".join(out)
    text = re.sub(r",(\s*--.*)?\s*\n\);", r"\1\n);", text)
    return text + "\n", tables_meta

def process_files(source_path: str, out_dir: str = None, alter_out: str = None):
    files = sorted(glob.glob(os.path.join(source_path, "**", "*.[sS][qQ][lL]"), recursive=True)) if os.path.isdir(source_path) else [source_path]
    all_tables_meta = {}

    for fpath in files:
        try:
            with open(fpath, encoding="utf-8-sig") as fh:
                sql = fh.read()
        except Exception:
            continue

        result_sql, meta = parse_ddl(sql)
        all_tables_meta.update(meta)

        if out_dir:
            os.makedirs(out_dir, exist_ok=True)
            base_name = to_camel_case(os.path.splitext(os.path.basename(fpath))[0])
            target_file = os.path.join(out_dir, f"{base_name}.sql")
            with open(target_file, "w", encoding="utf-8") as fh:
                fh.write(f"-- Converted from SQL Server to PostgreSQL\n{result_sql}\n")

    if alter_out:
        os.makedirs(os.path.dirname(alter_out) or ".", exist_ok=True)
        lines = ["-- Auto-generated schema migration\n"]
        for table_name, columns in all_tables_meta.items():
            if not columns:
                continue
            lines.append(f'-- Table: "{table_name}"')
            for col in columns:
                stmt = f'ALTER TABLE "{table_name}" ADD COLUMN IF NOT EXISTS "{col["name"]}" {col["definition"]};'
                if col.get("comment"):
                    stmt += f' {col["comment"]}'
                lines.append(stmt)
            lines.append("")

        with open(alter_out, "w", encoding="utf-8") as fh:
            fh.write("\n".join(lines))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("source")
    ap.add_argument("-o", "--out-dir")
    ap.add_argument("--alter-out")
    args = ap.parse_args()
    process_files(args.source, args.out_dir, args.alter_out)

if __name__ == "__main__":
    main()