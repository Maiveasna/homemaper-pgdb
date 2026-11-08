-- Seed: paymentStatus
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "paymentStatus") THEN
    INSERT INTO "paymentStatus"
      ("id", "statusName", "description", "isActive", "createdBy", "modifiedBy")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Pending', 'Payment is pending approval or action.', true, DEFAULT, NULL),
      ('00000000-0000-0000-0000-000000000002', 'Unpaid', 'Payment is Unpaid', true, DEFAULT, NULL),
      ('00000000-0000-0000-0000-000000000003', 'Late', 'Payment is late.', true, DEFAULT, NULL),
      ('00000000-0000-0000-0000-000000000004', 'Paid', 'Payment has been completed successfully.', true, DEFAULT, NULL),
      ('00000000-0000-0000-0000-000000000005', 'Failed', 'Payment attempt was unsuccessful.', true, DEFAULT, NULL),
      ('00000000-0000-0000-0000-000000000006', 'Cancelled', 'Payment was cancelled by the user or system.', true, DEFAULT, NULL);
  END IF;
END $$;
