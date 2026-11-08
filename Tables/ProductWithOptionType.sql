-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "productWithOptionType" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(50) NOT NULL,
    "porductOptionTypeId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "companyId" UUID DEFAULT '00000000-0000-0000-0000-000000000000',
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE'
);

