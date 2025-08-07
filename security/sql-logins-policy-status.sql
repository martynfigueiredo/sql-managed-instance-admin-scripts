/*
    sql-logins-policy-status.sql
    SQL logins with password and policy settings.
*/

SELECT
    principal_id,
    sid,
    name,
    type_desc,
    is_disabled,
    default_database_name,
    default_language_name,
    credential_id,
    owning_principal_id,
    create_date,
    modify_date,
    password_hash,
    password_last_set_time,
    is_policy_checked,
    is_expiration_checked,
    locked_out
FROM sys.sql_logins
ORDER BY name;
