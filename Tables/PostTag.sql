-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "postTag" (
    "postId" UUID NOT NULL,
    "tagId" UUID NOT NULL,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

