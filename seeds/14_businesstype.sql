-- Seed: businessType
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "businessType") THEN
    INSERT INTO "businessType"
      ("id", "name", "description")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Retail', 'Sells products directly to consumers'),
      ('00000000-0000-0000-0000-000000000002', 'Wholesale', 'Sells goods in large quantities to businesses'),
      ('00000000-0000-0000-0000-000000000003', 'IT Services', 'Provides technology services or software solutions'),
      ('00000000-0000-0000-0000-000000000004', 'Real Estate', 'Manages or sells property'),
      ('00000000-0000-0000-0000-000000000005', 'Healthcare', 'Medical, health services or equipment'),
      ('00000000-0000-0000-0000-000000000006', 'Finance', 'Banking, insurance, investment-related services');
  END IF;
END $$;
