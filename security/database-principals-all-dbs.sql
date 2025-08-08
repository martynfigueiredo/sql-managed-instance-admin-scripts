/*
    database-principals-all-dbs.sql
    Database principals for all online databases.
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
     FROM ' + QUOTENAME(name) + '.sys.database_principals AS dp
     WHERE dp.type NOT IN (''A'',''G'',''R'',''X'')',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
