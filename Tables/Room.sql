-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "room" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "roomNumber" VARCHAR(50),
    "propertyId" UUID, -- changed to UUID
    "companyId" UUID, -- changed to UUID
    "roomType" UUID, -- changed to UUID
    "maxGuest" INT,
    "floor" INT DEFAULT 0,
    "roomSize" INT, -- square meters or square feet
    "roomSizeScale" VARCHAR(20) DEFAULT 'square meters', -- unit label
    "allowedSmoking" BOOLEAN DEFAULT FALSE,
    "bathroomPrivate" BOOLEAN DEFAULT TRUE,
    "bathroomItems" TEXT,
    "status" VARCHAR(50),
    "badgeOption" VARCHAR(500),
    "isActive" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID, -- changed to UUID
    "modifiedBy" UUID, -- changed to UUID
    "description" TEXT,
    "allowedChildren" BOOLEAN DEFAULT TRUE,
    "childrenOption" TEXT,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

