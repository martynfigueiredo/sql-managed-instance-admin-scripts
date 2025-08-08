/*
    orphaned-db-users.sql
    Orphaned users per database.
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
            dp.principal_id,
            dp.name AS user_name,
            dp.type_desc,
            dp.sid,
            dp.default_schema_name,
            dp.authentication_type_desc,
            dp.create_date,
            dp.modify_date
     FROM ' + QUOTENAME(name) + '.sys.database_principals AS dp
     LEFT JOIN sys.server_principals AS sp
            ON dp.sid = sp.sid
     WHERE dp.type_desc IN (''SQL_USER'',''WINDOWS_USER'')
       AND sp.sid IS NULL',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
