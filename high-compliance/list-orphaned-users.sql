/*
    list-orphaned-users.sql
    Finds database principals that do not have matching server logins with detailed info.

    Refs: CIS SQL Server, ISO 27001 A.9
*/
SELECT
    DB_NAME() AS DatabaseName,
    dp.principal_id,
    dp.name AS UserName,
    dp.type_desc AS UserType,
    dp.authentication_type_desc,
    dp.default_schema_name,
    dp.create_date,
    dp.modify_date,
    dp.sid
FROM sys.database_principals AS dp
LEFT JOIN sys.server_principals AS sp
    ON dp.sid = sp.sid
WHERE sp.sid IS NULL
  AND dp.type IN ('S', 'U')
  AND dp.name NOT IN ('guest', 'dbo', 'INFORMATION_SCHEMA', 'sys');
