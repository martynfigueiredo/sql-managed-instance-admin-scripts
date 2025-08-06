/*
    get-deprecated-data-types.sql
    Shows deprecated data types in SQL Server and the recommended replacement.

    OBS.: Type in database name in the first line instead of [AdventureWorks2025]
*/

USE [AdventureWorks2025]
GO
SELECT 
    DB_NAME() AS DatabaseName,
    sch.name AS OwnerSchema,
    tbl.name AS TableName,
    col.name AS ColumnName,
    typ.name + 
        CASE 
            WHEN typ.name IN ('decimal', 'numeric') 
                THEN '(' + CAST(col.precision AS nvarchar) + ', ' + CAST(col.scale AS nvarchar) + ')'
            WHEN typ.name IN ('varchar', 'nvarchar', 'char', 'nchar') 
                THEN '(' + CASE WHEN col.max_length < 0 THEN 'max' ELSE CAST(col.max_length AS nvarchar) END + ')'
            WHEN typ.name IN ('time', 'datetime2', 'datetimeoffset') 
                THEN '(' + CAST(col.scale AS nvarchar) + ')'
            ELSE ''
        END AS FullDataType,
    CASE typ.name
        WHEN 'image' THEN 'varbinary(max)'
        WHEN 'text' THEN 'varchar(max)'
        WHEN 'ntext' THEN 'nvarchar(max)'
        WHEN 'timestamp' THEN 'rowversion'
        WHEN 'sql_variant' THEN 'Consider redesign'
    END AS RecommendedType
FROM sys.tables AS tbl
JOIN sys.schemas AS sch ON tbl.schema_id = sch.schema_id
JOIN sys.columns AS col ON tbl.object_id = col.object_id
JOIN sys.types AS typ ON col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
WHERE tbl.type = 'U'
  AND typ.name IN ('image', 'text', 'ntext', 'timestamp', 'sql_variant')
ORDER BY OwnerSchema, TableName, col.column_id;

