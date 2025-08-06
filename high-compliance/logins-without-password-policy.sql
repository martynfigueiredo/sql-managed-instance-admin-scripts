/*
    logins-without-password-policy.sql
    Finds SQL logins that do not enforce password or expiration policies with additional metadata.

    Refs: CIS SQL Server 2.9
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
    is_policy_checked,
    is_expiration_checked
FROM sys.sql_logins
WHERE is_policy_checked = 0
   OR is_expiration_checked = 0;
