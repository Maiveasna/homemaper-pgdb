#!/usr/bin/env bash
set -e
# Detect git column rename or dropped column risks
check_column_renames() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        DELETIONS=$(git diff -U0 tables/ | grep -E "^\-[[:space:]]+\"[A-Za-z0-9_]+\"" || true)
        if [ -n "$DELETIONS" ]; then
            echo "=========================================================="
            echo "WARNING: DETECTED REMOVED OR RENAMED COLUMN(S) IN SCHEMA:"
            echo "$DELETIONS"
            echo "=========================================================="
            read -p "Are you sure you want to proceed? Data loss may occur on field changes! (yes/no): " CONFIRM
            if [ "$CONFIRM" != "yes" ]; then
                echo "Conversion aborted by QA safety check."
                exit 1
            fi
        fi
    fi
}

echo "Converting T-SQL schema to PostgreSQL..."
check_column_renames

# Generate schema tables
python3 scripts/convert_to_postgres.py Tables/ -o tables/

# Create versioned timestamped migration file if changes exist
TIMESTAMP=$(date +%Y%m%d%H%M%S)
TEMP_ALTER="migrations/temp_alter.sql"
python3 scripts/convert_to_postgres.py Tables/ --alter-out "$TEMP_ALTER"

MIGRATION_FILE="migrations/v${TIMESTAMP}_schema_update.sql"
mv "$TEMP_ALTER" "$MIGRATION_FILE"

echo "Generated versioned migration: $MIGRATION_FILE"