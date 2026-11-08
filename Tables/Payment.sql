-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "payment" (
    "paymentId" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "bookingId" UUID NOT NULL, -- FK to Booking table (UUID)
    "paymentDate" TIMESTAMPTZ DEFAULT clock_timestamp() NULL, -- When payment was made
    "paymentMethod" VARCHAR(50), -- Payment method (e.g., Credit Card, PayPal)
    "amountPaId" DECIMAL(10, 2) NOT NULL, -- Amount paid
    "paymentStatus" VARCHAR(50) NOT NULL, -- Payment status (Paid, Pending, Failed)
    "slipUpload" TEXT,
    "transactionId" TEXT,
    "merchantId" TEXT,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

