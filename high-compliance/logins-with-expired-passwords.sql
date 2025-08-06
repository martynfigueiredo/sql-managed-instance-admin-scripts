/*
    logins-with-expired-passwords.sql
    Lists SQL logins that have expired passwords or must change passwords with additional details.

    Refs: CIS SQL Server 2.14
*/
SELECT
    principal_id,
    name AS LoginName,
    default_database_name,
    default_language_name,
    is_disabled,
    create_date,
    modify_date,
    LOGINPROPERTY(name, 'PasswordLastSetTime') AS PasswordLastSetTime,
    LOGINPROPERTY(name, 'IsExpired') AS IsExpired,
    LOGINPROPERTY(name, 'IsMustChange') AS MustChange
FROM sys.sql_logins
WHERE LOGINPROPERTY(name, 'IsExpired') = 1
   OR LOGINPROPERTY(name, 'IsMustChange') = 1;
