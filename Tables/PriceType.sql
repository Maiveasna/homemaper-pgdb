-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "priceType" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "companyId" UUID NULL,
    "title" VARCHAR(50),
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "isDefault" BOOLEAN,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

