-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "roles" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "roleName" VARCHAR(50) NOT NULL UNIQUE,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "description"VARCHAR(200),
    "isActive" BOOLEAN DEFAULT TRUE
);

-- for supper admin is active fale


