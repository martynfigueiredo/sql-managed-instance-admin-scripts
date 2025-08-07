/*
    server-permissions.sql
    Detailed server-level permissions.
*/

SELECT
    dp.grantee_principal_id,
    sp.name           AS grantee_name,
    sp.type_desc      AS grantee_type,
    sp.sid            AS grantee_sid,
    dp.class_desc,
    dp.class,
    dp.major_id,
    dp.minor_id,
    dp.permission_name,
    dp.state_desc,
    dp.grantor_principal_id,
    gp.name           AS grantor_name,
    gp.type_desc      AS grantor_type,
    obj.name          AS object_name,
    obj.type_desc     AS object_type
FROM sys.server_permissions AS dp
LEFT JOIN sys.server_principals AS sp
       ON dp.grantee_principal_id = sp.principal_id
LEFT JOIN sys.server_principals AS gp
       ON dp.grantor_principal_id = gp.principal_id
LEFT JOIN sys.server_principals AS obj
       ON dp.major_id = obj.principal_id
ORDER BY sp.name, dp.permission_name;
