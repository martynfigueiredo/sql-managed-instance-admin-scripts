/*
    list-high-privilege-users.sql
    Lists logins and database users with high privileges to support compliance audits.

    Refs: SOX 404 (privileged access review), GDPR Art. 32 (security of processing), ISO 27001 A.9.2
*/

-- Server-level principals with sysadmin role or equivalent permissions
SELECT
    sp.name AS [User],
    'sysadmin' AS Role,
    'SERVER ROLE' AS PermissionType,
    ep.value AS Justification
FROM sys.server_role_members AS srm
JOIN sys.server_principals AS sp
    ON srm.member_principal_id = sp.principal_id
LEFT JOIN sys.extended_properties AS ep
    ON ep.class = 100
    AND ep.major_id = sp.principal_id
    AND ep.name = 'JUSTIFICATION'
WHERE srm.role_principal_id = SUSER_ID('sysadmin')

UNION ALL

SELECT
    sp.name AS [User],
    perm.permission_name AS Role,
    'SERVER PERMISSION' AS PermissionType,
    ep.value AS Justification
FROM sys.server_permissions AS perm
JOIN sys.server_principals AS sp
    ON perm.grantee_principal_id = sp.principal_id
LEFT JOIN sys.extended_properties AS ep
    ON ep.class = 100
    AND ep.major_id = sp.principal_id
    AND ep.name = 'JUSTIFICATION'
WHERE perm.permission_name = 'CONTROL SERVER'
  AND perm.state_desc IN ('GRANT', 'GRANT_WITH_GRANT_OPTION')

UNION ALL

-- Database users with db_owner role or CONTROL permissions
SELECT
    dp.name AS [User],
    'db_owner' AS Role,
    'DATABASE ROLE' AS PermissionType,
    ep.value AS Justification
FROM sys.database_role_members AS drm
JOIN sys.database_principals AS dp
    ON drm.member_principal_id = dp.principal_id
LEFT JOIN sys.extended_properties AS ep
    ON ep.class = 0
    AND ep.major_id = dp.principal_id
    AND ep.name = 'JUSTIFICATION'
WHERE drm.role_principal_id = USER_ID('db_owner')

UNION ALL

SELECT
    dp.name AS [User],
    perm.permission_name AS Role,
    'DATABASE PERMISSION' AS PermissionType,
    ep.value AS Justification
FROM sys.database_permissions AS perm
JOIN sys.database_principals AS dp
    ON perm.grantee_principal_id = dp.principal_id
LEFT JOIN sys.extended_properties AS ep
    ON ep.class = 0
    AND ep.major_id = dp.principal_id
    AND ep.name = 'JUSTIFICATION'
WHERE perm.permission_name = 'CONTROL'
  AND perm.state_desc IN ('GRANT', 'GRANT_WITH_GRANT_OPTION')

ORDER BY PermissionType, [User];
