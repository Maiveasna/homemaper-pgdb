-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "orderItem" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "quantity" INT DEFAULT 1,
    "unitPrice" DECIMAL(18,2) NOT NULL,
    "totalPrice" DECIMAL(18,2) NOT NULL,
    "productType" VARCHAR(30),
    -- PHYSICAL, DIGITAL, SERVICE, PROPERTY, SUBSCRIPTION
    "option" TEXT,
    "description" TEXT,
    "status" VARCHAR(30) DEFAULT 'PENDING',
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT NULL,
    "createdBy" UUID NOT NULL
);

