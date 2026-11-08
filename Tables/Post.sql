-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "post" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "categoryId" UUID NULL,
    "categorySlug" VARCHAR(300) NULL,
    "slug" TEXT, -- Consider UNIQUE constraint if needed
    "content" TEXT NOT NULL,
    "lang" VARCHAR(20) DEFAULT 'kh', -- e.g., en, ch, jp
    "thumbnail" TEXT NULL,
    "isPublished" BOOLEAN DEFAULT FALSE,
    "createdBy" UUID NULL,
    "modifiedBy" UUID NULL,
    "view" INT DEFAULT 0,
    "share" INT DEFAULT 0,
    "like" INT DEFAULT 0,
    "comment" INT DEFAULT 0,
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(30) DEFAULT 'ACTIVE',
    "companyId" UUID NOT NULL
);

