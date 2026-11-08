-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "postCategory" (
    "postId" UUID NOT NULL,
    "categoryId" UUID NOT NULL,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

