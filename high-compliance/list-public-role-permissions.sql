/*
    list-public-role-permissions.sql
    Displays permissions granted to the public role at server and database scope with grantor details.

    Refs: CIS SQL Server 2.5
*/
SELECT
    'SERVER' AS Scope,
    perm.permission_name,
    perm.state_desc,
    perm.class_desc,
    perm.major_id,
    perm.minor_id,
    grantor.name AS Grantor,
    grantee.name AS Grantee
FROM sys.server_permissions AS perm
JOIN sys.server_principals AS grantee
    ON perm.grantee_principal_id = grantee.principal_id
JOIN sys.server_principals AS grantor
    ON perm.grantor_principal_id = grantor.principal_id
WHERE perm.grantee_principal_id = SUSER_ID('public')

UNION ALL

SELECT
    'DATABASE' AS Scope,
    perm.permission_name,
    perm.state_desc,
    perm.class_desc,
    perm.major_id,
    perm.minor_id,
    grantor.name AS Grantor,
    grantee.name AS Grantee
FROM sys.database_permissions AS perm
JOIN sys.database_principals AS grantee
    ON perm.grantee_principal_id = grantee.principal_id
JOIN sys.database_principals AS grantor
    ON perm.grantor_principal_id = grantor.principal_id
WHERE perm.grantee_principal_id = DATABASE_PRINCIPAL_ID('public');
