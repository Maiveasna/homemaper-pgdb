-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "paymentMethod" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "methodType" VARCHAR(100) NOT NULL, -- credit card, bank accoun
    "icon" TEXT,
    "companyId" INT DEFAULT 0,
    "description" VARCHAR(255),
    "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "details" TEXT, -- card number, bank account number)
    "createdBy" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    "modifiedBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp()
);
    -- Constraint: UNIQUE NONCLUSTERED ("id")



