-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "workflow" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" VARCHAR(100) NOT NULL,
    "companyId" UUID NULL,
    "description" VARCHAR(500) NULL,
    "functionCode" VARCHAR(200) NULL,
    "code" VARCHAR(200) NULL,
    "createdBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedBy" UUID NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "status" VARCHAR(20) NULL, -- priocessing, make pending,  completed, fail
    "displayStatus" VARCHAR(200) NULL,
    "isActive" BOOLEAN DEFAULT TRUE
);

