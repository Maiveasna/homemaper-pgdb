-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "realEstatePropertyPolicy" (
    "belongTo" UUID NOT NULL,
  -- 1:1 Relationship
    "parkingPolicy" VARCHAR(50),
  -- e.g. Yes Free, No, Yes Paid
    "breakfastPolicy" VARCHAR(50),
  -- e.g. Included, Not Included
    "smokingAllowed" BOOLEAN DEFAULT FALSE,
    "petsAllowed" BOOLEAN DEFAULT FALSE,
    "childrenAllowed" BOOLEAN DEFAULT FALSE,
    "partiesAllowed" BOOLEAN DEFAULT FALSE,
    "checkInFrom" TIMESTAMPTZ,
    "checkInTo" TIMESTAMPTZ,
    "checkOutFrom" TIMESTAMPTZ,
    "checkOutTo" TIMESTAMPTZ,
    "ageRestriction" VARCHAR(300),
  -- Text note about age limits
    "optionJson" TEXT DEFAULT '{}',
  -- JSON for advanced rules
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

