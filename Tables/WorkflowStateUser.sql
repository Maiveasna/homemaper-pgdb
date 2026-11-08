-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "workflowStateUser" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "workflowStateId" UUID NOT NULL, -- FK to WorkflowState
    "workflowId" UUID NOT NULL,
    "userId" UUID NULL, -- Specific user assigned (optional)
    "sequence" INT,
    "createdBy" UUID NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp(),
    "status" VARCHAR(20) NULL -- APPROVED, PENDIN
);

