-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "resource" (
    "id" UUID NOT NULL,
    "name" VARCHAR (255) NOT NULL,
    "position" INT,
    "description" VARCHAR (50) NULL,
    "category" VARCHAR (50) NOT NULL,
    "path" VARCHAR (200) NOT NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "isRootOnly" BOOLEAN DEFAULT FALSE,
    "modifiedBy" UUID NULL,
    "createdBy" UUID NOT NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "categoryType" VARCHAR (50) NULL -- new or old
);

