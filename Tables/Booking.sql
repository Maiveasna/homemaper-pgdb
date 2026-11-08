-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "booking" (
    "bookingId" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "phone" VARCHAR(255) NULL,
    "name" VARCHAR(255) NULL,
    "companyId" UUID NOT NULL,
    "customerId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- system booking if zero-UUID
    "bookingReference" VARCHAR(100) NULL, -- Unique booking reference (for customer communication)
    "bookingDate" TIMESTAMPTZ DEFAULT clock_timestamp(), -- Date/time booking was made
    "checkInDate" TIMESTAMPTZ NULL,
    "checkOutDate" TIMESTAMPTZ NULL,
    "numberOfRooms" INT DEFAULT 1, -- Number of rooms booked
    "basePrice" DECIMAL(10, 2) NOT NULL, -- Base price before add-ons
    "discountAmount" DECIMAL(10, 2) DEFAULT 0, -- Discount applied
    "taxAmount" DECIMAL(10, 2) DEFAULT 0, -- Tax amount
    "addonPrice" DECIMAL(10, 2) DEFAULT 0, -- Add-ons total price
    "totalPrice" DECIMAL(10, 2) DEFAULT 0,
    "paymentStatus" VARCHAR(50) NOT NULL, -- Payment status
    "paymentMethod" VARCHAR(50) NOT NULL, -- Payment method
    "bookingStatus" VARCHAR(50) NOT NULL, -- Booking status
    "cancellationPolicy" VARCHAR(255), -- Cancellation policy text
    "createdBy" UUID NOT NULL,
    "isActive" BOOLEAN DEFAULT TRUE
);

