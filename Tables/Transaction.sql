-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "transaction" (
    "id" UUID PRIMARY KEY,
    "transferId" UUID NOT NULL, -- Links to Transfer (parent record)
    "accountId" UUID NOT NULL, -- Account affected
    "direction" VARCHAR(10) NOT NULL, -- DEBIT or CREDIT
    "amount" DECIMAL(18,2) NOT NULL, -- Amount affected on account

    "balanceCurrency" DECIMAL(18,2) NOT NULL, -- USD, KHR
    "balanceBefore" DECIMAL(18,2) NOT NULL,
    "balanceAfter" DECIMAL(18,2) NOT NULL, -- Snapshot for audit consistency
    "currencyId" UUID NOT NULL,
    "transactionType" VARCHAR(200), -- payment, refund

    "status" VARCHAR(200), -- pending, completed, failed
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "createdBy" UUID NOT NULL
);

