/*
    endpoint-permissions.sql
    Endpoint definitions and permissions.
*/

SELECT
    e.endpoint_id,
    e.name AS endpoint_name,
    e.principal_id,
    e.owner_sid,
    e.type_desc,
    e.protocol_desc,
    e.state_desc,
    e.is_admin_endpoint,
    e.create_date,
    e.modify_date,
    sp.major_id,
    sp.permission_name,
    sp.state_desc,
    sp.class_desc,
    sp.grantor_principal_id,
    grantor.name AS grantor_name,
    grantee.principal_id AS grantee_principal_id,
    grantee.name AS grantee_name
FROM sys.endpoints AS e
LEFT JOIN sys.server_permissions AS sp
     ON e.endpoint_id = sp.major_id
    AND sp.class_desc = 'ENDPOINT'
LEFT JOIN sys.server_principals AS grantee
     ON sp.grantee_principal_id = grantee.principal_id
LEFT JOIN sys.server_principals AS grantor
     ON sp.grantor_principal_id = grantor.principal_id
ORDER BY e.name;
