-- Seed: roles
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "roles") THEN
    INSERT INTO "roles"
      ("id", "roleName", "description")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'MAKER', 'User who creates requests'),
      ('00000000-0000-0000-0000-000000000002', 'CHECKER', 'User who checks requests'),
      ('00000000-0000-0000-0000-000000000003', 'VERIFIER', 'User who verifies requests'),
      ('00000000-0000-0000-0000-000000000004', 'SUPER', 'Super user role'),
      ('00000000-0000-0000-0000-000000000005', 'SUPER_ADMIN', 'Super administrator with full access');
  END IF;
END $$;
