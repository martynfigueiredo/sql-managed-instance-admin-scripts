/*
    database-principals-all-dbs.sql
    Database principals for all online databases.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT DB_NAME() AS database_name,
       dp.principal_id,
       dp.sid,
       dp.name,
       dp.type,
       dp.type_desc,
       dp.default_schema_name,
       dp.default_language_name,
       dp.owning_principal_id,
       dp.authentication_type_desc,
       dp.create_date,
       dp.modify_date,
       dp.is_fixed_role
FROM sys.database_principals AS dp
WHERE dp.type NOT IN (''A'',''G'',''R'',''X''); -- skip application roles, etc.
'
+ CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
FROM sys.databases
WHERE state_desc = 'ONLINE'
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN('UNION ALL')-2);
EXEC sys.sp_executesql @sql;
