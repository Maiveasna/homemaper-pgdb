-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "transactionLog" (
    "logId" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "transactionId" INT,
    "companyId" INT,
    "event" VARCHAR(200), -- initiated, processed, completed
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "createdBy" INT NOT NULL
);

