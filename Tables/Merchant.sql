-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "merchant" (
    "merchantId" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(200),
    "contactId" UUID NULL,
    "balance" DECIMAL(18,2),
    "addressId" UUID NULL,
    "companyId" UUID NOT NULL,
    "typeOfMerchant" VARCHAR(200), -- Bank, Microfinance
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "createdBy" UUID NOT NULL
);

