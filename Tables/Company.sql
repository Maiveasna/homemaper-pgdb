-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "company" (
    "id" UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    "companyBranchName" VARCHAR(100) NOT NULL,
    "description" TEXT NULL,
    "logo" TEXT NULL,
    "cover" TEXT NULL,
    "phoneNumber" VARCHAR(200) NOT NULL,
    "emailAddress" VARCHAR(100) NULL,
    "socialMedia" TEXT NULL,
    "companyType" VARCHAR(100) DEFAULT 'CLIENT', -- CLIENT, MAIN is my company
    "businessType" UUID NULL,
    "socialMediaType" INT DEFAULT 0, -- 0 is telegram, 1 is facebook
    "industry" VARCHAR(50) NULL,
    "permissionId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000', -- 0 as zero UUID
    "numberOfEmployees" INT NULL DEFAULT 1,
    "accountId" UUID NULL,
    "isActive" INT DEFAULT 1,
    "createdBy" UUID NOT NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "modifiedBy" UUID NULL,
    "modifiedOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "status" VARCHAR(20) DEFAULT 'ACTIVE' -- DELETED
);

