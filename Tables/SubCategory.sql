-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "subCategory" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(100) UNIQUE NOT NULL,
    "slug" VARCHAR(100) UNIQUE NOT NULL,
    "logo" TEXT NULL,
    "description" VARCHAR(500) NULL,
    "isPublished" BOOLEAN DEFAULT TRUE,
    "order" INT NULL,
    "categoryId" UUID NULL,
    "companyId" UUID NULL,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "count" INT NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE' -- DELETED
);

