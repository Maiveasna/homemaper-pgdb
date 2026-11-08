-- Converted from SQL Server to PostgreSQL

CREATE TABLE IF NOT EXISTS "businessType" (
    "id" UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(100) NOT NULL,
    "description" VARCHAR(255) NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdBy" UUID NULL DEFAULT '00000000-0000-0000-0000-000000000001',
    "createdOn" TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    "modifiedBy" UUID NULL,
    "modifiedOn" TIMESTAMPTZ NULL
);

