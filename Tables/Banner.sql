-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "banner" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "title" VARCHAR(255) NOT NULL,
    "imageUrl" VARCHAR(500) NOT NULL,
    "description" TEXT NULL,
    "redirectUrl" VARCHAR(500) NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "startDate" TIMESTAMPTZ NULL,
    "endDate" TIMESTAMPTZ NULL,
    "position" VARCHAR(30) NULL,
    "categoryId" UUID NOT NULL,
    "service" VARCHAR(200) DEFAULT 'all',
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "companyId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'
);

