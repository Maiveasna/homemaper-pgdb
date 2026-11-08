-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "propertyFacilities" (
    "belongTo" UUID NOT NULL,
    "facilityId" UUID NOT NULL,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

