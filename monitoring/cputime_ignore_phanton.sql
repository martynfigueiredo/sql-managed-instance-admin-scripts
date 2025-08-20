WITH DB_CPU_Stats AS
(
    SELECT CONVERT(int, pa.value) AS database_id,
           SUM(qs.total_worker_time / 1000) AS cpu_time_ms
    FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
    CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS pa
    WHERE pa.attribute = N'dbid'
    GROUP BY CONVERT(int, pa.value)
)
SELECT ROW_NUMBER() OVER (ORDER BY s.cpu_time_ms DESC) AS [CPU Rank],
       d.name AS [Database Name],
       s.database_id,
       s.cpu_time_ms AS [CPU Time (ms)],
       CAST( s.cpu_time_ms * 1.0
             / NULLIF(SUM(s.cpu_time_ms) OVER (), 0) * 100.0 AS DECIMAL(5,2)) AS [CPU Percent]
FROM DB_CPU_Stats AS s
JOIN sys.databases AS d
  ON d.database_id = s.database_id
WHERE d.database_id NOT IN (32767)           -- ResourceDB
  AND d.state_desc = 'ONLINE'
  AND d.is_distributor = 0 -- optional
ORDER BY [CPU Rank] OPTION (RECOMPILE);
