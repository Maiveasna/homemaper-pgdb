-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "badgeOption" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "badgeName" VARCHAR(50) NOT NULL,
    "isActive" BOOLEAN DEFAULT TRUE
);

