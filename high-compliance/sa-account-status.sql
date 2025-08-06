/*
    sa-account-status.sql
    Reports status of the sa login with extra details.

    Refs: CIS SQL Server 1.2
*/
SELECT
    principal_id,
    name AS LoginName,
    type_desc,
    default_database_name,
    default_language_name,
    is_disabled,
    create_date,
    modify_date,
    LOGINPROPERTY(name, 'BadPasswordCount') AS BadPasswordCount,
    LOGINPROPERTY(name, 'LastLogonTime') AS LastLogonTime
FROM sys.server_principals
WHERE sid = 0x01;
