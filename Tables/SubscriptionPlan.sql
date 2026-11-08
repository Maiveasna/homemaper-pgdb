-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "subscriptionPlan" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(100) NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "description" VARCHAR(200),
    "option" TEXT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE', -- DELETED
    "featurePlan" TEXT
);

