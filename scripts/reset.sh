#!/usr/bin/env bash
# Purpose: wipe the public schema and rebuild everything from the SQL files.
# Usage:   ./scripts/reset.sh      (asks for confirmation)
set -euo pipefail

cd "$(dirname "$0")/.."

if [ -f .env ]; then
  set -a; source .env; set +a
else
  echo "Error: .env file not found."
  exit 1
fi

echo "WARNING: This will drop and recreate the public schema in '${POSTGRES_DB}'."
read -r -p "Are you sure you want to continue? (y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  docker exec -i "${POSTGRES_CONTAINER_NAME}" psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -v ON_ERROR_STOP=1 -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
  echo "==> Database reset complete."
  ./scripts/migrate.sh
else
  echo "Operation canceled."
fi
