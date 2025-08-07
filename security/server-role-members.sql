/*
    server-role-members.sql
    Report of server role membership with both role and member details.
*/

SELECT
    srm.role_principal_id,
    rp.name AS role_name,
    rp.type_desc AS role_type,
    rp.create_date AS role_create_date,
    srm.member_principal_id,
    mp.name AS member_name,
    mp.type_desc AS member_type,
    mp.is_disabled,
    mp.default_database_name,
    mp.default_language_name,
    mp.create_date,
    mp.modify_date
FROM sys.server_role_members AS srm
JOIN sys.server_principals AS rp
     ON srm.role_principal_id = rp.principal_id
JOIN sys.server_principals AS mp
     ON srm.member_principal_id = mp.principal_id
ORDER BY rp.name, mp.name;
