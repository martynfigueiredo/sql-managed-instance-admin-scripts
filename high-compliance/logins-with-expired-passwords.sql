/*
    logins-with-expired-passwords.sql
    Lists SQL logins that have expired passwords or must change passwords with additional details.

    Refs: CIS SQL Server 2.14
*/
/*
    logins-with-password-info.sql
    Lists all logins with information on password expiration, must-change status,
    type, authentication, and other useful properties.

    Refs: CIS SQL Server 2.14
*/
SELECT 
    sp.principal_id,
    sp.name AS LoginName,
    sp.type_desc AS LoginType,
    sp.default_database_name,
    sp.default_language_name,
    sp.is_disabled,
    sp.create_date,
    sp.modify_date,
    sp.credential_id,
    sl.is_expiration_checked,
    sl.is_policy_checked,
    LOGINPROPERTY(sp.name, 'PasswordLastSetTime') AS PasswordLastSetTime,
    LOGINPROPERTY(sp.name, 'IsExpired') AS IsExpired,
    LOGINPROPERTY(sp.name, 'IsMustChange') AS MustChange,
    s.last_login AS LastLoginTime
FROM sys.server_principals sp
LEFT JOIN sys.sql_logins sl
    ON sp.principal_id = sl.principal_id
OUTER APPLY (
    SELECT MAX(login_time) AS last_login
    FROM sys.dm_exec_sessions
    WHERE original_login_name = sp.name
) AS s
WHERE sp.type IN ('S', 'U', 'G')  -- S = SQL login, U = Windows login, G = Windows group
  AND sp.name NOT LIKE '##%##'    -- Exclude system internal logins
ORDER BY 
    IsExpired DESC,
    MustChange DESC,
    PasswordLastSetTime;
