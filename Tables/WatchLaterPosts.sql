-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "watchLaterPosts" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" UUID NOT NULL, -- References the user who saved the post
    "postId" UUID NOT NULL, -- References the post being saved
    "savedAt" TIMESTAMPTZ DEFAULT clock_timestamp(), -- When the post was saved
    "isActive" BOOLEAN DEFAULT TRUE, -- For soft delete (un-save functionality)
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "createdBy" UUID NOT NULL
);

