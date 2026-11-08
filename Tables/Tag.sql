-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "tag" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(50) UNIQUE NOT NULL,
    "slug" VARCHAR(50) UNIQUE NOT NULL,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

