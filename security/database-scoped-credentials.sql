/*
    database-scoped-credentials.sql
    Database scoped credentials and external users.
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
     FROM ' + QUOTENAME(name) + '.sys.database_scoped_credentials AS dsc
     LEFT JOIN ' + QUOTENAME(name) + '.sys.database_principals AS dp
            ON dsc.principal_id = dp.principal_id',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
