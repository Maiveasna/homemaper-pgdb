#!/usr/bin/env bash
set -Eeuo pipefail

# ==========================================
# EasyKit Database Deployment
# Pipeline: Convert -> Migrate
# ==========================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_DIR"

# Load project .env
ENV_FILE="${PROJECT_DIR}/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERROR] .env file not found: $ENV_FILE"
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-easykit-postgres}"
DB_USER="${POSTGRES_USER:-}"
DB_NAME="${POSTGRES_DB:-}"

DRY_RUN=false
NON_INTERACTIVE=false
EXTRA_ARGS=()

for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN=true
      ;;
    --non-interactive|-y)
      NON_INTERACTIVE=true
      ;;
    *)
      EXTRA_ARGS+=("$arg")
      ;;
  esac
done

# ------------------------------------------
# Helper: print a section
# ------------------------------------------
print_step() {
  echo
  echo "=========================================="
  echo "$1"
  echo "=========================================="
}

# ------------------------------------------
# Helper: run a script with forwarded options
# ------------------------------------------
build_args() {
  SCRIPT_ARGS=()

  if [[ "$DRY_RUN" == true ]]; then
    SCRIPT_ARGS+=("--dry-run")
  fi

  if [[ "$NON_INTERACTIVE" == true ]]; then
    SCRIPT_ARGS+=("--non-interactive")
  fi

  SCRIPT_ARGS+=("${EXTRA_ARGS[@]}")
}

# ------------------------------------------
# Validate configuration
# ------------------------------------------
print_step "EasyKit Database Deployment"

echo "Project   : $PROJECT_DIR"
echo "Container : $CONTAINER_NAME"
echo "Database  : ${DB_NAME:-NOT CONFIGURED}"
echo "DB User   : ${DB_USER:-NOT CONFIGURED}"
echo "Pipeline  : Convert -> Migrate"
echo "Dry run   : $DRY_RUN"

if [[ -z "$DB_USER" || -z "$DB_NAME" ]]; then
  echo "[ERROR] Configure POSTGRES_USER and POSTGRES_DB in .env."
  exit 1
fi

# ------------------------------------------
# Validate existing PostgreSQL container
# ------------------------------------------
print_step "Validate PostgreSQL"

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker is not installed or unavailable."
  exit 1
fi

if ! docker inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
  echo "[ERROR] Container '$CONTAINER_NAME' was not found."
  echo
  echo "Running containers:"
  docker ps --format 'table {{.Names}}\t{{.Status}}'
  exit 1
fi

if [[ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME")" != "true" ]]; then
  echo "[ERROR] Container '$CONTAINER_NAME' is not running."
  exit 1
fi

echo "[OK] PostgreSQL container is running."

# ------------------------------------------
# Step 1: Convert schema
# ------------------------------------------
print_step "STEP 1/2: Convert schema to PostgreSQL"

if [[ "$DRY_RUN" == true ]]; then
  echo "[DRY-RUN] Conversion will be skipped."
else
  if [[ -f "$PROJECT_DIR/scripts/convert.sh" ]]; then
    chmod +x "$PROJECT_DIR/scripts/convert.sh"
    "$PROJECT_DIR/scripts/convert.sh"

  elif [[ -f "$PROJECT_DIR/scripts/convert_to_postgres.py" ]]; then
    python3 "$PROJECT_DIR/scripts/convert_to_postgres.py"

  else
    echo "[ERROR] Conversion script not found."
    echo "Expected one of:"
    echo "  scripts/convert.sh"
    echo "  scripts/convert_to_postgres.py"
    exit 1
  fi

  echo "[OK] Schema conversion completed."
fi

# ------------------------------------------
# Step 2: Apply migrations
# ------------------------------------------
print_step "STEP 2/2: Apply PostgreSQL migrations"

MIGRATE_SCRIPT="$PROJECT_DIR/scripts/migrate.sh"

if [[ ! -f "$MIGRATE_SCRIPT" ]]; then
  echo "[ERROR] Migration script not found: $MIGRATE_SCRIPT"
  exit 1
fi

chmod +x "$MIGRATE_SCRIPT"

build_args
"$MIGRATE_SCRIPT" "${SCRIPT_ARGS[@]}"

echo
echo "=========================================="
echo "[SUCCESS] Deployment completed."
echo "Schema conversion and database migration finished."
echo "=========================================="