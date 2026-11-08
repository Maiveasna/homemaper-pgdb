# PostgreSQL Database Migration

Automated database schema conversion and migration for the EasyKit project.

## Overview

The deployment pipeline executes these steps in order:

1. **Convert** — Convert SQL Server schema files into PostgreSQL-compatible SQL.
2. **Migrate** — Apply base tables, versioned migrations, and constraints to the existing PostgreSQL database.

The pipeline stops immediately if a step fails. It does not automatically recreate the PostgreSQL container or delete database volumes.

## Project Structure

```text
posgress-db/
├── .env
├── docker-compose.yml
├── README.md
├── scripts/
│   ├── deploy.sh
│   ├── convert.sh
│   ├── convert_to_postgres.py
│   └── migrate.sh
├── tables/
│   └── *.sql
├── migrations/
│   ├── v20261012090000_initial_schema.sql
│   └── v20261012090000_initial_schema.rollback.sql
├── constraints/
│   └── *.sql
├── seeds/
│   └── *.sql
└── backups/
```

*The structure above is illustrative. Keep the conversion script and migration directories that actually exist in your project.*

## Requirements

- Docker and Docker Compose
- Python 3, if using `convert_to_postgres.py`
- A running PostgreSQL container
- Project `.env` file
- SQL schema and migration files

## Environment Configuration

Configure the `.env` file to match your existing PostgreSQL instance.

```dotenv
POSTGRES_VERSION=17
POSTGRES_CONTAINER_NAME=easykit-postgres

POSTGRES_DB=easykit_db
POSTGRES_USER=easykit_user
POSTGRES_PASSWORD=change_this_secure_password

POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_BIND_ADDRESS=127.0.0.1

BACKUP_DIR=./backups
```

**Important:**

- Replace the example database, username, password, and container name with your actual settings.
- Do not commit `.env` or production credentials to Git.
- If PostgreSQL is already running, verify its actual container name and database before deploying.
- Changing `POSTGRES_DB` in `.env` does not automatically create that database in an already initialized PostgreSQL data volume.

## Installation

From the project root:

```bash
chmod +x scripts/deploy.sh
chmod +x scripts/migrate.sh
```

If your project uses `scripts/convert.sh`:

```bash
chmod +x scripts/convert.sh
```

## Deployment

### 1. Validate the deployment script

```bash
bash -n scripts/deploy.sh
bash -n scripts/migrate.sh
```

### 2. Check the PostgreSQL container

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Confirm that the container name matches `POSTGRES_CONTAINER_NAME` in `.env`.

### 3. Run a dry run

```bash
./scripts/deploy.sh --dry-run
```

The deployment script skips conversion during dry-run mode. Confirm that `scripts/migrate.sh` also honors `--dry-run` and does not modify the database.

### 4. Execute the migration

```bash
./scripts/deploy.sh
```

The expected sequence is:

```text
Validate configuration
        |
        v
Validate PostgreSQL container
        |
        v
Convert SQL Server schema
        |
        v
Apply PostgreSQL migrations
        |
        v
Deployment completed
```

If conversion fails, migration will not run. If migration fails, deployment stops and reports the error.

## Migration File Naming

Use versioned migration files to track changes.

```text
migrations/
├── v20261012090000_create_users.sql
├── v20261012090000_create_users.rollback.sql
├── v20261012100000_create_products.sql
└── v20261012100000_create_products.rollback.sql
```

Use unique timestamps for every migration. Do not reuse a version number for different migrations.

- `vYYYYMMDDHHMMSS_description.sql` — forward migration.
- `vYYYYMMDDHHMMSS_description.rollback.sql` — rollback SQL for the corresponding migration.

Follow the exact filename format supported by your `migrate.sh` script.

## Database Directory Responsibilities

| Directory | Purpose |
|---|---|
| `tables/` | Base table definitions |
| `migrations/` | Versioned schema changes |
| `constraints/` | Foreign keys, indexes, and other constraints |
| `seeds/` | Optional initial or reference data |
| `backups/` | Database backup files |

Ensure that SQL files are compatible with PostgreSQL before applying them.

## Useful Commands

### View container logs

```bash
docker logs --tail 200 easykit-postgres
```

Replace `easykit-postgres` with the actual container name.

### Connect to PostgreSQL

```bash
docker exec -it easykit-postgres \
  psql -U easykit_user -d easykit_db
```

Replace the container, user, and database with your actual values.

### Check the database version

```sql
SELECT version();
```

### List tables

```sql
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;
```

### Check migration history

If your migration script uses `schema_migrations`:

```sql
SELECT *
FROM schema_migrations
ORDER BY version;
```

## Rollback

Use the rollback command supported by your migration script. For example, if `scripts/migrate.sh` implements `rollback`:

```bash
./scripts/migrate.sh rollback
```

Check the script's argument handling before running this command in production.

**Important:** A schema rollback is not a substitute for a database backup. Back up important data before applying migrations, especially migrations that modify or remove columns.

## Troubleshooting

### PostgreSQL container not found

```bash
docker ps -a --format 'table {{.Names}}\t{{.Status}}'
```

Update `POSTGRES_CONTAINER_NAME` in `.env` to match the intended existing container.

### Database does not exist

Connect to an existing administrative database and inspect available databases:

```bash
docker exec -it easykit-postgres \
  psql -U YOUR_EXISTING_ADMIN_USER -d postgres \
  -c '\l'
```

Do not recreate the container or delete its volume to resolve a database-name mismatch.

### Authentication failed

Verify the actual database role and password configuration. Do not assume that `POSTGRES_USER` and `POSTGRES_PASSWORD` in `.env` reflect the credentials of a database volume initialized previously.

### Migration fails

Inspect the error and migration file:

```bash
docker logs --tail 200 easykit-postgres
```

Resolve the SQL error before rerunning. Check whether the migration partially applied changes and whether the migration history was recorded.

## Production Safety

- Back up the database before migration.
- Test migrations on a staging database first.
- Use unique migration versions.
- Review SQL that drops or alters columns.
- Avoid destructive automatic schema synchronization.
- Do not use `docker compose down -v` on a database containing important data.
- Keep database credentials out of version control.
- Verify table counts, indexes, foreign keys, and important data after migration.

## License

Specify the license for this project if it will be distributed or shared.
