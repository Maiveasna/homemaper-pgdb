-- Seed: facilities
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "facilities") THEN
    INSERT INTO "facilities"
      ("id", "name", "description", "createdBy", "createdOn")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Swimming Pool', 'Outdoor swimming pool available for residents.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000002', 'Gym', 'Fully equipped gym with cardio and weight training equipment.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000003', 'Parking', 'Covered parking spaces available.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000004', 'Free Wi-Fi', 'High-speed internet access available throughout the property.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000005', 'Laundry Room', 'Coin-operated laundry machines available on-site.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000006', 'Garden', 'Beautifully landscaped garden with seating areas.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000007', '24/7 Security', 'Round-the-clock security personnel and surveillance cameras.', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000008', 'Air conditioning', 'Air conditioning', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000009', 'Fan', 'Fan', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-00000000000A', 'Private bathroom', 'Private bathroom', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-00000000000B', 'Minibar', 'Minibar', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-00000000000C', 'Flat-screen TV', 'Flat-screen TV', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-00000000000D', 'Shared Kitchen', 'Shared Kitchen', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-00000000000E', 'Parking', 'Parking', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-00000000000F', 'Pet-Friendly', 'Pet-Friendly', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000010', 'TV', 'TV', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC')),
      ('00000000-0000-0000-0000-000000000011', 'Cleaning Services', 'Cleaning Services', '00000000-0000-0000-0000-000000000001', (NOW() AT TIME ZONE 'UTC'));
  END IF;
END $$;
