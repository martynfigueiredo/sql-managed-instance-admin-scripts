/*
    procedures-with-execute-as-owner.sql
    Lists stored procedures that use EXECUTE AS owner with procedure metadata.

    Refs: CIS SQL Server 5.2
*/
SELECT
    p.object_id,
    OBJECT_SCHEMA_NAME(p.object_id) AS SchemaName,
    p.name AS ProcedureName,
    dp.name AS ExecuteAs,
    p.create_date,
    p.modify_date,
    p.is_ms_shipped,
    p.uses_ansi_nulls,
    p.uses_quoted_identifier
FROM sys.procedures AS p
JOIN sys.database_principals AS dp
    ON p.execute_as_principal_id = dp.principal_id
WHERE p.execute_as_principal_id IS NOT NULL;
