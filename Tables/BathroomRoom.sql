-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "bathroomRoom" (
    "bathroomId" UUID NOT NULL, -- Feature list type bathroom (UUID)
    "roomId" UUID NOT NULL, -- Room ID (UUID)
    "description" TEXT,
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

