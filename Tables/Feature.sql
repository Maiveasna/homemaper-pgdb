-- Converted from SQL Server to PostgreSQL
-- Create the Feature table
CREATE TABLE IF NOT EXISTS "feature" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "featureName" VARCHAR(100) NOT NULL,
    "featureType" VARCHAR(100) NOT NULL, -- 'Amenities', 'Property Features', 'Security', 'Views'
    "description" TEXT,
    "icon" VARCHAR(500),
    "status" BOOLEAN DEFAULT TRUE,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

