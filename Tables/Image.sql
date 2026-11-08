-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "image" (
    "referenceToId" UUID NULL,
    "isThumbnail" BOOLEAN DEFAULT FALSE,
    "path" TEXT NOT NULL
);

