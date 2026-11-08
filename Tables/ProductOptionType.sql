-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "productOptionType" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(50) NOT NULL,
    "productId" UUID DEFAULT '00000000-0000-0000-0000-000000000000', -- Link to Company
    "description" TEXT,
    "thumbnail" TEXT,
    "companyId" UUID DEFAULT '00000000-0000-0000-0000-000000000000', -- Link to Company
    "order" INT DEFAULT 0,
    "actionType" VARCHAR(100) DEFAULT 'Radio', -- e.g., 'Radio', 'Checkbox'
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE'
);

