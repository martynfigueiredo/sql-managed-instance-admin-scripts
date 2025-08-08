/*
    dynamic-data-masking.sql
    Reports dynamic data masking rules.
*/


DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       t.name AS table_name,
       c.name AS column_name,
       c.column_id,
       TYPE_NAME(c.user_type_id) AS data_type,
       c.max_length,
       c.collation_name,
       c.is_nullable,
       mc.masking_function,
       mc.is_masked,
       mc.ordinal,
       f.masking_function AS masking_function_name,
       f.definition
FROM [' + name + '].sys.masked_columns AS mc
JOIN [' + name + '].sys.tables AS t
     ON mc.object_id = t.object_id
JOIN [' + name + '].sys.columns AS c
     ON mc.column_id = c.column_id
    AND mc.object_id = c.object_id
LEFT JOIN [' + name + '].sys.masking_functions AS f
     ON mc.masking_function_id = f.masking_function_id
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);
EXEC sys.sp_executesql @sql;
