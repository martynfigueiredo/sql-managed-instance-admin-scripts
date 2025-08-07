/*
    server-principals-and-roles.sql
    Comprehensive server principals list, including role membership and login policy information.
*/

SELECT
    sp.principal_id,
    sp.sid,
    sp.name               AS principal_name,
    sp.type_desc          AS principal_type,
    sp.default_database_name,
    sp.default_language_name,
    sp.owning_principal_id,
    sp.credential_id,
    sp.is_fixed_role,
    sp.is_disabled,
    sp.create_date,
    sp.modify_date,
    sp.authentication_type_desc,
    sl.is_policy_checked,
    sl.is_expiration_checked,
    sl.password_hash,
    sl.password_last_set_time,
    sl.lockout_time,
    spr.principal_id       AS role_principal_id,
    spr.name               AS role_name
FROM sys.server_principals AS sp
LEFT JOIN sys.sql_logins AS sl
       ON sp.principal_id = sl.principal_id
LEFT JOIN sys.server_role_members AS srm
       ON sp.principal_id = srm.member_principal_id
LEFT JOIN sys.server_principals AS spr
       ON srm.role_principal_id = spr.principal_id
ORDER BY sp.type_desc, sp.name;
