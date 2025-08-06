/*
    list-open-endpoints.sql
    Lists network endpoints that are started and accessible with additional details.

    Refs: CIS SQL Server 4.1
*/
SELECT
    e.endpoint_id,
    e.name AS EndpointName,
    e.protocol_desc,
    e.type_desc,
    e.state_desc,
    e.is_admin_endpoint,
    te.port,
    te.is_dynamic_port,
    e.create_date,
    e.modify_date
FROM sys.endpoints AS e
LEFT JOIN sys.tcp_endpoints AS te
    ON e.endpoint_id = te.endpoint_id
WHERE e.state_desc = 'STARTED';
