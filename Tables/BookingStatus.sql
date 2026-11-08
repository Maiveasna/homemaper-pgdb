-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "bookingStatus" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "statusName" VARCHAR(50) NOT NULL UNIQUE, -- Name of the booking status
    "description" VARCHAR(255) NULL, -- Description of the status
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() -- Timestamp of when the status was created
);

