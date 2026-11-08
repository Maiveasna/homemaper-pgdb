-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "propertyStatus" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(50),
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

