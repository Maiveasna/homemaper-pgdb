-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "rentalContract" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "tenantId" UUID NOT NULL,
    "propertyId" UUID NOT NULL,
    "companyId" UUID NOT NULL,
  -- Optional: "roomId" UNIQUEIDENTIFIER if booking per room is allowed
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    "monthlyRate" DECIMAL(10,2) NOT NULL,
    "depositAmount" DECIMAL(10,2) DEFAULT 0,
    "status" VARCHAR(50) DEFAULT 'Active',
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

