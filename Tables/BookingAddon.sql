-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "bookingAddon" (
    "bookingAddonId" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "bookingId" UUID NOT NULL, -- FK to Booking table
    "addonId" UUID NOT NULL, -- FK to Addon table
    "addonTitle" VARCHAR(200) NOT NULL,
    "quantity" INT DEFAULT 1,
    "status" VARCHAR(200) DEFAULT 'pending', -- pending, processing, completed
    "roomId" UUID NULL, -- FK to Room table
    "price" DECIMAL(10,2),
    "totalAddonPrice" DECIMAL(10,2)
);

