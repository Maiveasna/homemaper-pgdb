#!/usr/bin/env bash
# Purpose: Restore a PostgreSQL custom-format (.dump) backup.
#          This replaces existing database objects.
#
# Usage:
#   ./scripts/restore.sh backups/easykit_db_backup_YYYYMMDD_HHMMSS.dump
set -euo pipefail
# Check argument
if [ -z "${1:-}" ]; then
    echo "❌ Usage: ./scripts/restore.sh <path_to_backup_file.dump>"
    exit 1
fi

# Resolve project root first
cd "$(dirname "$0")/.."

# Load environment variables
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "❌ Error: .env file not found."
    exit 1
fi

# Required configuration
POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-easykit-postgres}"
POSTGRES_DB="${POSTGRES_DB:-easykit_db}"
POSTGRES_USER="${POSTGRES_USER:-easykit_user}"

# Resolve backup file to absolute path
BACKUP_FILE="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"

# Check backup exists
if [ ! -f "${BACKUP_FILE}" ]; then
    echo "❌ Error: Backup file does not exist:"
    echo "   ${BACKUP_FILE}"
    exit 1
fi

echo "======================================"
echo "♻️  EasyKit PostgreSQL Restore"
echo "======================================"
echo "Container : ${POSTGRES_CONTAINER_NAME}"
echo "Database  : ${POSTGRES_DB}"
echo "User      : ${POSTGRES_USER}"
echo "Backup    : ${BACKUP_FILE}"
echo "======================================"

# Check container is running
if ! docker inspect -f '{{.State.Running}}' "${POSTGRES_CONTAINER_NAME}" 2>/dev/null | grep -q "true"; then
    echo "❌ PostgreSQL container is not running:"
    echo "   ${POSTGRES_CONTAINER_NAME}"
    exit 1
fi

# Display backup size
if command -v du >/dev/null 2>&1; then
    echo "Backup size: $(du -h "${BACKUP_FILE}" | cut -f1)"
fi

echo ""
echo "⚠️  WARNING"
echo "This will replace existing database objects in:"
echo "Database: ${POSTGRES_DB}"
echo ""

read -r -p "Continue restore? [y/N]: " CONFIRM

if [[ ! "${CONFIRM}" =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled."
    exit 0
fi

echo ""
echo "▶ Restoring database..."

docker exec -i \
    "${POSTGRES_CONTAINER_NAME}" \
    pg_restore \
        -U "${POSTGRES_USER}" \
        -d "${POSTGRES_DB}" \
        --clean \
        --if-exists \
        --no-owner \
    < "${BACKUP_FILE}"

echo ""
echo "✓ Restore completed successfully"
echo "======================================"