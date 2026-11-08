-- Seed: moduleCode
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "moduleCode") THEN
    INSERT INTO "moduleCode"
      ("functionName", "functionCode", "group", "description", "createdOn", "isActive")
    VALUES
      -- Booking Module
      ('Create Booking', 'BOOKING', 'Booking', 'Create a new booking', (NOW() AT TIME ZONE 'UTC'), true),
      -- Customer Module
      ('Create Customer', 'CUSTOMER:CREATE', 'Customer', 'Register a new customer', (NOW() AT TIME ZONE 'UTC'), true),
      ('Edit Customer', 'CUSTOMER:EDIT', 'Customer', 'Update customer information', (NOW() AT TIME ZONE 'UTC'), true),
      ('View Customer', 'CUSTOMER:VIEW', 'Customer', 'View customer details', (NOW() AT TIME ZONE 'UTC'), true),
      -- Report Module
      ('Generate Booking Report', 'REPORT:BOOKING', 'Report', 'Generate report for bookings', (NOW() AT TIME ZONE 'UTC'), true),
      ('Export Booking Data', 'REPORT:EXPORT', 'Report', 'Export bookings to Excel or PDF', (NOW() AT TIME ZONE 'UTC'), true),
      -- Settings
      ('Manage Booking Settings', 'SETTINGS:BOOKING', 'Settings', 'Configure booking module settings', (NOW() AT TIME ZONE 'UTC'), true);
  END IF;
END $$;
