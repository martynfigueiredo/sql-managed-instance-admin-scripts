/*
    check-guest-user-status.sql
    Shows whether the guest user is disabled in the current database with extra metadata.

    Refs: CIS SQL Server 2.1
*/
SELECT
    DB_NAME() AS DatabaseName,
    dp.principal_id,
    dp.name AS PrincipalName,
    dp.type_desc,
    dp.authentication_type_desc,
    dp.default_schema_name,
    dp.create_date,
    dp.modify_date,
    dp.is_disabled
FROM sys.database_principals AS dp
WHERE dp.name = 'guest';
