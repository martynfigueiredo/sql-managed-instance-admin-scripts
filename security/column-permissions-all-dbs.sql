/*
    column-permissions-all-dbs.sql
    Column-level permissions for all databases.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       OBJECT_NAME(colperm.major_id, DB_ID(''' + name + ''')) AS table_name,
       colperm.major_id,
       colperm.class_desc,
       colperm.column_id,
       c.name AS column_name,
       TYPE_NAME(c.user_type_id) AS data_type,
       c.max_length,
       c.precision,
       c.scale,
       colperm.permission_name,
       colperm.state_desc,
       colperm.grantor_principal_id,
       grantor.name AS grantor_name,
       grantee.principal_id AS grantee_principal_id,
       grantee.name AS grantee_name,
       grantee.type_desc AS grantee_type
FROM [' + name + '].sys.column_permissions AS colperm
JOIN [' + name + '].sys.columns AS c
     ON colperm.column_id = c.column_id
    AND colperm.major_id = c.object_id
JOIN [' + name + '].sys.database_principals AS grantee
     ON colperm.grantee_principal_id = grantee.principal_id
LEFT JOIN [' + name + '].sys.database_principals AS grantor
     ON colperm.grantor_principal_id = grantor.principal_id
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);
EXEC sys.sp_executesql @sql;
