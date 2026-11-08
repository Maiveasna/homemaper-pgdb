-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "groupPermission" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "groupId" UUID NOT NULL,
    "resourceId" UUID NOT NULL,
    "canCreate" BOOLEAN DEFAULT FALSE,
    "canRead" BOOLEAN DEFAULT FALSE,
    "canUpdate" BOOLEAN DEFAULT FALSE,
    "canDelete" BOOLEAN DEFAULT FALSE,
    "canExport" BOOLEAN DEFAULT FALSE,
    "canImport" BOOLEAN DEFAULT FALSE,
    "createdBy" UUID NULL,
    "companyId" UUID NULL,
    -- null or zero-UUID for all companies
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "isActive" BOOLEAN DEFAULT TRUE
);

