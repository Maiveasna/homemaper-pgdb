-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "realEstateProperty" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    "title" TEXT,
    "description" TEXT,

    "companyId" UUID NOT NULL, -- ✅ Changed from INT
    "countryId" UUID NOT NULL, -- ✅ Changed from INT
    "address" VARCHAR(500),

    "parentId" UUID NULL, -- ✅ Changed from INT
    "propertyFor" VARCHAR(10) DEFAULT 'Rent', -- Sale, Rent, Both
    "propertyType" UUID NULL, -- ✅ Changed from INT

    "status" VARCHAR(50),
    "numberOfFloor" INT DEFAULT 0,
    "isActive" BOOLEAN DEFAULT TRUE,

    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

