-- Seed: bookingStatus
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "bookingStatus") THEN
    INSERT INTO "bookingStatus"
      ("id", "statusName", "description", "createdBy")
    VALUES
      ('00000000-0000-0000-0000-000000000001', 'Booked', 'Booking has been confirmed by the customer and is active.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000002', 'Cancelled', 'Booking has been cancelled.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000003', 'Completed', 'The customer has completed their stay.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000004', 'Pending', 'Booking is pending confirmation and has not yet been finalized.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000005', 'Processing', 'Booking is being processed.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000006', 'CheckedIn', 'Customer has successfully checked in.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000007', 'CheckedOut', 'Customer has successfully checked out.', '00000000-0000-0000-0000-000000000001'),
      ('00000000-0000-0000-0000-000000000008', 'Failed', 'Booking payment or processing failed.', '00000000-0000-0000-0000-000000000001');
  END IF;
END $$;
