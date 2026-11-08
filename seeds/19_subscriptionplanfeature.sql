-- Seed: subscriptionPlanFeature
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "subscriptionPlanFeature") THEN
    INSERT INTO "subscriptionPlanFeature"
      ("key", "name", "value", "createdBy", "status")
    VALUES
      -- Plan 1
      ('MaxProperties', 'Maximum of 2 Properties', '2', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxUsers', 'Maximum of 4 Users Access to System', '4', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxRoomListing', 'Maximum of 10 Room Listings', '10', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('DashboardMonitor', 'Dashboard Monitor (Yes)', 'Yes', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      -- Plan 2
      ('MaxProperties', 'Maximum of 5 Properties', '5', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxUsers', 'Maximum of 8 Users Access to System', '8', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxRoomListing', 'Maximum of 35 Room Listings', '35', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('DashboardMonitor', 'Dashboard Monitor (Yes)', 'Yes', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      -- Plan 3
      ('MaxProperties', 'Maximum of 20 Properties', '20', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxUsers', 'Maximum of 16 Users Access to System', '16', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxRoomListing', 'Maximum of 100 Room Listings', '100', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('DashboardMonitor', 'Dashboard Monitor (Yes)', 'Yes', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      -- Plan 4
      ('MaxProperties', 'Maximum of 50 Properties', '50', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxUsers', 'Maximum of 50 Users Access to System', '50', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('MaxRoomListing', 'Maximum of Unlimited Room Listings', 'Unlimited', '00000000-0000-0000-0000-000000000000', 'ACTIVE'),
      ('DashboardMonitor', 'Dashboard Monitor (Yes)', 'Yes', '00000000-0000-0000-0000-000000000000', 'ACTIVE');
  END IF;
END $$;
