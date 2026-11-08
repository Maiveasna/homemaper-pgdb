-- Seed: category
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "category") THEN
    INSERT INTO "category"
      ("id", "name", "slug", "isPublished", "createdBy", "modifiedBy", "createdAt", "modifiedOn", "order")
    VALUES
      ('00000000-0000-0000-0000-000000000000', 'News', 'news', true, NULL, NULL, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 1),
      ('00000000-0000-0000-0000-000000000001', 'Technology', 'technology', true, NULL, NULL, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 2),
      ('00000000-0000-0000-0000-000000000002', 'Education', 'education', true, NULL, NULL, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 3),
      ('00000000-0000-0000-0000-000000000003', 'Jobs', 'job', true, NULL, NULL, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 4);
  END IF;
END $$;
