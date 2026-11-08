#!/usr/bin/env bash

# Purpose: Create a timestamped PostgreSQL custom-format (.dump) backup.
# Usage:   ./scripts/backup.sh
set -euo pipefail
# Always run from project root
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
BACKUP_DIR="${BACKUP_DIR:-./backups}"
# Create backup directory
mkdir -p "${BACKUP_DIR}"
# Timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
# Backup filename
FILENAME="${BACKUP_DIR}/${POSTGRES_DB}_backup_${TIMESTAMP}.dump"
echo "======================================"
echo "🗄️  EasyKit PostgreSQL Backup"
echo "======================================"
echo "Container : ${POSTGRES_CONTAINER_NAME}"
echo "Database  : ${POSTGRES_DB}"
echo "User      : ${POSTGRES_USER}"
echo "Output    : ${FILENAME}"
echo "======================================"
# Check container exists/running
if ! docker inspect -f '{{.State.Running}}' "${POSTGRES_CONTAINER_NAME}" 2>/dev/null | grep -q "true"; then
    echo "❌ PostgreSQL container is not running:"
    echo "   ${POSTGRES_CONTAINER_NAME}"
    exit 1
fi
echo "▶ Creating custom-format backup..."
# IMPORTANT:
# Do NOT use -t / --tty here.
# pg_dump -Fc produces a binary dump and TTY output can corrupt it.
docker exec \
    "${POSTGRES_CONTAINER_NAME}" \
    pg_dump \
        -U "${POSTGRES_USER}" \
        -d "${POSTGRES_DB}" \
        -Fc \
    > "${FILENAME}"

echo "✓ Backup completed successfully"
echo "✓ File: ${FILENAME}"

# Show file size
if command -v du >/dev/null 2>&1; then
    echo "✓ Size: $(du -h "${FILENAME}" | cut -f1)"
fi

echo "======================================"