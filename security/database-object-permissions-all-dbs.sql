/*
    database-object-permissions-all-dbs.sql
    Object-level permissions per database with wide detail.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       dp.class_desc,
       dp.class,
       dp.major_id,
       dp.minor_id,
       OBJECT_SCHEMA_NAME(dp.major_id, DB_ID(''' + name + ''')) AS schema_name,
       OBJECT_NAME(dp.major_id, DB_ID(''' + name + ''')) AS object_name,
       o.type_desc AS object_type,
       dp.permission_name,
       dp.state_desc,
       dp.grantee_principal_id,
       grantee.name AS grantee_name,
       grantee.type_desc AS grantee_type,
       grantee.authentication_type_desc AS grantee_auth,
       dp.grantor_principal_id,
       grantor.name AS grantor_name,
       grantor.type_desc AS grantor_type,
       grantor.authentication_type_desc AS grantor_auth
FROM [' + name + '].sys.database_permissions AS dp
JOIN [' + name + '].sys.database_principals AS grantee
     ON dp.grantee_principal_id = grantee.principal_id
JOIN [' + name + '].sys.database_principals AS grantor
     ON dp.grantor_principal_id = grantor.principal_id
LEFT JOIN [' + name + '].sys.objects AS o
     ON dp.major_id = o.object_id
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);

