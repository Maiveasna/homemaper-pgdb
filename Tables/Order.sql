-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "order" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderNo" VARCHAR(50) UNIQUE NOT NULL,
    "propertyId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- system PropertyId if zero-UUID
    "phone" VARCHAR(255) NULL,
    "name" VARCHAR(255) NULL,
    "companyId" UUID NOT NULL,
    "customerId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- system booking if zero-UUID
    "roomId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- system booking if zero-UUID
    "status" VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    "orderType" VARCHAR(30) NOT NULL DEFAULT 'PRODUCT',
    -- PENDING, PAID, PROCESSING, COMPLETED, CANCELLED, REFUNDED
    "currency" VARCHAR(10) DEFAULT 'USD',
    "basePrice" DECIMAL(10, 2) NOT NULL, -- Base price before add-ons
    "discountAmount" DECIMAL(10, 2) DEFAULT 0, -- Discount applied
    "taxAmount" DECIMAL(10, 2) DEFAULT 0, -- Tax amount
    "totalPrice" DECIMAL(10, 2) DEFAULT 0,
    "paymentStatus" VARCHAR(50) NOT NULL, -- Payment status
    "paymentMethod" VARCHAR(50) NOT NULL, -- Payment method

    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "createdBy" UUID NOT NULL
);

