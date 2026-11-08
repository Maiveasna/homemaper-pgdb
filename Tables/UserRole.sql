-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "userRole" (
    "roleId" UUID NOT NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "userId" UUID NOT NULL,
    "createdBy" VARCHAR(50) NULL,
    "isActive" BOOLEAN DEFAULT TRUE
);

