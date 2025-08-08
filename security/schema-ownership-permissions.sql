/*
    schema-ownership-permissions.sql
    Schemas with owners and permissions.
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
            s.schema_id,
            s.name AS schema_name,
            s.principal_id AS owner_principal_id,
            dp.name AS owner_name,
            dp.type_desc AS owner_type,
            s.create_date,
            s.modify_date,
            perm.permission_name,
            perm.state_desc,
            perm.grantor_principal_id,
            grantor.name AS grantor_name,
            grantee.principal_id AS grantee_principal_id,
            grantee.name AS grantee_name,
            grantee.type_desc AS grantee_type
     FROM ' + QUOTENAME(name) + '.sys.schemas AS s
     JOIN ' + QUOTENAME(name) + '.sys.database_principals AS dp
          ON s.principal_id = dp.principal_id
     LEFT JOIN ' + QUOTENAME(name) + '.sys.database_permissions AS perm
          ON perm.major_id = s.schema_id
         AND perm.class = 3
     LEFT JOIN ' + QUOTENAME(name) + '.sys.database_principals AS grantee
          ON perm.grantee_principal_id = grantee.principal_id
     LEFT JOIN ' + QUOTENAME(name) + '.sys.database_principals AS grantor
          ON perm.grantor_principal_id = grantor.principal_id',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
