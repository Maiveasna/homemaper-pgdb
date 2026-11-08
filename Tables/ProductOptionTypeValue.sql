-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "productOptionTypeValue" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "productOptionTypeId" UUID NOT NULL,
  -- e.g., references "Size"
    "name" VARCHAR(50) NOT NULL,
    "description" TEXT,
    "thumbnail" TEXT,
    "companyId" UUID DEFAULT '00000000-0000-0000-0000-000000000000', -- Link to Company
  -- e.g., "Medium", "Oat", "Hazelnut"
    "price" DECIMAL(10,2) DEFAULT 0.00,
    "order" INT DEFAULT 0,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE'
);

