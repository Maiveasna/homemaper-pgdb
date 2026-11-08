-- Seed: badgeOption
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "badgeOption") THEN
    INSERT INTO "badgeOption"
      ("id", "badgeName")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Price Negotiable'),
      ('00000000-0000-0000-0000-000000000002', 'Urgent Sale'),
      ('00000000-0000-0000-0000-000000000003', 'Ready to Move In'),
      ('00000000-0000-0000-0000-000000000004', 'Price Reduced'),
      ('00000000-0000-0000-0000-000000000005', 'Luxury Property'),
      ('00000000-0000-0000-0000-000000000006', 'Under Market Value');
  END IF;
END $$;
