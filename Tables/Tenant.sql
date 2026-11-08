-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "tenant" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(100),
    "companyId" UUID NULL,
    "phone" VARCHAR(500),
    "nationalId" VARCHAR(50),
    "profile" TEXT,
    "address" TEXT,
    "documentSupport" TEXT NULL,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "linkUserId" UUID NULL
);

