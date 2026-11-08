-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "facilities" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

