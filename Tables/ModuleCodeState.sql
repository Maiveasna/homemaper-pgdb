-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "moduleCodeState" (
    "moduleCodeStateName" VARCHAR(300) NOT NULL,
    "moduleCode" VARCHAR(100) NOT NULL,
    "moduleStateCode" VARCHAR(100) NOT NULL,
    "companyId" UUID NULL,
    "description" VARCHAR(200) NOT NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "isActive" BOOLEAN DEFAULT TRUE,
    "sequence" INT DEFAULT 0
);

