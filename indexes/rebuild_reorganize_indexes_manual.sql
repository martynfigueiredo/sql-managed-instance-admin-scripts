USE [ADVENTUREWORKS2022]
GO

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName
	,ind.name AS IndexName
	,indexstats.index_type_desc AS IndexType
	,indexstats.avg_fragmentation_in_percent
	,
	'ALTER INDEX ' + QUOTENAME(ind.name) + ' ON ' + QUOTENAME(OBJECT_SCHEMA_NAME(ind.OBJECT_ID)) + '.' + QUOTENAME(OBJECT_NAME(ind.OBJECT_ID)) + CASE 
		WHEN indexstats.avg_fragmentation_in_percent > 30
			THEN ' REBUILD '
		WHEN indexstats.avg_fragmentation_in_percent >= 5
			THEN ' REORGANIZE '
		ELSE NULL
		END AS [SQLQuery]
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') AS indexstats
INNER JOIN sys.indexes AS ind ON ind.object_id = indexstats.object_id
	AND ind.index_id = indexstats.index_id
WHERE ind.name IS NOT NULL
ORDER BY indexstats.avg_fragmentation_in_percent DESC;
