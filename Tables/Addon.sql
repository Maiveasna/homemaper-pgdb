-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "addon" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "addonName" VARCHAR(200), -- example: coffee in the morning
    "price" DECIMAL(10,2), --  Selling price
    "companyId" UUID NULL, -- null or zero-UUID for all companies
    "isActive" BOOLEAN DEFAULT TRUE, -- addon availability flag
    "category" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    "description" VARCHAR(500), -- Detailed description
    "image" TEXT,
    "stock" INT DEFAULT 1,
    "originalPrice" DECIMAL(10,2) DEFAULT 0, -- stock price
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);



