/*
    procedures-with-execute-as.sql
    Lists stored procedures that use EXECUTE AS, including impersonation details,
    metadata, and potential risk indicators such as 'EXECUTE AS OWNER'.

    Refs: CIS SQL Server 5.2
*/

SELECT
    o.object_id,
    o.schema_id,
    s.name AS SchemaName,
    o.name AS ProcedureName,
    o.type_desc AS ObjectType,
    dp.name AS ExecuteAsPrincipal,
    dp.type_desc AS PrincipalType,
    o.create_date,
    o.modify_date,
    o.is_ms_shipped,
    m.uses_ansi_nulls,
    m.uses_quoted_identifier,
    m.execute_as_principal_id,
    CASE 
        WHEN m.definition LIKE '%EXECUTE AS OWNER%' THEN 'Yes'
        ELSE 'No'
    END AS IsExecuteAsOwner,
    m.definition AS ProcedureDefinition,
    perm.permission_name AS ExamplePermission
FROM sys.objects AS o
INNER JOIN sys.sql_modules AS m
    ON o.object_id = m.object_id
LEFT JOIN sys.schemas AS s
    ON o.schema_id = s.schema_id
LEFT JOIN sys.database_principals AS dp
    ON m.execute_as_principal_id = dp.principal_id
OUTER APPLY (
    SELECT TOP 1 permission_name
    FROM sys.database_permissions perm
    WHERE perm.major_id = o.object_id
) AS perm
WHERE o.type = 'P' -- Only stored procedures
  AND m.execute_as_principal_id IS NOT NULL
  AND o.is_ms_shipped = 0
ORDER BY 
    SchemaName,
    ProcedureName;
