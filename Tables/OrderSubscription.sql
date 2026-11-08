-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "orderSubscription" (
    "orderItemId" UUID PRIMARY KEY,
    "startDate" TIMESTAMPTZ,
    "endDate" TIMESTAMPTZ,
    "type" VARCHAR(20),
    --PHYSICAL, DIGITAL, SERVICE, PROPERTY, SUBSCRIPTION, BOOKING
    "billingCycle" VARCHAR(20),
    "autoRenew" BOOLEAN DEFAULT TRUE,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT NULL,
    "createdBy" UUID NOT NULL
);

