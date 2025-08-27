-- List top missing index recommendations
SELECT TOP 10
    DB_NAME(mid.database_id) AS DatabaseName,
    OBJECT_SCHEMA_NAME(mid.object_id, mid.database_id) AS SchemaName,
    OBJECT_NAME(mid.object_id, mid.database_id) AS TableName,
    ISNULL(mid.equality_columns,'') AS EqualityColumns,
    ISNULL(mid.inequality_columns,'') AS InequalityColumns,
    ISNULL(mid.included_columns,'') AS IncludedColumns,
    migs.user_seeks,
    migs.user_scans,
    CONVERT(decimal(28,1),
        migs.avg_total_user_cost * (migs.avg_user_impact/100.0) 
        * (migs.user_seeks + migs.user_scans)
    ) AS ImprovementMeasure
FROM sys.dm_db_missing_index_groups AS mig
JOIN sys.dm_db_missing_index_group_stats AS migs 
    ON mig.index_group_handle = migs.group_handle
JOIN sys.dm_db_missing_index_details AS mid 
    ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
ORDER BY ImprovementMeasure DESC;
