-- Bootstrap: runs automatically by the Postgres image on first start,
-- and is idempotent so migrate.sh can safely run it again.
-- Purpose: database-level settings only (no tables here).

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Store and compare all timestamps in UTC
DO $$
BEGIN
  EXECUTE format('ALTER DATABASE %I SET timezone TO %L', current_database(), 'UTC');
END
$$;
