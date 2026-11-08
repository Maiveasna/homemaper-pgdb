-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "propertyType" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "propertyTypeName" VARCHAR(200),
    "status" BOOLEAN DEFAULT TRUE,
    "icon" VARCHAR(500) NULL,
    "categoryType" VARCHAR(100),
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

