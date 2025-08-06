/*
    xp-cmdshell-usage.sql
    Searches for modules that reference xp_cmdshell with object metadata.

    Refs: CIS SQL Server 5.1
*/
SELECT
    o.object_id,
    OBJECT_SCHEMA_NAME(o.object_id) AS SchemaName,
    o.name AS ObjectName,
    o.type_desc AS ObjectType,
    o.create_date,
    o.modify_date,
    o.is_ms_shipped,
    m.uses_ansi_nulls,
    m.uses_quoted_identifier,
    m.definition
FROM sys.sql_modules AS m
JOIN sys.objects AS o
    ON m.object_id = o.object_id
WHERE m.definition LIKE '%xp_cmdshell%';
