-- Seed: subCategory
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "subCategory") THEN
    INSERT INTO "subCategory"
      ("id", "name", "slug", "logo", "description", "isPublished", "order", "createdAt", "modifiedOn", "count", "status")
    VALUES
      ('00000000-0000-0000-0000-000000000101', 'Local News', 'local-news', NULL, 'Updates from local regions and communities', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000102', 'International News', 'international-news', NULL, 'Global current events and reports', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000103', 'Gadgets', 'gadgets', NULL, 'New gadgets, tech tools, and hardware reviews', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000104', 'AI & Machine Learning', 'ai-machine-learning', NULL, 'Trends and news in AI and ML', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000105', 'Online Courses', 'online-courses', NULL, 'Learning platforms and online courses', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000106', 'Scholarships', 'scholarships', NULL, 'Scholarship programs for students', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000107', 'Full-Time', 'full-time', NULL, 'Full-time job opportunities across various industries', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000108', 'Part-Time', 'part-time', NULL, 'Part-time and flexible hour positions', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-000000000109', 'Contract', 'contract', NULL, 'Contract-based roles and project assignments', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-00000000010A', 'Internship', 'internship', NULL, 'Internship programs for students and fresh graduates', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-00000000010B', 'Temporary', 'temporary', NULL, 'Short-term temporary job positions', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE'),
      ('00000000-0000-0000-0000-00000000010C', 'Remote', 'remote', NULL, 'Remote and work-from-home job listings', true, 1, (NOW() AT TIME ZONE 'UTC'), (NOW() AT TIME ZONE 'UTC'), 0, 'ACTIVE');
  END IF;
END $$;
