/*
    list-open-endpoints.sql
    Lists network endpoints that are started and accessible with additional details.

    Refs: CIS SQL Server 4.1
*/
/*
    list-open-endpoints.sql
    Lists STARTED network endpoints with TCP settings
    and access permissions.

    Reference: CIS SQL Server Benchmark 4.1
*/

SELECT
    e.endpoint_id,
    e.name AS EndpointName,
    e.protocol_desc,
    e.type_desc,
    e.state_desc,
    e.is_admin_endpoint,

    -- TCP details
    te.port AS TcpPort,
    te.is_dynamic_port,

    -- Permissions
    perm.permission_name,
    perm.state_desc AS PermissionState,
    sp.name AS GranteeName,
    sp.type_desc AS GranteeType

FROM sys.endpoints AS e
LEFT JOIN sys.tcp_endpoints AS te
    ON e.endpoint_id = te.endpoint_id
LEFT JOIN sys.server_permissions AS perm
    ON perm.class = 105 AND perm.major_id = e.endpoint_id
LEFT JOIN sys.server_principals AS sp
    ON perm.grantee_principal_id = sp.principal_id

WHERE e.state_desc = 'STARTED'
ORDER BY e.endpoint_id, sp.name;

