-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "facingOption" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "facingName" VARCHAR(50) NOT NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

