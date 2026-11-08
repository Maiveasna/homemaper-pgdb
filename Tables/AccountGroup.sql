-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "accountGroup" (
    "accountId" UUID NULL,
    "groupId" UUID NULL,
    "modifiedBy" UUID NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "companyId" UUID NOT NULL
);

