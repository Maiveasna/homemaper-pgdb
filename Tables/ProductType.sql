-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "productType" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "slug" TEXT, -- Consider adding UNIQUE constraint if needed
    "companyId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- Link to Company, default zero-UUID
    "name" VARCHAR(150) NOT NULL, -- Product name
    "description" VARCHAR(200), -- Detailed description
    "order" INT DEFAULT 0,
    "image" VARCHAR(300),
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "isActive" BOOLEAN DEFAULT TRUE
);

