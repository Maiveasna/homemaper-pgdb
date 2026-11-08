-- Seed: subscriptionPlan
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "subscriptionPlan") THEN
    INSERT INTO "subscriptionPlan"
      ("name", "price", "description", "option", "isActive", "createdAt", "status")
    VALUES
      -- Basic Plan
      ('Starter Plan', 9.99, 'Suitable for individual landlords managing up to 5 properties.', '{ "MaxProperties": 5, "FeaturedLimit": 0, "Analytics": false, "Support": "Standard" }', true, (NOW() AT TIME ZONE 'UTC'), 'ACTIVE'),
      -- Pro Plan
      ('Pro Plan', 29.99, 'Great for small agencies. Includes featured listings and analytics.', '{ "MaxProperties": 20, "FeaturedLimit": 2, "Analytics": true, "Support": "Priority" }', true, (NOW() AT TIME ZONE 'UTC'), 'ACTIVE'),
      -- Business Plan
      ('Business Plan', 59.99, 'Designed for large teams with advanced features and support.', '{ "MaxProperties": 100, "FeaturedLimit": 10, "Analytics": true, "Support": "VIP" }', true, (NOW() AT TIME ZONE 'UTC'), 'ACTIVE');
  END IF;
END $$;
