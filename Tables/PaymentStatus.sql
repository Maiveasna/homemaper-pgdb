-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "paymentStatus" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "statusName" VARCHAR(50) NOT NULL,
    "description" VARCHAR(255),
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "modifiedBy" UUID NULL,
    "createdBy" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp()
);

