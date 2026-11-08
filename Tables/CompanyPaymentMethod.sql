-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "companyPaymentMethod" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "merchantId" UUID NOT NULL, -- 0 UUID can represent case if needed
    "url" TEXT,
    "companyId" UUID NOT NULL,
    "label" VARCHAR(200),
    "value" VARCHAR(200), -- e.g., aba, sathapana, wing-bank, cash
    "slipScanner" TEXT,
    "icon" TEXT,
    "paymentMethodId" UUID NOT NULL,
    "createdBy" UUID NOT NULL,
    "modifiedBy" UUID NOT NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp()
);

