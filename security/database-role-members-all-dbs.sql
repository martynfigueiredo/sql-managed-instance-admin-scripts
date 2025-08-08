/*
    database-role-members-all-dbs.sql
    Role membership per database.
*/

DECLARE @sql NVARCHAR(MAX);

;WITH dbs AS (
    SELECT name
    FROM sys.databases
    WHERE state_desc = 'ONLINE'
      AND database_id > 4
)
SELECT @sql = STRING_AGG(
    'SELECT ' + QUOTENAME(name, '''') + ' AS database_name,
            rp.principal_id AS role_principal_id,
            rp.name AS role_name,
            rp.type_desc AS role_type,
            rp.create_date AS role_create_date,
            mp.principal_id AS member_principal_id,
            mp.name AS member_name,
            mp.type_desc AS member_type,
            mp.authentication_type_desc AS member_auth,
            mp.create_date AS member_create_date
     FROM ' + QUOTENAME(name) + '.sys.database_role_members AS drm
     JOIN ' + QUOTENAME(name) + '.sys.database_principals AS rp
          ON drm.role_principal_id = rp.principal_id
     JOIN ' + QUOTENAME(name) + '.sys.database_principals AS mp
          ON drm.member_principal_id = mp.principal_id',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
