/*
    row-level-security-policies.sql
    Row-level security policies and predicate functions.
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
            sp.object_id AS policy_object_id,
            sp.name AS policy_name,
            sp.schema_id,
            sch.name AS schema_name,
            sp.is_enabled,
            sp.is_schema_bound,
            sp.create_date,
            sp.modify_date,
            p.security_predicate_id,
            p.type_desc AS predicate_type,
            p.operation_desc,
            p.predicate_definition,
            p.target_object_id,
            OBJECT_SCHEMA_NAME(p.target_object_id, DB_ID(''' + name + ''')) AS target_schema,
            OBJECT_NAME(p.target_object_id, DB_ID(''' + name + ''')) AS target_table,
            p.filter_column_id
     FROM ' + QUOTENAME(name) + '.sys.security_policies AS sp
     JOIN ' + QUOTENAME(name) + '.sys.schemas AS sch
          ON sp.schema_id = sch.schema_id
     JOIN ' + QUOTENAME(name) + '.sys.security_predicates AS p
          ON sp.object_id = p.object_id',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
