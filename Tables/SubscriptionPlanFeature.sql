-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "subscriptionPlanFeature" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(100) NOT NULL,
    "key" VARCHAR(100) NOT NULL,
    "value" VARCHAR(200) NULL,
    "createdBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE' -- DELETED
);

