#!/usr/bin/env bash
set -Eeuo pipefail

# EasyKit PostgreSQL migration runner.
# Connects to an already-running PostgreSQL server using the host/port
# credentials in .env (no Docker container checks).
# Never deletes a database, volume, table, or column automatically.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_DIR"

ENV_FILE="${ENV_FILE:-${PROJECT_DIR}/.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERROR] .env not found: $ENV_FILE" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_USER="${POSTGRES_USER:-}"
DB_NAME="${POSTGRES_DB:-}"
DB_PASSWORD="${POSTGRES_PASSWORD:-}"

DRY_RUN=false
NON_INTERACTIVE=false
ALLOW_EMPTY_MIGRATIONS=false
PASSTHROUGH_ARGS=()

for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN=true
      ;;
    --non-interactive|-y)
      NON_INTERACTIVE=true
      PASSTHROUGH_ARGS+=("$arg")
      ;;
    --allow-empty-migrations)
      ALLOW_EMPTY_MIGRATIONS=true
      ;;
    *)
      PASSTHROUGH_ARGS+=("$arg")
      ;;
  esac
done

if [[ -z "$DB_USER" || -z "$DB_NAME" ]]; then
  echo "[ERROR] POSTGRES_USER and POSTGRES_DB must be set in .env."
  exit 1
fi

if [[ ! "$DB_PORT" =~ ^[0-9]+$ ]]; then
  echo "[ERROR] POSTGRES_PORT must be numeric."
  exit 1
fi

# Restrict identifiers used in generated SQL.
if [[ ! "$DB_NAME" =~ ^[A-Za-z0-9_-]+$ ||
      ! "$DB_USER" =~ ^[A-Za-z0-9_-]+$ ]]; then
  echo "[ERROR] Unsupported characters in POSTGRES_USER or POSTGRES_DB."
  exit 1
fi

if ! command -v psql >/dev/null 2>&1; then
  echo "[ERROR] psql client not found. Install it (e.g. postgresql-client)."
  exit 1
fi

# Password is passed via environment so it never appears in the process list.
export PGPASSWORD="$DB_PASSWORD"

echo "=========================================="
echo "EasyKit PostgreSQL Migration"
echo "=========================================="
echo "Project   : $PROJECT_DIR"
echo "Host      : $DB_HOST"
echo "Port      : $DB_PORT"
echo "Database  : $DB_NAME"
echo "User      : $DB_USER"
echo "Dry run   : $DRY_RUN"
echo "=========================================="

# Run psql against the existing PostgreSQL server.
psql_db() {
  local database="$1"
  shift

  psql -X -v ON_ERROR_STOP=1 \
    -h "$DB_HOST" -p "$DB_PORT" \
    -U "$DB_USER" -d "$database" "$@"
}

# Execute one SQL statement.
run_sql() {
  local sql="$1"

  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] SQL: $sql"
    return 0
  fi

  psql_db "$DB_NAME" -t -A -c "$sql"
}

# Execute a SQL file.
run_file() {
  local file="$1"

  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] Would execute: $file"
    return 0
  fi

  echo "   Executing: $file"
  psql_db "$DB_NAME" -q < "$file"
}

# Execute a read-only query. Always runs, even in --dry-run.
query_sql() {
  psql_db "$DB_NAME" -t -A -c "$1"
}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Parse CREATE TABLE blocks from a schema file.
# Output (tab separated): table <TAB> column <TAB> definition
# Expects one column per line and a closing ");" on its own line.
parse_schema_columns() {
  awk '
    { line = $0; gsub(/\r/, "", line); sub(/--.*$/, "", line) }
    in_table == 0 {
      if (match(toupper(line), /CREATE[ \t]+TABLE[ \t]+(IF[ \t]+NOT[ \t]+EXISTS[ \t]+)?/)) {
        rest = substr(line, RSTART + RLENGTH)
        sub(/[ \t]*\(.*$/, "", rest)
        sub(/^"?public"?\./, "", rest)
        quoted = (index(rest, "\"") > 0)
        gsub(/"/, "", rest)
        if (!quoted) rest = tolower(rest)
        table = rest
        in_table = 1
      }
      next
    }
    in_table == 1 {
      if (line ~ /^[ \t]*\)/) { in_table = 0; next }
      tmp = line
      sub(/^[ \t]+/, "", tmp)
      if (tmp == "") next
      upper = toupper(tmp)
      if (upper ~ /^(CONSTRAINT|PRIMARY[ \t]+KEY|FOREIGN[ \t]+KEY|UNIQUE|CHECK|LIKE|EXCLUDE)([ \t(]|$)/) next
      if (substr(tmp, 1, 1) == "\"") {
        qend = index(substr(tmp, 2), "\"")
        col = substr(tmp, 2, qend - 1)
        def = substr(tmp, qend + 2)
      } else {
        if (!match(tmp, /^[A-Za-z0-9_]+/)) next
        col = tolower(substr(tmp, 1, RLENGTH))
        def = substr(tmp, RLENGTH + 1)
      }
      sub(/^[ \t]+/, "", def)
      sub(/[ \t,]+$/, "", def)
      if (def == "") next
      printf "%s\t%s\t%s\n", table, col, def
    }
  ' "$1"
}

# Compare the columns in a schema file with the live database.
#  - column in file, missing in DB  -> ALTER TABLE ... ADD COLUMN (automatic)
#  - column in DB, missing in file  -> ask yes/no, DROP COLUMN only on yes
sync_schema_file() {
  local file="$1"
  local parsed="${TMP_DIR}/parsed.tsv"
  local db_cols="${TMP_DIR}/db_cols.txt"
  local file_cols="${TMP_DIR}/file_cols.txt"
  local tables table exists t col def sql answer added

  parse_schema_columns "$file" > "$parsed"

  if [[ ! -s "$parsed" ]]; then
    echo "   [INFO] No CREATE TABLE definition found in $file; column sync skipped."
    return 0
  fi

  tables="$(cut -f1 "$parsed" | sort -u)"

  while IFS= read -r table <&3; do
    [[ -z "$table" ]] && continue

    if [[ ! "$table" =~ ^[A-Za-z0-9_]+$ ]]; then
      echo "   [WARNING] Unsupported table name '$table'; skipped."
      continue
    fi

    echo "   Column sync: $table"

    exists="$(query_sql "SELECT COUNT(*) FROM information_schema.tables
                         WHERE table_schema = 'public'
                         AND table_name = '${table}';" | tr -d '[:space:]')"

    if [[ "$exists" != "1" ]]; then
      echo "   [INFO] Table '$table' is not in the database yet; nothing to compare."
      continue
    fi

    query_sql "SELECT column_name FROM information_schema.columns
               WHERE table_schema = 'public'
               AND table_name = '${table}'
               ORDER BY ordinal_position;" > "$db_cols"

    awk -F'\t' -v t="$table" '$1 == t { print $2 }' "$parsed" > "$file_cols"

    # --- New columns: add automatically -------------------------------
    added=0
    while IFS=$'\t' read -r t col def <&4; do
      [[ "$t" == "$table" ]] || continue

      if [[ ! "$col" =~ ^[A-Za-z0-9_]+$ ]]; then
        echo "   [WARNING] Unsupported column name '$col'; skipped."
        continue
      fi

      if grep -Fxq -- "$col" "$db_cols"; then
        continue
      fi

      sql="ALTER TABLE \"${table}\" ADD COLUMN IF NOT EXISTS \"${col}\" ${def};"
      echo "   + Adding column \"${col}\""
      run_sql "$sql"
      added=$((added + 1))
    done 4< "$parsed"

    # --- Removed columns: ask before dropping -------------------------
    while IFS= read -r col <&4; do
      [[ -z "$col" ]] && continue

      if grep -Fxq -- "$col" "$file_cols"; then
        continue
      fi

      if [[ ! "$col" =~ ^[A-Za-z0-9_]+$ ]]; then
        echo "   [WARNING] Column '$col' not in schema file but has unsupported characters; kept."
        continue
      fi

      if [[ "$DRY_RUN" == true ]]; then
        echo "   [DRY-RUN] Column \"${table}\".\"${col}\" is not in $file; would ask to drop it."
        continue
      fi

      if [[ "$NON_INTERACTIVE" == true || ! -t 0 ]]; then
        echo "   [WARNING] Column \"${table}\".\"${col}\" is not in $file; kept (non-interactive, never dropped automatically)."
        continue
      fi

      printf '   Column "%s"."%s" is in the database but not in %s.\n   Drop it and all its data? [y/N]: ' \
        "$table" "$col" "$file"
      read -r answer

      case "$answer" in
        y|Y|yes|YES|Yes)
          run_sql "ALTER TABLE \"${table}\" DROP COLUMN IF EXISTS \"${col}\";"
          echo "   - Dropped column \"${col}\""
          ;;
        *)
          echo "   Kept column \"${col}\""
          ;;
      esac
    done 4< "$db_cols"

    if [[ "$added" -eq 0 ]]; then
      echo "   [OK] No new columns for $table"
    fi
  done 3<<< "$tables"
}

# Dump every public table (except schema_migrations) as CREATE TABLE blocks
# holding column name, data type, default and NOT NULL. Constraints and
# indexes are not included. The output can be read by parse_schema_columns.
dump_schema() {
  psql_db "$DB_NAME" -t -A -F $'\t' -c "
    SELECT c.relname,
           a.attname,
           format_type(a.atttypid, a.atttypmod),
           a.attnotnull,
           COALESCE(pg_get_expr(d.adbin, d.adrelid), '')
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_attribute a ON a.attrelid = c.oid
                       AND a.attnum > 0
                       AND NOT a.attisdropped
                       AND a.attgenerated = ''
    LEFT JOIN pg_attrdef d ON d.adrelid = c.oid
                          AND d.adnum = a.attnum
    WHERE n.nspname = 'public'
      AND c.relkind = 'r'
      AND c.relname <> 'schema_migrations'
    ORDER BY c.relname, a.attnum;" |
  awk -F'\t' '
    function flush(   i) {
      if (table == "") return
      printf "CREATE TABLE IF NOT EXISTS \"%s\" (\n", table
      for (i = 1; i <= n; i++) printf "%s%s\n", cols[i], (i < n ? "," : "")
      print ");"
      print ""
    }
    {
      if ($1 != table) { flush(); table = $1; n = 0 }
      def = "    \"" $2 "\" " $3
      if ($5 != "") def = def " DEFAULT " $5
      if ($4 == "t") def = def " NOT NULL"
      cols[++n] = def
    }
    END { flush() }
  '
}

# Write migrations/schema_<version>.sql after a successful run so that
# scripts/rollback.sh can restore this schema state later.
# Skipped when nothing changed since the latest snapshot.
create_schema_snapshot() {
  local body="${TMP_DIR}/schema_snapshot.sql"
  local latest="" f version out

  dump_schema > "$body"

  if [[ ! -s "$body" ]]; then
    echo "[INFO] No tables found; schema snapshot skipped."
    return 0
  fi

  for f in migrations/schema_*.sql; do
    if [[ -f "$f" ]]; then
      latest="$f"
    fi
  done

  if [[ -n "$latest" ]] && diff -q \
      <(sed -e '/^--/d' -e '/^[[:space:]]*$/d' "$latest") \
      <(sed -e '/^[[:space:]]*$/d' "$body") >/dev/null; then
    echo "[SKIP] Schema unchanged since ${latest}; no new snapshot written."
    return 0
  fi

  mkdir -p migrations
  version="$(date +%Y%m%d%H%M%S)"
  out="migrations/schema_${version}.sql"

  {
    echo "-- EasyKit schema snapshot"
    echo "-- Version   : ${version}"
    echo "-- Database  : ${DB_NAME}"
    echo "-- Generated : $(date '+%Y-%m-%d %H:%M:%S %z')"
    echo "-- Restore   : scripts/rollback.sh ${version}"
    echo
    cat "$body"
  } > "$out"

  echo "[OK] Schema snapshot written: $out"
}

# 1. Verify the configured role can connect to PostgreSQL.
if ! psql_db postgres -c "SELECT current_user, current_database();" >/dev/null; then
  echo "[ERROR] Cannot connect to ${DB_HOST}:${DB_PORT} as '$DB_USER'."
  echo "Check POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD."
  exit 1
fi

# 2. Confirm the target database already exists.
DB_EXISTS="$(
  psql_db postgres -t -A \
    -c "SELECT COUNT(*) FROM pg_database WHERE datname = '${DB_NAME}';"
)"
DB_EXISTS="$(echo "$DB_EXISTS" | tr -d '[:space:]')"

if [[ "$DB_EXISTS" != "1" ]]; then
  echo "[ERROR] Database '$DB_NAME' does not exist."
  echo "No database was created and no migrations were applied."
  echo "Verify POSTGRES_DB and the intended PostgreSQL server."
  exit 1
fi

echo "[OK] Connection, role, and target database verified."

# 3. Handle rollback before normal migration processing.
if [[ "${PASSTHROUGH_ARGS[0]:-}" == "rollback" ]]; then
  TARGET_VERSION="${PASSTHROUGH_ARGS[1]:-}"

  if [[ ! "$TARGET_VERSION" =~ ^[0-9]{14}$ ]]; then
    echo "[ERROR] Supply a 14-digit rollback target version."
    echo "Usage: scripts/migrate.sh rollback YYYYMMDDHHMMSS [--dry-run]"
    exit 1
  fi

  TRACKING_EXISTS="$(
    psql_db "$DB_NAME" -t -A \
      -c "SELECT COUNT(*) FROM information_schema.tables
          WHERE table_schema = 'public'
          AND table_name = 'schema_migrations';"
  )"
  TRACKING_EXISTS="$(echo "$TRACKING_EXISTS" | tr -d '[:space:]')"

  if [[ "$TRACKING_EXISTS" != "1" ]]; then
    echo "[INFO] No schema_migrations table exists; nothing to roll back."
    exit 0
  fi

  APPLIED="$(
    psql_db "$DB_NAME" -t -A \
      -c "SELECT version FROM schema_migrations
          WHERE version > '${TARGET_VERSION}'
          ORDER BY version DESC;"
  )"

  if [[ -z "$APPLIED" ]]; then
    echo "[INFO] No migrations newer than ${TARGET_VERSION}."
    exit 0
  fi

  shopt -s nullglob

  while IFS= read -r version; do
    [[ -z "$version" ]] && continue

    forward_file=""

    for file in migrations/v"${version}"_*.sql; do
      [[ -f "$file" ]] || continue
      [[ "$file" == *.rollback.sql ]] && continue
      forward_file="$file"
      break
    done

    if [[ -z "$forward_file" ]]; then
      echo "[ERROR] Forward migration not found for $version."
      exit 1
    fi

    rollback_file="${forward_file%.sql}.rollback.sql"

    if [[ ! -f "$rollback_file" ]]; then
      echo "[ERROR] Rollback file missing: $rollback_file"
      exit 1
    fi

    echo "-> Rolling back $version"

    run_file "$rollback_file"

    run_sql "DELETE FROM schema_migrations WHERE version = '${version}';"
    echo "[OK] Rollback processed: $version"
  done <<< "$APPLIED"

  echo "[OK] Rollback processing completed."
  exit 0
fi

# 4. Load migration files and exclude rollback scripts.
shopt -s nullglob
MIGRATION_FILES=()

for file in migrations/v*.sql; do
  [[ -f "$file" ]] || continue
  [[ "$file" == *.rollback.sql ]] && continue

  filename="$(basename "$file")"

  if [[ "$filename" =~ ^v([0-9]{14})_.+\.sql$ ]]; then
    MIGRATION_FILES+=("$file")
  else
    echo "[WARNING] Ignoring migration with invalid filename: $file"
  fi
done

if [[ ${#MIGRATION_FILES[@]} -eq 0 ]]; then
  if [[ "$ALLOW_EMPTY_MIGRATIONS" != true ]]; then
    echo "[ERROR] No valid versioned migration files found."
    echo "Expected: migrations/vYYYYMMDDHHMMSS_description.sql"
    echo "Use --allow-empty-migrations only if this is intentional."
    exit 1
  fi
fi

if [[ ${#MIGRATION_FILES[@]} -gt 0 ]]; then
  # Portable sort (macOS ships bash 3.2, which has no mapfile).
  SORTED_FILES=()
  while IFS= read -r sorted_file; do
    SORTED_FILES+=("$sorted_file")
  done < <(printf '%s\n' "${MIGRATION_FILES[@]}" | sort)
  MIGRATION_FILES=("${SORTED_FILES[@]}")
fi

# 5. Create migration tracking table.
if [[ "$DRY_RUN" == true ]]; then
  echo "[DRY-RUN] Would ensure schema_migrations exists."
else
  run_sql "CREATE TABLE IF NOT EXISTS schema_migrations (
    version VARCHAR(14) PRIMARY KEY,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()
  );"
fi

# 6. Execute base table scripts.
if [[ -d "tables" ]]; then
  echo
  echo "STEP 1: Base table scripts"

  for file in tables/*.sql; do
    [[ -f "$file" ]] || continue
    run_file "$file"
    sync_schema_file "$file"
  done
fi

# 7. Apply versioned migrations exactly once.
echo
echo "STEP 2: Versioned migrations"

for file in ${MIGRATION_FILES[@]+"${MIGRATION_FILES[@]}"}; do
  filename="$(basename "$file")"
  version="${filename:1:14}"

  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] Would check and apply $file"
    continue
  fi

  applied="$(
    run_sql "SELECT COUNT(*) FROM schema_migrations
             WHERE version = '${version}';"
  )"
  applied="$(echo "$applied" | tr -d '[:space:]')"

  if [[ "$applied" == "1" ]]; then
    echo "[SKIP] Already applied: $file"
    continue
  fi

  echo "-> Applying $file"

  # Stop on SQL errors. Record a migration only after it succeeds.
  run_file "$file"
  run_sql "INSERT INTO schema_migrations (version)
           VALUES ('${version}');"

  echo "[OK] Applied migration $version"
done

# 8. Constraints are applied only if provided by your project.
# Prefer idempotent constraint scripts or version them as migrations.
if [[ -d "constraints" ]]; then
  echo
  echo "STEP 3: Constraint scripts"

  for file in constraints/*.sql; do
    [[ -f "$file" ]] || continue
    run_file "$file"
  done
fi

# 9. Record the resulting schema so scripts/rollback.sh can restore it.
echo
echo "STEP 4: Schema snapshot"

if [[ "$DRY_RUN" == true ]]; then
  echo "[DRY-RUN] Would write migrations/schema_<version>.sql"
else
  create_schema_snapshot
fi

echo
echo "=========================================="
if [[ "$DRY_RUN" == true ]]; then
  echo "DRY-RUN completed. No database changes made."
else
  echo "Migration processing completed."
fi
echo "=========================================="