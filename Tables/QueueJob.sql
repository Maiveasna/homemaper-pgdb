-- Converted from SQL Server to PostgreSQL
CREATE TABLE IF NOT EXISTS "queueJob" (
    "id" UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    "jobId" VARCHAR(200) NOT NULL,
  -- BullMQ job.id
    "companyId" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
  -- 0 as zero UUID
    "queueName" VARCHAR(200) NOT NULL,
  -- e.g. 'EXPORT_PDF_QUEUE'
    "jobName" VARCHAR(200) NULL,
  -- optional
    "payload" TEXT NULL,
  -- JSON input
    "result" TEXT NULL,
  -- JSON output
    "progress" INT DEFAULT 0,
  -- 0-100 progress
    "status" VARCHAR(50) NOT NULL DEFAULT 'waiting',
  -- waiting, active, completed, failed, delayed, canceled
    "attempts" INT DEFAULT 0,
    "maxAttempts" INT DEFAULT 3,
    "priority" INT DEFAULT 0,
    "errorMessage" TEXT NULL,
    "keepUntil" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
  -- auto-delete threshold
    "createdBy" UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
    "updatedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "createdOn" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "startedAt" TIMESTAMPTZ DEFAULT clock_timestamp() NULL,
    "completedAt" TIMESTAMPTZ DEFAULT NULL
);
-- -- 🔥 Indexes for fast lookup
-- CREATE INDEX IX_QueueJobs_JobId ON QueueJobs(JobId);
-- CREATE INDEX IX_QueueJobs_Queue_Status ON QueueJobs(QueueName, Status);
-- CREATE INDEX IX_QueueJobs_UserId ON QueueJobs(CreatedBy);
-- CREATE INDEX IX_QueueJobs_KeepUntil ON QueueJobs(KeepUntil);
-- GO;

