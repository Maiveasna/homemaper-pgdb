-- EasyKit schema snapshot
-- Version   : 20261019212525
-- Database  : vstay-db
-- Generated : 2026-10-19 21:25:25 +0700
-- Restore   : scripts/rollback.sh 20261019212525

CREATE TABLE IF NOT EXISTS "accountGroup" (
    "accountId" uuid,
    "groupId" uuid,
    "modifiedBy" uuid,
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "companyId" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "addon" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "addonName" character varying(200),
    "price" numeric(10,2),
    "companyId" uuid,
    "isActive" boolean DEFAULT true,
    "category" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "description" character varying(500),
    "image" text,
    "stock" integer DEFAULT 1,
    "originalPrice" numeric(10,2) DEFAULT 0,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "badgeOption" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "badgeName" character varying(50) NOT NULL,
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "banner" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "title" character varying(255) NOT NULL,
    "imageUrl" character varying(500) NOT NULL,
    "description" text,
    "redirectUrl" character varying(500),
    "isActive" boolean DEFAULT true,
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    "position" character varying(30),
    "categoryId" uuid NOT NULL,
    "service" character varying(200) DEFAULT 'all'::character varying,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "bathroomRoom" (
    "bathroomId" uuid NOT NULL,
    "roomId" uuid NOT NULL,
    "description" text,
    "isActive" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "bedRoom" (
    "bedId" uuid NOT NULL,
    "roomId" uuid NOT NULL,
    "maxGuest" integer DEFAULT 2,
    "description" character varying(500),
    "isActive" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "booking" (
    "bookingId" uuid DEFAULT gen_random_uuid() NOT NULL,
    "phone" character varying(255),
    "name" character varying(255),
    "companyId" uuid NOT NULL,
    "customerId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "bookingReference" character varying(100),
    "bookingDate" timestamp with time zone DEFAULT clock_timestamp(),
    "checkInDate" timestamp with time zone,
    "checkOutDate" timestamp with time zone,
    "numberOfRooms" integer DEFAULT 1,
    "basePrice" numeric(10,2) NOT NULL,
    "discountAmount" numeric(10,2) DEFAULT 0,
    "taxAmount" numeric(10,2) DEFAULT 0,
    "addonPrice" numeric(10,2) DEFAULT 0,
    "totalPrice" numeric(10,2) DEFAULT 0,
    "paymentStatus" character varying(50) NOT NULL,
    "paymentMethod" character varying(50) NOT NULL,
    "bookingStatus" character varying(50) NOT NULL,
    "cancellationPolicy" character varying(255),
    "createdBy" uuid NOT NULL,
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "bookingAddon" (
    "bookingAddonId" uuid DEFAULT gen_random_uuid() NOT NULL,
    "bookingId" uuid NOT NULL,
    "addonId" uuid NOT NULL,
    "addonTitle" character varying(200) NOT NULL,
    "quantity" integer DEFAULT 1,
    "status" character varying(200) DEFAULT 'pending'::character varying,
    "roomId" uuid,
    "price" numeric(10,2),
    "totalAddonPrice" numeric(10,2)
);

CREATE TABLE IF NOT EXISTS "bookingAddonWorkflow" (
    "bookingAddonId" uuid DEFAULT gen_random_uuid() NOT NULL,
    "workflowId" uuid NOT NULL,
    "bookingId" uuid NOT NULL,
    "addonId" uuid NOT NULL,
    "addonTitle" character varying(200) NOT NULL,
    "quantity" integer DEFAULT 1,
    "status" character varying(200) DEFAULT 'pending'::character varying,
    "roomId" uuid,
    "price" numeric(10,2),
    "totalAddonPrice" numeric(10,2)
);

CREATE TABLE IF NOT EXISTS "bookingDetail" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "bookingId" uuid NOT NULL,
    "propertyId" uuid NOT NULL,
    "roomId" uuid NOT NULL,
    "roomNo" character varying(200) NOT NULL,
    "adult" integer DEFAULT 2 NOT NULL,
    "children" integer DEFAULT 0,
    "childrenOption" character varying(200),
    "roomType" character varying(200),
    "duration" integer DEFAULT 1,
    "feature" text,
    "facility" text,
    "roomPrice" numeric(10,2) NOT NULL,
    "addonPrice" numeric(10,2) DEFAULT 0,
    "totalRoomPrice" numeric(10,2) DEFAULT 0,
    "checkInDate" timestamp with time zone,
    "checkOutDate" timestamp with time zone,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "bookingStatus" character varying(50)
);

CREATE TABLE IF NOT EXISTS "bookingDetailWorkflow" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "bookingId" uuid NOT NULL,
    "workflowId" uuid NOT NULL,
    "propertyId" uuid NOT NULL,
    "roomId" uuid NOT NULL,
    "roomNo" character varying(200) NOT NULL,
    "adult" integer DEFAULT 2 NOT NULL,
    "children" integer DEFAULT 0,
    "childrenOption" character varying(200),
    "roomType" character varying(200),
    "duration" integer DEFAULT 1,
    "bookingStatus" character varying(50),
    "feature" text,
    "facility" text,
    "roomPrice" numeric(10,2) NOT NULL,
    "addonPrice" numeric(10,2) DEFAULT 0,
    "totalRoomPrice" numeric(10,2) DEFAULT 0,
    "checkInDate" timestamp with time zone,
    "checkOutDate" timestamp with time zone,
    "createdBy" uuid NOT NULL,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "bookingStatus" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "statusName" character varying(50) NOT NULL,
    "description" character varying(255),
    "isActive" boolean DEFAULT true,
    "createdBy" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "bookingWorkflow" (
    "bookingId" uuid DEFAULT gen_random_uuid() NOT NULL,
    "companyId" uuid NOT NULL,
    "phone" character varying(255),
    "name" character varying(255),
    "customerId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "workflowId" uuid NOT NULL,
    "bookingReference" character varying(100),
    "bookingDate" timestamp with time zone DEFAULT clock_timestamp(),
    "checkInDate" timestamp with time zone,
    "checkOutDate" timestamp with time zone,
    "numberOfRooms" integer DEFAULT 1,
    "basePrice" numeric(10,2) NOT NULL,
    "discountAmount" numeric(10,2) DEFAULT 0,
    "discountPercentage" numeric(5,2) DEFAULT 0,
    "payDeposit" numeric(10,2) DEFAULT 0,
    "taxAmount" numeric(10,2) DEFAULT 0,
    "addonPrice" numeric(10,2) DEFAULT 0,
    "totalPrice" numeric(10,2) DEFAULT 0,
    "paymentStatus" character varying(50) NOT NULL,
    "paymentMethod" character varying(50) NOT NULL,
    "bookingStatus" character varying(50) NOT NULL,
    "cancellationPolicy" character varying(255),
    "createdBy" uuid NOT NULL,
    "modifiedBy" uuid,
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "reasonMessage" text
);

CREATE TABLE IF NOT EXISTS "businessType" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100) NOT NULL,
    "description" character varying(255),
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid DEFAULT '00000000-0000-0000-0000-000000000001'::uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    "modifiedBy" uuid,
    "modifiedOn" timestamp with time zone
);

CREATE TABLE IF NOT EXISTS "category" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100) NOT NULL,
    "slug" character varying(100) NOT NULL,
    "logo" text,
    "description" character varying(500),
    "isPublished" boolean DEFAULT true,
    "order" integer,
    "companyId" uuid,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "count" integer,
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "comment" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "postId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    "content" text,
    "like" integer DEFAULT 0,
    "love" integer DEFAULT 0,
    "isPublished" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "company" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "companyBranchName" character varying(100) NOT NULL,
    "description" text,
    "logo" text,
    "cover" text,
    "phoneNumber" character varying(200) NOT NULL,
    "emailAddress" character varying(100),
    "socialMedia" text,
    "companyType" character varying(100) DEFAULT 'CLIENT'::character varying,
    "businessType" uuid,
    "socialMediaType" integer DEFAULT 0,
    "industry" character varying(50),
    "permissionId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "numberOfEmployees" integer DEFAULT 1,
    "accountId" uuid,
    "isActive" integer DEFAULT 1,
    "createdBy" uuid NOT NULL,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedBy" uuid,
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "companyPaymentMethod" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "merchantId" uuid NOT NULL,
    "url" text,
    "companyId" uuid NOT NULL,
    "label" character varying(200),
    "value" character varying(200),
    "slipScanner" text,
    "icon" text,
    "paymentMethodId" uuid NOT NULL,
    "createdBy" uuid NOT NULL,
    "modifiedBy" uuid NOT NULL,
    "isActive" boolean DEFAULT true,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "facilities" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(255) NOT NULL,
    "description" text,
    "isActive" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "facingOption" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "facingName" character varying(50) NOT NULL,
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "feature" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "featureName" character varying(100) NOT NULL,
    "featureType" character varying(100) NOT NULL,
    "description" text,
    "icon" character varying(500),
    "status" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "group" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(50) NOT NULL,
    "remark" character varying(500),
    "isActive" boolean DEFAULT true,
    "companyId" uuid NOT NULL,
    "modifiedBy" uuid,
    "createdBy" uuid NOT NULL,
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "createdAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "groupPermission" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "groupId" uuid NOT NULL,
    "resourceId" uuid NOT NULL,
    "canCreate" boolean DEFAULT false,
    "canRead" boolean DEFAULT false,
    "canUpdate" boolean DEFAULT false,
    "canDelete" boolean DEFAULT false,
    "canExport" boolean DEFAULT false,
    "canImport" boolean DEFAULT false,
    "createdBy" uuid,
    "companyId" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "image" (
    "referenceToId" uuid,
    "isThumbnail" boolean DEFAULT false,
    "path" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "merchant" (
    "merchantId" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(200),
    "contactId" uuid,
    "balance" numeric(18,2),
    "addressId" uuid,
    "companyId" uuid NOT NULL,
    "typeOfMerchant" character varying(200),
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "moduleCode" (
    "functionName" character varying(200) NOT NULL,
    "functionCode" character varying(100) NOT NULL,
    "group" character varying(100) NOT NULL,
    "description" character varying(200) NOT NULL,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "moduleCodeState" (
    "moduleCodeStateName" character varying(300) NOT NULL,
    "moduleCode" character varying(100) NOT NULL,
    "moduleStateCode" character varying(100) NOT NULL,
    "companyId" uuid,
    "description" character varying(200) NOT NULL,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true,
    "sequence" integer DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "order" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderNo" character varying(50) NOT NULL,
    "propertyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "phone" character varying(255),
    "name" character varying(255),
    "companyId" uuid NOT NULL,
    "customerId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "roomId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "status" character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    "orderType" character varying(30) DEFAULT 'PRODUCT'::character varying NOT NULL,
    "currency" character varying(10) DEFAULT 'USD'::character varying,
    "basePrice" numeric(10,2) NOT NULL,
    "discountAmount" numeric(10,2) DEFAULT 0,
    "taxAmount" numeric(10,2) DEFAULT 0,
    "totalPrice" numeric(10,2) DEFAULT 0,
    "paymentStatus" character varying(50) NOT NULL,
    "paymentMethod" character varying(50) NOT NULL,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "orderItem" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "quantity" integer DEFAULT 1,
    "unitPrice" numeric(18,2) NOT NULL,
    "totalPrice" numeric(18,2) NOT NULL,
    "productType" character varying(30),
    "option" text,
    "description" text,
    "status" character varying(30) DEFAULT 'PENDING'::character varying,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone,
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "orderItemWorkflow" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "quantity" integer DEFAULT 1,
    "unitPrice" numeric(18,2) NOT NULL,
    "totalPrice" numeric(18,2) NOT NULL,
    "productType" character varying(30),
    "option" text,
    "description" text,
    "status" character varying(30) DEFAULT 'PENDING'::character varying,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone,
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "orderSubscription" (
    "orderItemId" uuid NOT NULL,
    "startDate" timestamp with time zone,
    "endDate" timestamp with time zone,
    "type" character varying(20),
    "billingCycle" character varying(20),
    "autoRenew" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone,
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "orderWorkflow" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "orderNo" character varying(50) NOT NULL,
    "workflowId" uuid NOT NULL,
    "propertyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "phone" character varying(255),
    "roomId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "name" character varying(255),
    "companyId" uuid NOT NULL,
    "orderType" character varying(30) DEFAULT 'PRODUCT'::character varying NOT NULL,
    "customerId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "status" character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    "currency" character varying(10) DEFAULT 'USD'::character varying,
    "basePrice" numeric(10,2) NOT NULL,
    "discountAmount" numeric(10,2) DEFAULT 0,
    "taxAmount" numeric(10,2) DEFAULT 0,
    "totalPrice" numeric(10,2) DEFAULT 0,
    "paymentStatus" character varying(50) NOT NULL,
    "paymentMethod" character varying(50) NOT NULL,
    "reasonMessage" text,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "payment" (
    "paymentId" uuid DEFAULT gen_random_uuid() NOT NULL,
    "bookingId" uuid NOT NULL,
    "paymentDate" timestamp with time zone DEFAULT clock_timestamp(),
    "paymentMethod" character varying(50),
    "amountPaId" numeric(10,2) NOT NULL,
    "paymentStatus" character varying(50) NOT NULL,
    "slipUpload" text,
    "transactionId" text,
    "merchantId" text,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "paymentMethod" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "methodType" character varying(100) NOT NULL,
    "icon" text,
    "companyId" integer DEFAULT 0,
    "description" character varying(255),
    "isActive" boolean DEFAULT true NOT NULL,
    "details" text,
    "createdBy" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "modifiedBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "paymentStatus" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "statusName" character varying(50) NOT NULL,
    "description" character varying(255),
    "isActive" boolean DEFAULT true NOT NULL,
    "modifiedBy" uuid,
    "createdBy" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "position" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "title" character varying(255) NOT NULL,
    "slug" character varying(255) NOT NULL,
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "post" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "title" text NOT NULL,
    "categoryId" uuid,
    "categorySlug" character varying(300),
    "slug" text,
    "content" text NOT NULL,
    "lang" character varying(20) DEFAULT 'kh'::character varying,
    "thumbnail" text,
    "isPublished" boolean DEFAULT false,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "view" integer DEFAULT 0,
    "share" integer DEFAULT 0,
    "like" integer DEFAULT 0,
    "comment" integer DEFAULT 0,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(30) DEFAULT 'ACTIVE'::character varying,
    "companyId" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "postCategory" (
    "postId" uuid NOT NULL,
    "categoryId" uuid NOT NULL,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "postTag" (
    "postId" uuid NOT NULL,
    "tagId" uuid NOT NULL,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "priceType" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "companyId" uuid,
    "title" character varying(50),
    "createdBy" uuid,
    "modifiedBy" uuid,
    "isDefault" boolean,
    "isActive" boolean DEFAULT true,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "product" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "companyId" uuid NOT NULL,
    "propertyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "barcode" character varying(100) NOT NULL,
    "name" character varying(150) NOT NULL,
    "description" text,
    "sKU" character varying(50),
    "isActive" boolean DEFAULT true,
    "productType" uuid,
    "productTypeSlug" character varying(300),
    "slug" text,
    "order" integer DEFAULT 0,
    "price" numeric(10,2) DEFAULT 0.00,
    "unit" character varying(50) DEFAULT 'unit'::character varying,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "productOptionType" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(50) NOT NULL,
    "productId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    "description" text,
    "thumbnail" text,
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    "order" integer DEFAULT 0,
    "actionType" character varying(100) DEFAULT 'Radio'::character varying,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "productOptionTypeValue" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "productOptionTypeId" uuid NOT NULL,
    "name" character varying(50) NOT NULL,
    "description" text,
    "thumbnail" text,
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    "price" numeric(10,2) DEFAULT 0.00,
    "order" integer DEFAULT 0,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "productType" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "slug" text,
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "name" character varying(150) NOT NULL,
    "description" character varying(200),
    "order" integer DEFAULT 0,
    "image" character varying(300),
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "productWithOptionType" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(50) NOT NULL,
    "porductOptionTypeId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "propertyFacilities" (
    "belongTo" uuid NOT NULL,
    "facilityId" uuid NOT NULL,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "propertyFeature" (
    "belongTo" uuid NOT NULL,
    "featureId" uuid NOT NULL,
    "isActive" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "propertyOrRoomPrice" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "currency" character varying(50) DEFAULT 'dollar'::character varying,
    "belongTo" uuid,
    "priceTypeId" uuid,
    "price" numeric(18,2),
    "isDefault" boolean DEFAULT false,
    "createdBy" uuid,
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "propertyStatus" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(50),
    "isActive" boolean DEFAULT true,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "propertyType" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "propertyTypeName" character varying(200),
    "status" boolean DEFAULT true,
    "icon" character varying(500),
    "categoryType" character varying(100),
    "createdAt" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "queueJob" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "jobId" character varying(200) NOT NULL,
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "queueName" character varying(200) NOT NULL,
    "jobName" character varying(200),
    "payload" text,
    "result" text,
    "progress" integer DEFAULT 0,
    "status" character varying(50) DEFAULT 'waiting'::character varying NOT NULL,
    "attempts" integer DEFAULT 0,
    "maxAttempts" integer DEFAULT 3,
    "priority" integer DEFAULT 0,
    "errorMessage" text,
    "keepUntil" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "startedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "completedAt" timestamp with time zone
);

CREATE TABLE IF NOT EXISTS "realEstateProperty" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "title" text,
    "description" text,
    "companyId" uuid NOT NULL,
    "countryId" uuid NOT NULL,
    "address" character varying(500),
    "parentId" uuid,
    "propertyFor" character varying(10) DEFAULT 'Rent'::character varying,
    "propertyType" uuid,
    "status" character varying(50),
    "numberOfFloor" integer DEFAULT 0,
    "isActive" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "realEstatePropertyPolicy" (
    "belongTo" uuid NOT NULL,
    "parkingPolicy" character varying(50),
    "breakfastPolicy" character varying(50),
    "smokingAllowed" boolean DEFAULT false,
    "petsAllowed" boolean DEFAULT false,
    "childrenAllowed" boolean DEFAULT false,
    "partiesAllowed" boolean DEFAULT false,
    "checkInFrom" timestamp with time zone,
    "checkInTo" timestamp with time zone,
    "checkOutFrom" timestamp with time zone,
    "checkOutTo" timestamp with time zone,
    "ageRestriction" character varying(300),
    "optionJson" text DEFAULT '{}'::text,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "rentalContract" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "tenantId" uuid NOT NULL,
    "propertyId" uuid NOT NULL,
    "companyId" uuid NOT NULL,
    "startDate" date NOT NULL,
    "endDate" date NOT NULL,
    "monthlyRate" numeric(10,2) NOT NULL,
    "depositAmount" numeric(10,2) DEFAULT 0,
    "status" character varying(50) DEFAULT 'Active'::character varying,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "requestLogs" (
    "id" integer NOT NULL,
    "fromUrl" text,
    "toUrl" text,
    "service" character varying(200),
    "requestBody" text,
    "responseBody" text,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "requester" text
);

CREATE TABLE IF NOT EXISTS "resource" (
    "id" uuid NOT NULL,
    "name" character varying(255) NOT NULL,
    "position" integer,
    "description" character varying(50),
    "category" character varying(50) NOT NULL,
    "path" character varying(200) NOT NULL,
    "isActive" boolean DEFAULT true,
    "isRootOnly" boolean DEFAULT false,
    "modifiedBy" uuid,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "categoryType" character varying(50)
);

CREATE TABLE IF NOT EXISTS "roles" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "roleName" character varying(50) NOT NULL,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "description" character varying(200),
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "room" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "roomNumber" character varying(50),
    "propertyId" uuid,
    "companyId" uuid,
    "roomType" uuid,
    "maxGuest" integer,
    "floor" integer DEFAULT 0,
    "roomSize" integer,
    "roomSizeScale" character varying(20) DEFAULT 'square meters'::character varying,
    "allowedSmoking" boolean DEFAULT false,
    "bathroomPrivate" boolean DEFAULT true,
    "bathroomItems" text,
    "status" character varying(50),
    "badgeOption" character varying(500),
    "isActive" boolean DEFAULT true,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "description" text,
    "allowedChildren" boolean DEFAULT true,
    "childrenOption" text,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "stock" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "companyId" uuid NOT NULL,
    "warehouseId" uuid,
    "productId" uuid NOT NULL,
    "providerId" uuid,
    "transactionType" character varying(20) NOT NULL,
    "quantity" integer DEFAULT 0,
    "unit" character varying(50) DEFAULT 'unit'::character varying,
    "unitCost" numeric(12,2) DEFAULT 0.00,
    "totalCost" numeric(12,2) DEFAULT 0.00,
    "stockBefore" integer DEFAULT 0,
    "stockAfter" integer DEFAULT 0,
    "referenceType" character varying(50),
    "referenceId" uuid,
    "referenceCode" character varying(50),
    "batchNumber" character varying(50),
    "expiredAt" timestamp with time zone,
    "serialNumber" character varying(100),
    "note" character varying(500),
    "importDate" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "subCategory" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100) NOT NULL,
    "slug" character varying(100) NOT NULL,
    "logo" text,
    "description" character varying(500),
    "isPublished" boolean DEFAULT true,
    "order" integer,
    "categoryId" uuid,
    "companyId" uuid,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "count" integer,
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "subscription" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "companyId" uuid NOT NULL,
    "planId" uuid NOT NULL,
    "planPrice" numeric(10,2) NOT NULL,
    "planName" character varying(40) NOT NULL,
    "type" character varying(40),
    "referencePlan" text,
    "planFeature" text,
    "startDate" timestamp with time zone DEFAULT clock_timestamp(),
    "endDate" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true NOT NULL,
    "paymentStatus" character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    "autoRenew" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying,
    "quantity" integer DEFAULT 1,
    "discountPercentage" numeric(5,2) DEFAULT 0,
    "discountPrice" numeric(10,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "subscriptionPlan" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100) NOT NULL,
    "price" numeric(10,2) NOT NULL,
    "description" character varying(200),
    "option" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying,
    "featurePlan" text
);

CREATE TABLE IF NOT EXISTS "subscriptionPlanFeature" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100) NOT NULL,
    "key" character varying(100) NOT NULL,
    "value" character varying(200),
    "createdBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "tag" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(50) NOT NULL,
    "slug" character varying(50) NOT NULL,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp()
);

CREATE TABLE IF NOT EXISTS "tenant" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100),
    "companyId" uuid,
    "phone" character varying(500),
    "nationalId" character varying(50),
    "profile" text,
    "address" text,
    "documentSupport" text,
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true,
    "linkUserId" uuid
);

CREATE TABLE IF NOT EXISTS "tenantMonthlyPayment" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "tenantId" uuid NOT NULL,
    "propertyId" uuid NOT NULL,
    "companyId" uuid NOT NULL,
    "rentalContractId" uuid NOT NULL,
    "dueDate" date NOT NULL,
    "paidDate" date,
    "amount" numeric(10,2) NOT NULL,
    "paymentStatus" character varying(50) DEFAULT 'Unpaid'::character varying,
    "note" character varying(255),
    "createdBy" uuid,
    "modifiedBy" uuid,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20) DEFAULT 'ACTIVE'::character varying
);

CREATE TABLE IF NOT EXISTS "transaction" (
    "id" uuid NOT NULL,
    "transferId" uuid NOT NULL,
    "accountId" uuid NOT NULL,
    "direction" character varying(10) NOT NULL,
    "amount" numeric(18,2) NOT NULL,
    "balanceCurrency" numeric(18,2) NOT NULL,
    "balanceBefore" numeric(18,2) NOT NULL,
    "balanceAfter" numeric(18,2) NOT NULL,
    "currencyId" uuid NOT NULL,
    "transactionType" character varying(200),
    "status" character varying(200),
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "transactionLog" (
    "logId" integer NOT NULL,
    "transactionId" integer,
    "companyId" integer,
    "event" character varying(200),
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" integer NOT NULL
);

CREATE TABLE IF NOT EXISTS "user" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "firstName" character varying(50),
    "lastName" character varying(50),
    "groupResourceId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    "companyId" uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    "userName" character varying(100),
    "email" character varying(100),
    "phone" character varying(300),
    "phoneCountryCode" character varying(10),
    "otpCode" character varying(20),
    "otpExpireDate" timestamp with time zone,
    "isResetPassword" boolean DEFAULT false,
    "password" text NOT NULL,
    "profile" text,
    "staffId" character varying(100),
    "registerType" character varying(10) DEFAULT 'phone'::character varying NOT NULL,
    "accountType" integer DEFAULT 0,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedBy" character varying(50),
    "createdBy" character varying(50),
    "isActive" boolean DEFAULT true,
    "isBlock" boolean DEFAULT false,
    "ip" character varying(30),
    "status" character varying(10),
    "bio" text,
    "role" character varying(20),
    "address" text
);

CREATE TABLE IF NOT EXISTS "userRole" (
    "roleId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "userId" uuid NOT NULL,
    "createdBy" character varying(50),
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "watchLaterPosts" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "userId" uuid NOT NULL,
    "postId" uuid NOT NULL,
    "savedAt" timestamp with time zone DEFAULT clock_timestamp(),
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT clock_timestamp(),
    "createdBy" uuid NOT NULL
);

CREATE TABLE IF NOT EXISTS "workflow" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "name" character varying(100) NOT NULL,
    "companyId" uuid,
    "description" character varying(500),
    "functionCode" character varying(200),
    "code" character varying(200),
    "createdBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "modifiedBy" uuid,
    "modifiedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20),
    "displayStatus" character varying(200),
    "isActive" boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS "workflowState" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "state" character varying(100) NOT NULL,
    "companyId" uuid,
    "workflowId" uuid NOT NULL,
    "conditionNumber" integer,
    "sequence" integer NOT NULL,
    "conditionDefinition" character varying(50) NOT NULL,
    "conditionDefinitionDisplay" character varying(200) NOT NULL,
    "approvalNumber" integer,
    "countApproval" integer,
    "conjunction" character varying(10) DEFAULT 'AND'::character varying,
    "isFinal" boolean DEFAULT false,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "completedOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20)
);

CREATE TABLE IF NOT EXISTS "workflowStateCurrent" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "workflowId" uuid NOT NULL,
    "workflowStateId" uuid NOT NULL,
    "referenceId" uuid,
    "referenceType" character varying(100) NOT NULL,
    "status" character varying(50) DEFAULT 'InProgress'::character varying,
    "step" integer NOT NULL
);

CREATE TABLE IF NOT EXISTS "workflowStateUser" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "workflowStateId" uuid NOT NULL,
    "workflowId" uuid NOT NULL,
    "userId" uuid,
    "sequence" integer,
    "createdBy" uuid,
    "createdOn" timestamp with time zone DEFAULT clock_timestamp(),
    "status" character varying(20)
);

