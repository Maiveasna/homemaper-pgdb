-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "stock" (
    -- Identity
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    "companyId" UUID NOT NULL,
    "warehouseId" UUID NULL, -- Multi-warehouse support
    "productId" UUID NOT NULL,
    "providerId" UUID NULL, -- Multi-warehouse support

    -- Transaction Info
    "transactionType" VARCHAR(20) NOT NULL,
    -- IMPORT | EXPORT | ADJUST | RETURN | TRANSFER_IN | TRANSFER_OUT

    "quantity" INT DEFAULT 0,
    "unit" VARCHAR(50) DEFAULT 'unit',

    -- Cost Tracking (for accounting / COGS)
    "unitCost" DECIMAL(12,2) DEFAULT 0.00,
    "totalCost" DECIMAL(12,2) DEFAULT 0.00,

    -- Stock Snapshot (VERY IMPORTANT for reporting)
    "stockBefore" INT DEFAULT 0,
    "stockAfter" INT DEFAULT 0,

    -- Reference
    "referenceType" VARCHAR(50) NULL,
    -- PURCHASE_ORDER | SALE_ORDER | MANUAL | SYSTEM | RETURN

    "referenceId" UUID NULL,
    "referenceCode" VARCHAR(50) NULL, -- Human-readable (INV-0001)

    -- Extra Metadata
    "batchNumber" VARCHAR(50) NULL,
    "expiredAt" TIMESTAMPTZ NULL, -- for perishable goods
    "serialNumber" VARCHAR(100) NULL, -- electronics

    -- Notes
    "note" VARCHAR(500) NULL,
    "importDate" TIMESTAMPTZ DEFAULT clock_timestamp(),
    -- Status
    "status" VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE | CANCELLED | DELETED
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "createdBy" UUID NOT NULL
);

