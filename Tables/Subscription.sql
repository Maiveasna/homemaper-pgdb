-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "subscription" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "planId" UUID NOT NULL,
    "planPrice" DECIMAL(10,2) NOT NULL,
    "planName" VARCHAR(40) NOT NULL,
    "type" VARCHAR(40) NULL,
    "referencePlan" TEXT NULL,
    "planFeature" TEXT,
    "startDate" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "endDate" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "paymentStatus" VARCHAR(20) NOT NULL DEFAULT 'Pending', -- Paid, Failed, Pending
    "autoRenew" BOOLEAN NOT NULL DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE', -- DELETED
    "quantity" INT DEFAULT 1,
    "discountPercentage" DECIMAL(5,2) DEFAULT 0,
    "discountPrice" DECIMAL(10,2) DEFAULT 0
);

