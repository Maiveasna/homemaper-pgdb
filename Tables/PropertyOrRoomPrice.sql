-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "propertyOrRoomPrice" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "currency" VARCHAR(50) NULL DEFAULT 'dollar',
    "belongTo" UUID NULL, -- room id or property id as UUID
    "priceTypeId" UUID NULL, -- assuming this is still int enum
    "price" DECIMAL(18,2),
    "isDefault" BOOLEAN DEFAULT FALSE,
    "createdBy" UUID NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

