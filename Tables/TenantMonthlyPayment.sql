-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "tenantMonthlyPayment" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "tenantId" UUID NOT NULL,
    "propertyId" UUID NOT NULL,
    "companyId" UUID NOT NULL,
    "rentalContractId" UUID NOT NULL,
    "dueDate" DATE NOT NULL,
    "paidDate" DATE NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "paymentStatus" VARCHAR(50) DEFAULT 'Unpaid',
    "note" VARCHAR(255),
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE'
  -- DELETED
);

