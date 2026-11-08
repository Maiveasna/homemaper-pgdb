-- This file contains SQL statements that will be executed after the build script.

-- Create admin user if it does not already exist
INSERT INTO "user"
(
    "id",
    "firstName",
    "lastName",
    "groupResourceId",
    "companyId",
    "userName",
    "email",
    "phone",
    "password",
    "registerType",
    "isActive",
    "accountType",
    "role"
)
SELECT
    '00000000-0000-0000-0000-000000000000'::UUID,
    'admin',
    'supper',
    '00000000-0000-0000-0000-000000000000'::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID,
    'admin',
    'admin@gmail.com',
    NULL,
    '182947aa7d61e96913f421933ef629317df78959b08373bf06bfb907a4e6bf45', -- Password (hashed)
    'username',
    TRUE,
    1,
    'SUPER_ADMIN'
WHERE NOT EXISTS
(
    SELECT 1
    FROM "user"
    WHERE "userName" = 'admin'
);


-- Create root user if it does not already exist
INSERT INTO "user"
(
    "id",
    "firstName",
    "lastName",
    "groupResourceId",
    "companyId",
    "userName",
    "email",
    "phone",
    "password",
    "registerType",
    "isActive",
    "accountType",
    "role"
)
SELECT
    '00000000-0000-0000-0000-000000000001'::UUID,
    'root',
    'supper',
    '00000000-0000-0000-0000-000000000000'::UUID,
    '00000000-0000-0000-0000-000000000000'::UUID,
    'root',
    'root@gmail.com',
    NULL,
    'e6ca9ce1bead45c6e30e3e500cc1c324e8a2b20b4e2ae7fdda0bb85ad12c3786', -- Password (hashed)
    'username',
    TRUE,
    1,
    'SUPER_ADMIN'
WHERE NOT EXISTS
(
    SELECT 1
    FROM "user"
    WHERE "userName" = 'root'
);