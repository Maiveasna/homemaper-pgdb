-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "bookingDetail" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "bookingId" UUID NOT NULL, -- FK to Booking table (UUID)
    "propertyId" UUID NOT NULL, -- FK to Booking table (UUID)
    "roomId" UUID NOT NULL, -- FK to Room table (UUID)
    "roomNo" VARCHAR(200) NOT NULL,
    "adult" INT NOT NULL DEFAULT 2,
    "children" INT DEFAULT 0,
    "childrenOption" VARCHAR(200),
    "roomType" VARCHAR(200),
    "duration" INT DEFAULT 1,
    "feature" TEXT,
    "facility" TEXT,
    "roomPrice" DECIMAL(10, 2) NOT NULL,
    "addonPrice" DECIMAL(10, 2) DEFAULT 0,
    "totalRoomPrice" DECIMAL(10, 2) DEFAULT 0,
    "checkInDate" TIMESTAMPTZ NULL,
    "checkOutDate" TIMESTAMPTZ NULL,
    "createdBy" UUID NOT NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "bookingStatus" VARCHAR(50) NULL -- Booked, Check-In, Check-Out
);

