-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "moduleCode" (
    "functionName" VARCHAR(200) NOT NULL,
    "functionCode" VARCHAR(100) NOT NULL,
    "group" VARCHAR(100) NOT NULL,
    "description" VARCHAR(200) NOT NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "isActive" BOOLEAN DEFAULT TRUE
);

