/*
    database-scoped-credentials.sql
    Database scoped credentials and external users.
*/

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       dsc.credential_id,
       dsc.name AS credential_name,
       dsc.identity_name,
       dsc.credential_identity,
       dsc.provider_name,
       dsc.target,
       dsc.create_date,
       dsc.modify_date,
       dsc.principal_id,
       dp.name AS principal_name,
       dp.type_desc AS principal_type
FROM [' + name + '].sys.database_scoped_credentials AS dsc
LEFT JOIN [' + name + '].sys.database_principals AS dp
       ON dsc.principal_id = dp.principal_id
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);
EXEC sys.sp_executesql @sql;
