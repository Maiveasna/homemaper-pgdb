-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "product" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL, -- Link to Company
    "propertyId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- system booking if zero-UUID
    "barcode" VARCHAR(100) NOT NULL, -- Link to Company
    "name" VARCHAR(150) NOT NULL, -- Product name
    "description" TEXT, -- Detailed description
    "sKU" VARCHAR(50), -- Stock Keeping Unit
    "isActive" BOOLEAN DEFAULT TRUE, -- Active/Inactive flag
    "productType" UUID NULL,
    "productTypeSlug" VARCHAR(300) NULL,
    "slug" TEXT, -- Consider UNIQUE constraint if needed
    "order" INT DEFAULT 0,
    "price" DECIMAL(10,2) DEFAULT 0.00,
    "unit" VARCHAR(50) DEFAULT 'unit',
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,

    "status" VARCHAR(20) DEFAULT 'ACTIVE' -- DELETED
);

