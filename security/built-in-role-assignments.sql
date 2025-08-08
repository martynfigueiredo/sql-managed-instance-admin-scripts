/*
    built-in-role-assignments.sql
    Built-in server roles and their members for quick review.
*/

SELECT
    spr.principal_id AS role_principal_id,
    spr.name      AS role_name,
    spr.type_desc AS role_type,
    spr.is_disabled AS role_disabled,
    spr.create_date AS role_create_date,
    spr.modify_date AS role_modify_date,
    spm.principal_id AS member_principal_id,
    spm.name      AS member_name,
    spm.type_desc AS member_type,
    spm.is_disabled AS member_disabled,
    spm.default_database_name,
    spm.default_language_name,
    spm.create_date,
    spm.modify_date
FROM sys.server_role_members AS srm
JOIN sys.server_principals AS spr
     ON srm.role_principal_id = spr.principal_id
JOIN sys.server_principals AS spm
     ON srm.member_principal_id = spm.principal_id
WHERE spr.is_fixed_role = 1
ORDER BY spr.name, spm.name;
