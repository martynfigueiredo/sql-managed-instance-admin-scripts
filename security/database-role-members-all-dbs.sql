/*
    database-role-members-all-dbs.sql
    Role membership per database.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       rp.principal_id AS role_principal_id,
       rp.name AS role_name,
       rp.type_desc AS role_type,
       rp.create_date AS role_create_date,
       mp.principal_id AS member_principal_id,
       mp.name AS member_name,
       mp.type_desc AS member_type,
       mp.authentication_type_desc AS member_auth,
       mp.create_date AS member_create_date
FROM [' + name + '].sys.database_role_members AS drm
JOIN [' + name + '].sys.database_principals AS rp
     ON drm.role_principal_id = rp.principal_id
JOIN [' + name + '].sys.database_principals AS mp
     ON drm.member_principal_id = mp.principal_id
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);
EXEC sys.sp_executesql @sql;
