-- Seed: propertyType
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "propertyType") THEN
    INSERT INTO "propertyType"
      ("id", "propertyTypeName", "categoryType")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Apartment', 'Property'),
      ('00000000-0000-0000-0000-000000000002', 'House', 'Property'),
      ('00000000-0000-0000-0000-000000000003', 'Condo', 'Property'),
      ('00000000-0000-0000-0000-000000000004', 'Townhouse', 'Property'),
      ('00000000-0000-0000-0000-000000000005', 'Villa', 'Property'),
      ('00000000-0000-0000-0000-000000000006', 'Duplex', 'Property'),
      ('00000000-0000-0000-0000-000000000007', 'Penthouse', 'Property'),
      ('00000000-0000-0000-0000-000000000008', 'Studio', 'Property'),
      ('00000000-0000-0000-0000-000000000009', 'Farmhouse', 'Property'),
      ('00000000-0000-0000-0000-00000000000A', 'Bungalow', 'Property'),
      ('00000000-0000-0000-0000-00000000000B', 'Resort', 'Property'),
      ('00000000-0000-0000-0000-00000000000C', 'Loft', 'Property'),
      ('00000000-0000-0000-0000-00000000000D', 'Mansion', 'Property'),
      ('00000000-0000-0000-0000-00000000000E', 'Chalet', 'Property'),
      ('00000000-0000-0000-0000-00000000000F', 'Guesthouse', 'Property'),
      ('00000000-0000-0000-0000-000000000010', 'Double', 'Room'),
      ('00000000-0000-0000-0000-000000000011', 'Twin', 'Room'),
      ('00000000-0000-0000-0000-000000000012', 'Twin/Double', 'Room'),
      ('00000000-0000-0000-0000-000000000013', 'Triple', 'Room'),
      ('00000000-0000-0000-0000-000000000014', 'Quad', 'Room'),
      ('00000000-0000-0000-0000-000000000015', 'Family', 'Room'),
      ('00000000-0000-0000-0000-000000000016', 'Single', 'Room'),
      ('00000000-0000-0000-0000-000000000017', 'Campground', 'Alternative Places'),
      ('00000000-0000-0000-0000-000000000018', 'Boat', 'Alternative Places'),
      ('00000000-0000-0000-0000-000000000019', 'Luxury Tent', 'Alternative Places'),
      ('00000000-0000-0000-0000-00000000001A', 'Treehouse', 'Alternative Places'),
      ('00000000-0000-0000-0000-00000000001B', 'Yurt', 'Alternative Places'),
      ('00000000-0000-0000-0000-00000000001C', 'Cabin', 'Alternative Places');
  END IF;
END $$;
