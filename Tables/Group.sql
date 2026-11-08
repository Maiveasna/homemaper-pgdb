-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "group" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR (50) NOT NULL,
    "remark" VARCHAR (500) NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "companyId" UUID NOT NULL,
    "modifiedBy" UUID NULL,
    "createdBy" UUID NOT NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

