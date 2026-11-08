-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "comment" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "postId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "content" TEXT,
    "like" INT DEFAULT 0,
    "love" INT DEFAULT 0,
    "isPublished" BOOLEAN DEFAULT TRUE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL
);

