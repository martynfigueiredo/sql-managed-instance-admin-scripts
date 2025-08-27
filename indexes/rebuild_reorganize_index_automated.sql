USE [ADVENTUREWORKS2022]
GO

DECLARE 
  @reorg_low   float = 5.0,      -- >=5% consider REORGANIZE
  @rebuild_high float = 30.0,    -- >=30% REBUILD
  @min_pages    int   = 1000,    -- skip tiny indexes
  @online       bit   = 1,       -- set 0 if ONLINE not supported
  @maxdop       int   = 2;

DECLARE @sql nvarchar(max) = N'';

;WITH ips AS (
  SELECT 
    ips.object_id, ips.index_id, ips.avg_fragmentation_in_percent, ips.page_count
  FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') AS ips
  WHERE ips.index_id > 0                 -- ignore heaps
    AND ips.alloc_unit_type_desc = 'IN_ROW_DATA'
), tgt AS (
  SELECT 
    o.[schema_id], o.[name] AS table_name, i.[name] AS index_name,
    i.[type] AS index_type, i.is_disabled, i.is_hypothetical,
    ips.avg_fragmentation_in_percent AS frag, ips.page_count,
    QUOTENAME(SCHEMA_NAME(o.schema_id)) + '.' + QUOTENAME(o.name) AS full_table,
    QUOTENAME(i.name) AS q_index
  FROM ips
  JOIN sys.indexes  AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
  JOIN sys.objects  AS o ON o.object_id   = i.object_id
  WHERE o.[type] = 'U'
    AND i.[type] IN (1,2)        -- 1=clustered rowstore, 2=nonclustered rowstore
    AND i.is_disabled = 0 AND i.is_hypothetical = 0
    AND ips.page_count >= @min_pages
)
SELECT @sql = @sql + 
  CASE WHEN frag >= @rebuild_high THEN
    N'PRINT ''REBUILD: ' + full_table + N' - ' + q_index + N' (' + CONVERT(varchar(10),CAST(frag AS int)) + N'% , ' + CONVERT(varchar(20),page_count) + N' pages)'';' + CHAR(13) +
    N'ALTER INDEX ' + q_index + N' ON ' + full_table + N' REBUILD WITH ('
      + N'ONLINE = ' + CASE WHEN @online=1 THEN N'ON' ELSE N'OFF' END + N', '
      + N'SORT_IN_TEMPDB = ON, '
      + N'MAXDOP = ' + CAST(@maxdop AS nvarchar(10)) + N');' + CHAR(13) + CHAR(13)
  ELSE
    N'PRINT ''REORGANIZE: ' + full_table + N' - ' + q_index + N' (' + CONVERT(varchar(10),CAST(frag AS int)) + N'% , ' + CONVERT(varchar(20),page_count) + N' pages)'';' + CHAR(13) +
    N'ALTER INDEX ' + q_index + N' ON ' + full_table + N' REORGANIZE WITH (LOB_COMPACTION = ON);' + CHAR(13) + CHAR(13)
  END
FROM tgt
ORDER BY page_count DESC;

EXEC sp_executesql @sql;
