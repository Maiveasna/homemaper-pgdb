-- Seed: position
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "position") THEN
    INSERT INTO "position"
      ("id", "title", "slug", "isActive", "createdAt")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Homepage Banner', 'homepage-banner', true, (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000002', 'Sidebar Ad', 'sidebar-ad', true, (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000003', 'Footer Promotion', 'footer-promotion', true, (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000004', 'Header Banner', 'header-banner', true, (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000005', 'Product Page Ad', 'product-page-ad', true, (NOW() AT TIME ZONE 'UTC'));
  END IF;
END $$;
