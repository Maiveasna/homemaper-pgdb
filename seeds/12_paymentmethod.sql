-- Seed: paymentMethod
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "paymentMethod") THEN
    INSERT INTO "paymentMethod"
      ("id", "methodType", "description", "isActive", "modifiedBy")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Cash', 'Payment in cash.', true, NULL),
      ('00000000-0000-0000-0000-000000000002', 'Online Payment', 'Payments using online scan', true, NULL),
      ('00000000-0000-0000-0000-000000000003', 'Credit Card', 'Payments using credit card.', false, NULL),
      ('00000000-0000-0000-0000-000000000004', 'PayPal', 'Online payments via PayPal.', false, NULL),
      ('00000000-0000-0000-0000-000000000005', 'Bank Transfer', 'Payments through bank transfers.', true, NULL);
  END IF;
END $$;
