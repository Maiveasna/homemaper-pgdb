-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "workflowStateCurrent" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "workflowId" UUID NOT NULL, -- FK to Workflow (template)
    "workflowStateId" UUID NOT NULL, -- FK to current state
    "referenceId" UUID NULL, -- The business entity (e.g., PropertyId)
    "referenceType" VARCHAR(100) NOT NULL, -- Type of entity (e.g., 'PROPERTY', 'DOCUMENT')
    "status" VARCHAR(50) DEFAULT 'InProgress', -- 'InProgress', 'Approved', 'Rejected'
    "step" INT NOT NULL -- Current step number (from WorkflowState.Sequence)
);

