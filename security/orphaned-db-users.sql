/*
    orphaned-db-users.sql
    Orphaned users per database.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       dp.principal_id,
       dp.name AS user_name,
       dp.type_desc,
       dp.sid,
       dp.default_schema_name,
       dp.authentication_type_desc,
       dp.create_date,
       dp.modify_date
FROM [' + name + '].sys.database_principals AS dp
LEFT JOIN sys.server_principals AS sp
       ON dp.sid = sp.sid
WHERE dp.type_desc IN (''SQL_USER'',''WINDOWS_USER'')
  AND sp.sid IS NULL
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);
EXEC sys.sp_executesql @sql;
