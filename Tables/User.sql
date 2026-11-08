-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "user" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "firstName" VARCHAR (50) NULL,
    "lastName" VARCHAR (50) NULL,
    "groupResourceId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    "companyId" UUID DEFAULT '00000000-0000-0000-0000-000000000000',
    "userName" VARCHAR (100) NULL,
    "email" VARCHAR (100) NULL,
    "phone" VARCHAR (300) NULL,
    "phoneCountryCode" VARCHAR (10) NULL,
    "otpCode" VARCHAR(20),
    "otpExpireDate" TIMESTAMPTZ NULL,
    "isResetPassword" BOOLEAN DEFAULT FALSE,
    "password" TEXT NOT NULL,
    "profile" TEXT NULL,
    "staffId" VARCHAR (100) NULL,
    "registerType" VARCHAR(10) NOT NULL CHECK ("registerType" IN ('phone', 'email', 'username', 'company')) DEFAULT 'phone', --  reigster by phone is normal user
    "accountType" INT DEFAULT 0, -- 0 is normal user, 1 is root/main company, 2 is subcompany, 3 is Tenant
    "createdAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedBy" VARCHAR(50) NULL,
    "createdBy" VARCHAR(50) NULL,
    "isActive" BOOLEAN DEFAULT TRUE,
    "isBlock" BOOLEAN DEFAULT FALSE,
    "ip" VARCHAR(30) NULL,
    "status" VARCHAR(10), -- DELETED /
    "bio" TEXT NULL,
    "role" VARCHAR(20) NULL,
    "address" TEXT NULL
);

