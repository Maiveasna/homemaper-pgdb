-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "workflowState" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "state" VARCHAR(100) NOT NULL,
    "companyId" UUID NULL,
    "workflowId" UUID NOT NULL,
    "conditionNumber" INT,
    "sequence" INT NOT NULL,
  -- Step order: 1, 2, 3...
    "conditionDefinition" VARCHAR(50) NOT NULL,
  -- MAKER / CHECKER / APPROVER
    "conditionDefinitionDisplay" VARCHAR(200) NOT NULL,
  -- MAKER / CHECKER / APPROVER
    "approvalNumber" INT,
    "countApproval" INT,
    "conjunction" VARCHAR(10) DEFAULT 'AND',
  -- Allow edit in this state?
    "isFinal" BOOLEAN DEFAULT FALSE,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "completedOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "status" VARCHAR(20) NULL
  -- COMPLETED, PENDIN
);

