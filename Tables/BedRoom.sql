-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "bedRoom" (
    "bedId" UUID NOT NULL, -- Feature list type bedroom (UUID)
    "roomId" UUID NOT NULL, -- Room ID (UUID)
    "maxGuest" INT DEFAULT 2,
    "description" VARCHAR(500),
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

