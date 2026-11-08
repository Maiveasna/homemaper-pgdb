-- Seed: resource
DO $$
DECLARE
  v_createdBy uuid := '00000000-0000-0000-0000-000000000000';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "resource") THEN
    INSERT INTO "resource"
      ("id", "name", "position", "description", "category", "path", "isActive", "isRootOnly", "createdBy", "categoryType")
    VALUES
      ('00000000-0000-0000-0000-000000000000', 'ana', 1, 'Analytics', 'analytics', 'admin/analytics', true, false, v_createdBy, 'old'),
      -- BOOKING
      ('00000000-0000-0000-0000-000000000001', 'bok', 2, 'Booking', 'booking', 'admin/booking', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000002', 'booking_list', 3, 'Booking List', 'booking', 'admin/booking/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000003', 'booking_create', 4, 'Booking Create', 'booking', 'admin/booking/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000004', 'booking_detail', 5, 'Booking Detail', 'booking', 'admin/booking/{id}', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000005', 'booking_checkout', 6, 'Booking Checkout', 'booking', 'admin/booking/create/checkout', true, false, v_createdBy, 'old'),
      -- TENANT
      ('00000000-0000-0000-0000-000000000006', 'ten', 7, 'Tenant', 'tenant', 'admin/tenant/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000007', 'tenant_create', 8, 'Tenant Create', 'tenant', 'admin/tenant/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000008', 'tenant_edit', 9, 'Tenant Edit', 'tenant', 'admin/tenant/list/edit/{id}', true, false, v_createdBy, 'old'),
      -- PROPERTY
      ('00000000-0000-0000-0000-000000000009', 'pro', 10, 'Property', 'property', 'admin/property', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000010', 'property_list', 11, 'Property List', 'property', 'admin/property/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000011', 'property_create', 12, 'Property Create', 'property', 'admin/property/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000012', 'property_edit', 13, 'Property Edit', 'property', 'admin/property/list/edit/{id}', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000013', 'room_list', 14, 'Room List', 'property', 'admin/property/room/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000014', 'room_create', 15, 'Room Create', 'property', 'admin/property/room/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000015', 'room_edit', 16, 'Room Edit', 'property', 'admin/property/room/edit/{id}', true, false, v_createdBy, 'old'),
      -- PRODUCT
      ('00000000-0000-0000-0000-000000000016', 'prd', 17, 'Product', 'product', 'admin/product', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000017', 'addon_list', 18, 'Addon List', 'product', 'admin/product/addon/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000018', 'addon_create', 19, 'Addon Create', 'product', 'admin/product/addon/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000019', 'addon_edit', 20, 'Addon Edit', 'product', 'admin/product/addon/edit/{id}', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000020', 'ptype_list', 21, 'Product Type List', 'product', 'admin/product/product-type/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000021', 'ptype_create', 22, 'Product Type Create', 'product', 'admin/product/product-type/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000022', 'ptype_edit', 23, 'Product Type Edit', 'product', 'admin/product/product-type/edit/{id}', true, false, v_createdBy, 'old'),
      -- USER
      ('00000000-0000-0000-0000-000000000023', 'usr', 24, 'User', 'user', 'admin/user', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000024', 'user_list', 25, 'User List', 'user', 'admin/user/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000025', 'user_create', 26, 'User Create', 'user', 'admin/user/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000026', 'user_edit', 27, 'User Edit', 'user', 'admin/user/list/edit/{id}', true, false, v_createdBy, 'old'),
      -- PERMISSIONS
      ('00000000-0000-0000-0000-000000000027', 'permission', 28, 'Permissions', 'permission', 'admin/permissions', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000028', 'permission_group', 29, 'Permission Group', 'permission', 'admin/permissions/group', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000029', 'permission_map', 30, 'Map Permissions', 'permission', 'admin/permissions/map-permissions', true, false, v_createdBy, 'old'),
      -- REPORT
      ('00000000-0000-0000-0000-000000000030', 'bkd', 31, 'All Booked', 'report', 'admin/report/all-booked', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000031', 'sal', 32, 'Sale Report', 'report', 'admin/report/sale', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000032', 'sale_list', 33, 'Sale List', 'report', 'admin/report/sale/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000033', 'sale_create', 34, 'Sale Create', 'report', 'admin/report/sale/create', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000034', 'bkr', 35, 'Booked Room', 'report', 'admin/report/booked-room', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000035', 'booked_room_list', 36, 'Booked Room List', 'report', 'admin/report/booked-room/list', true, false, v_createdBy, 'old'),
      ('00000000-0000-0000-0000-000000000036', 'booked_room_create', 37, 'Booked Room Create', 'report', 'admin/report/booked-room/create', true, false, v_createdBy, 'old');
  END IF;
END $$;
