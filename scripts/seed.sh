#!/usr/bin/env bash
# Works on bash 3.2+ (macOS default) and BSD/GNU coreutils.
set -euo pipefail
# ---------------------------------------------------------------------------
# Load .env safely (no export/xargs word-splitting problems)
# - skips blank lines and comments (including indented ones)
# - strips inline " # comments" for unquoted values
# - supports "double" and 'single' quoted values
# ---------------------------------------------------------------------------
load_env() {
    local file="$1" line key value q
    while IFS= read -r line || [ -n "$line" ]; do
        line="${line%$'\r'}"                           # strip Windows CR
        line="${line#"${line%%[![:space:]]*}"}"        # trim leading whitespace
        [[ -z "$line" || "$line" == \#* ]] && continue
        line="${line#export }"
        [[ "$line" != *=* ]] && continue

        key="${line%%=*}"
        value="${line#*=}"
        key="${key//[[:space:]]/}"
        [[ ! "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] && continue

        if [[ "$value" == \"* || "$value" == \'* ]]; then
            q="${value:0:1}"
            value="${value:1}"
            value="${value%%"$q"*}"                    # up to closing quote
        else
            value="${value%%[[:space:]]#*}"            # drop inline comment
            value="${value%"${value##*[![:space:]]}"}" # trim trailing whitespace
        fi

        export "$key=$value"
    done < "$file"
}

if [ -f .env ]; then
    load_env .env
fi

POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-vstay-db}"
POSTGRES_USER="${POSTGRES_USER:-easykit_user}"
SEED_DIR="${SEED_DIR:-./seeds}"

echo "======================================"
echo "🌱 EasyKit PostgreSQL Seed"
echo "======================================"
echo "Container : $POSTGRES_CONTAINER_NAME"
echo "Database  : $POSTGRES_DB"
echo "User      : $POSTGRES_USER"
echo "Seed dir  : $SEED_DIR"
echo "======================================"

# ---------------------------------------------------------------------------
# Collect seed files in numeric order (1, 2, ... 9, 10, 11 ...)
# Sorts on the leading number of the filename; no `sort -V` or `mapfile` needed.
# ---------------------------------------------------------------------------
files=()
while IFS= read -r f; do
    files+=("$f")
done < <(
    for p in "$SEED_DIR"/*.sql; do
        [ -e "$p" ] || continue
        n="$(basename "$p")"
        n="${n%%_*}"
        printf '%s\t%s\n' "$n" "$p"
    done | sort -n -k1,1 | cut -f2-
)

# ---------------------------------------------------------------------------
# Run each file
# ---------------------------------------------------------------------------
for file in "${files[@]}"; do
    echo ""
    echo "▶ Running: $file"

    docker exec -i "$POSTGRES_CONTAINER_NAME" \
        psql \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -v ON_ERROR_STOP=1 \
        < "$file"

    echo "✓ Completed: $file"
done

echo ""
echo "======================================"
echo "✅ All seed files completed"
echo "======================================"