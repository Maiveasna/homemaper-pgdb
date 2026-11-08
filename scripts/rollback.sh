#!/usr/bin/env bash
set -Eeuo pipefail

# EasyKit schema rollback.
#
# Restores the table/column layout recorded in migrations/schema_<version>.sql
# (written by scripts/migrate.sh after every successful run that changed the
# schema).
#
#   scripts/rollback.sh list
#   scripts/rollback.sh YYYYMMDDHHMMSS [--dry-run] [--non-interactive]
#
# Missing tables and columns are re-created. Anything that exists now but is
# NOT in the chosen version is dropped only after you answer "y"; the default
# answer is "no" (keep). --non-interactive never drops anything.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_DIR"

shopt -s nullglob

usage() {
  echo "Usage:"
  echo "  scripts/rollback.sh list"
  echo "  scripts/rollback.sh YYYYMMDDHHMMSS [--dry-run] [--non-interactive]"
}

list_snapshots() {
  local found=false f version

  echo "Available schema versions (migrations/schema_<version>.sql):"

  for f in migrations/schema_*.sql; do
    [[ -f "$f" ]] || continue
    version="${f##*/schema_}"
    version="${version%.sql}"
    echo "  ${version}   ${f}"
    found=true
  done

  if [[ "$found" != true ]]; then
    echo "  (none yet - run scripts/migrate.sh first)"
  fi
}

MODE="rollback"
VERSION=""
DRY_RUN=false
NON_INTERACTIVE=false

for arg in "$@"; do
  case "$arg" in
    list)
      MODE="list"
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    --non-interactive|-y)
      NON_INTERACTIVE=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ "$arg" =~ ^[0-9]{14}$ ]]; then
        VERSION="$arg"
      else
        echo "[ERROR] Unknown argument: $arg"
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ "$MODE" == "list" ]]; then
  list_snapshots
  exit 0
fi

if [[ -z "$VERSION" ]]; then
  echo "[ERROR] Supply the schema version to roll back to."
  usage
  echo
  list_snapshots
  exit 1
fi

SNAPSHOT_FILE="migrations/schema_${VERSION}.sql"

if [[ ! -f "$SNAPSHOT_FILE" ]]; then
  echo "[ERROR] Schema snapshot not found: $SNAPSHOT_FILE"
  echo
  list_snapshots
  exit 1
fi

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

if [[ -z "$DB_USER" || -z "$DB_NAME" ]]; then
  echo "[ERROR] POSTGRES_USER and POSTGRES_DB must be set in .env."
  exit 1
fi

if [[ ! "$DB_PORT" =~ ^[0-9]+$ ]]; then
  echo "[ERROR] POSTGRES_PORT must be numeric."
  exit 1
fi

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
echo "EasyKit Schema Rollback"
echo "=========================================="
echo "Host      : $DB_HOST"
echo "Port      : $DB_PORT"
echo "Database  : $DB_NAME"
echo "User      : $DB_USER"
echo "Version   : $VERSION"
echo "Snapshot  : $SNAPSHOT_FILE"
echo "Dry run   : $DRY_RUN"
echo "=========================================="

psql_db() {
  local database="$1"
  shift

  psql -X -v ON_ERROR_STOP=1 \
    -h "$DB_HOST" -p "$DB_PORT" \
    -U "$DB_USER" -d "$database" "$@"
}

# Execute one SQL statement (printed only in --dry-run).
run_sql() {
  local sql="$1"

  if [[ "$DRY_RUN" == true ]]; then
    echo "   [DRY-RUN] SQL: $sql"
    return 0
  fi

  psql_db "$DB_NAME" -q -t -A -c "$sql"
}

# Read-only query returning tab-separated rows. Always runs, even in --dry-run.
query_tsv() {
  psql_db "$DB_NAME" -t -A -F $'\t' -c "$1"
}

valid_ident() {
  [[ "$1" =~ ^[A-Za-z0-9_]+$ ]]
}

# Ask yes/no. Returns 0 only for an explicit yes. Default is no.
confirm() {
  local prompt="$1"
  local answer=""

  if [[ "$DRY_RUN" == true ]]; then
    echo "   [DRY-RUN] Would ask: ${prompt}"
    return 1
  fi

  if [[ "$NON_INTERACTIVE" == true || ! -t 0 ]]; then
    echo "   [KEEP] ${prompt} -> kept (non-interactive)."
    return 1
  fi

  printf '   %s [y/N]: ' "$prompt"
  read -r answer

  case "$answer" in
    y|Y|yes|YES|Yes) return 0 ;;
    *) return 1 ;;
  esac
}

# Parse CREATE TABLE blocks from a schema file.
# Output (tab separated): table <TAB> column <TAB> definition
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

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# 1. Verify connection and target database.
if ! psql_db postgres -c "SELECT current_user, current_database();" >/dev/null; then
  echo "[ERROR] Cannot connect to ${DB_HOST}:${DB_PORT} as '$DB_USER'."
  echo "Check POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD."
  exit 1
fi

DB_EXISTS="$(
  psql_db postgres -t -A \
    -c "SELECT COUNT(*) FROM pg_database WHERE datname = '${DB_NAME}';"
)"
DB_EXISTS="$(echo "$DB_EXISTS" | tr -d '[:space:]')"

if [[ "$DB_EXISTS" != "1" ]]; then
  echo "[ERROR] Database '$DB_NAME' does not exist. Nothing was changed."
  exit 1
fi

echo "[OK] Connection, role, and target database verified."

# 2. Load the target schema version and the live schema.
PARSED="${TMP_DIR}/snapshot.tsv"
SNAP_TABLES="${TMP_DIR}/snap_tables.txt"
SNAP_PAIRS="${TMP_DIR}/snap_pairs.txt"
DB_TABLES="${TMP_DIR}/db_tables.txt"
DB_PAIRS="${TMP_DIR}/db_pairs.txt"
CREATED="${TMP_DIR}/created_tables.txt"

parse_schema_columns "$SNAPSHOT_FILE" > "$PARSED"

if [[ ! -s "$PARSED" ]]; then
  echo "[ERROR] No table definitions found in $SNAPSHOT_FILE. Nothing was changed."
  exit 1
fi

cut -f1 "$PARSED" | sort -u > "$SNAP_TABLES"
awk -F'\t' '{ print $1 "\t" $2 }' "$PARSED" > "$SNAP_PAIRS"

query_tsv "SELECT table_name FROM information_schema.tables
           WHERE table_schema = 'public'
             AND table_type = 'BASE TABLE'
             AND table_name <> 'schema_migrations'
           ORDER BY table_name;" > "$DB_TABLES"

query_tsv "SELECT c.table_name, c.column_name
           FROM information_schema.columns c
           JOIN information_schema.tables t
             ON t.table_schema = c.table_schema
            AND t.table_name = c.table_name
           WHERE c.table_schema = 'public'
             AND t.table_type = 'BASE TABLE'
             AND c.table_name <> 'schema_migrations'
           ORDER BY c.table_name, c.ordinal_position;" > "$DB_PAIRS"

: > "$CREATED"

ADDED=0
DROPPED=0
KEPT=0

# 3. Re-create tables that exist in the target version but not now.
echo
echo "STEP 1: Restore missing tables"

while IFS= read -r table <&3; do
  [[ -z "$table" ]] && continue

  if ! valid_ident "$table"; then
    echo "   [WARNING] Unsupported table name '$table'; skipped."
    continue
  fi

  if grep -Fxq -- "$table" "$DB_TABLES"; then
    continue
  fi

  cols_sql=""

  while IFS=$'\t' read -r t col def <&4; do
    [[ "$t" == "$table" ]] || continue

    if ! valid_ident "$col"; then
      echo "   [WARNING] Unsupported column name '$col'; skipped."
      continue
    fi

    cols_sql+="${cols_sql:+, }\"${col}\" ${def}"
  done 4< "$PARSED"

  echo "   + Creating table \"${table}\" (columns only; constraints and indexes are not in the snapshot)"
  run_sql "CREATE TABLE IF NOT EXISTS \"${table}\" (${cols_sql});"
  echo "$table" >> "$CREATED"
  ADDED=$((ADDED + 1))
done 3< "$SNAP_TABLES"

# 4. Re-add columns that exist in the target version but not now.
echo
echo "STEP 2: Restore missing columns"

while IFS=$'\t' read -r t col def <&3; do
  if ! valid_ident "$t" || ! valid_ident "$col"; then
    echo "   [WARNING] Unsupported name '${t}.${col}'; skipped."
    continue
  fi

  if grep -Fxq -- "$t" "$CREATED"; then
    continue
  fi

  key="${t}"$'\t'"${col}"

  if grep -Fxq -- "$key" "$DB_PAIRS"; then
    continue
  fi

  add_def="$def"

  # A NOT NULL column without a default cannot be added to a table with rows.
  if [[ "$add_def" == *"NOT NULL"* && "$add_def" != *"DEFAULT"* ]]; then
    add_def="${add_def// NOT NULL/}"
    echo "   [WARNING] \"${t}\".\"${col}\" restored without NOT NULL (it has no default)."
  fi

  echo "   + Restoring column \"${t}\".\"${col}\""
  run_sql "ALTER TABLE \"${t}\" ADD COLUMN IF NOT EXISTS \"${col}\" ${add_def};"
  ADDED=$((ADDED + 1))
done 3< "$PARSED"

# 5. Columns that exist now but not in the target version: ask before dropping.
echo
echo "STEP 3: Columns not in version ${VERSION} (asked one by one)"

while IFS=$'\t' read -r t col <&3; do
  # Tables that are not in the snapshot at all are handled in STEP 4.
  if ! grep -Fxq -- "$t" "$SNAP_TABLES"; then
    continue
  fi

  key="${t}"$'\t'"${col}"

  if grep -Fxq -- "$key" "$SNAP_PAIRS"; then
    continue
  fi

  if ! valid_ident "$t" || ! valid_ident "$col"; then
    echo "   [WARNING] Unsupported name '${t}.${col}'; kept."
    KEPT=$((KEPT + 1))
    continue
  fi

  if confirm "Column \"${t}\".\"${col}\" is not in schema version ${VERSION}. Drop it and all its data?"; then
    if run_sql "ALTER TABLE \"${t}\" DROP COLUMN IF EXISTS \"${col}\";"; then
      echo "   - Dropped column \"${t}\".\"${col}\""
      DROPPED=$((DROPPED + 1))
    else
      echo "   [WARNING] Could not drop \"${t}\".\"${col}\"; kept."
      KEPT=$((KEPT + 1))
    fi
  else
    echo "   Kept column \"${t}\".\"${col}\""
    KEPT=$((KEPT + 1))
  fi
done 3< "$DB_PAIRS"

# 6. Tables that exist now but not in the target version: ask before dropping.
echo
echo "STEP 4: Tables not in version ${VERSION} (asked one by one)"

while IFS= read -r t <&3; do
  [[ -z "$t" ]] && continue

  if grep -Fxq -- "$t" "$SNAP_TABLES"; then
    continue
  fi

  if ! valid_ident "$t"; then
    echo "   [WARNING] Unsupported table name '${t}'; kept."
    KEPT=$((KEPT + 1))
    continue
  fi

  if confirm "Table \"${t}\" is not in schema version ${VERSION}. Drop the WHOLE table and all its rows?"; then
    # No CASCADE: tables that other objects depend on are refused by PostgreSQL.
    if run_sql "DROP TABLE IF EXISTS \"${t}\";"; then
      echo "   - Dropped table \"${t}\""
      DROPPED=$((DROPPED + 1))
    else
      echo "   [WARNING] Could not drop table \"${t}\" (dependent objects?); kept."
      KEPT=$((KEPT + 1))
    fi
  else
    echo "   Kept table \"${t}\""
    KEPT=$((KEPT + 1))
  fi
done 3< "$DB_TABLES"

echo
echo "=========================================="
if [[ "$DRY_RUN" == true ]]; then
  echo "DRY-RUN completed. No database changes made."
else
  echo "Rollback to schema version ${VERSION} processed."
  echo "Restored: ${ADDED}   Dropped: ${DROPPED}   Kept: ${KEPT}"
fi
echo "Note: tables/*.sql and schema_migrations were not changed. Revert"
echo "tables/*.sql to match this version, otherwise the next migrate.sh run"
echo "will add the removed columns again."
echo "=========================================="