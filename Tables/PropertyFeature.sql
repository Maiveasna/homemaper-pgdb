-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "propertyFeature" (
    "belongTo" UUID NOT NULL, -- property id or room id as UUID
    "featureId" UUID NOT NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

