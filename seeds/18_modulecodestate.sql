-- Seed: moduleCodeState
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "moduleCodeState") THEN
    INSERT INTO "moduleCodeState"
      ("moduleCodeStateName", "moduleStateCode", "description", "isActive", "moduleCode", "sequence")
    VALUES
      ('Requester', 'BOOKING:REQUESTER', 'Tenant submits a booking request', true, 'BOOKING', 1),
      ('Landlord', 'BOOKING:LANDLORD', 'Landlord accepts the booking', true, 'BOOKING', 2),
      -- ('Payment', 'BOOKING:PAYMENT', 'Tenant needs to make the payment', true, 'BOOKING'),
      ('Check-In', 'BOOKING:CHECKIN', 'Tenant checks into the property', true, 'BOOKING', 3),
      ('Check-Out', 'BOOKING:CHECKOUT', 'Tenant checks out from the property', true, 'BOOKING', 4),
      ('Completed', 'BOOKING:COMPLETED', 'Booking process is successfully done', true, 'BOOKING', 5),
      -- ORDER FLOW
      ('Created', 'ORDER:CREATED', 'Order is created by customer', true, 'ORDER', 51),
      ('Confirmed', 'ORDER:CONFIRMED', 'Order is confirmed by system or seller', true, 'ORDER', 52),
      ('Payment', 'ORDER:PAYMENT', 'Customer needs to complete payment', true, 'ORDER', 53),
      ('Processing', 'ORDER:PROCESSING', 'Order is being processed', true, 'ORDER', 54),
      ('Completed', 'ORDER:COMPLETED', 'Order is successfully completed', true, 'ORDER', 55);
      -- ('Refunded', 'ORDER:REFUNDED', 'Order payment is refunded', true, 'ORDER', 56),
      -- ('Cancelled', 'ORDER:CANCELLED', 'Order is cancelled', true, 'ORDER', 57);
  END IF;
END $$;
