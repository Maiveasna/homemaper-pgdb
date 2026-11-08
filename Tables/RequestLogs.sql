-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "requestLogs" (
    "id" INT NOT NULL PRIMARY KEY,
    "fromUrl" TEXT,
    "toUrl" TEXT,
    "service" VARCHAR(200), --Payment,Internal
    "requestBody" TEXT,
    "responseBody" TEXT,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "requester" TEXT
);

