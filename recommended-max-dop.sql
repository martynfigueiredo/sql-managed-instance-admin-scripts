/*

select * from sys.database_scoped_configurations where name ='MAXDOP'


--ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 4;
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
reconfigure


sp_whoisactive


EXEC sys.sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sys.sp_configure 'max degree of parallelism', 4;
RECONFIGURE;  -- persists

*/


/* MAXDOP recommendation based on Microsoft guidance */
WITH sched AS (
    SELECT parent_node_id,
           COUNT(*) AS online_schedulers
    FROM sys.dm_os_schedulers
    WHERE status = 'VISIBLE ONLINE'
      AND is_online = 1
      AND scheduler_id < 255 -- ignore DAC/hidden
    GROUP BY parent_node_id
),
agg AS (
    SELECT COUNT(*) AS numa_nodes,
           MAX(online_schedulers) AS max_per_node,
           SUM(online_schedulers) AS total_online
    FROM sched
)
SELECT 
    a.numa_nodes,
    a.max_per_node AS logical_per_numa_node,
    a.total_online  AS total_logical_online,
    CASE 
        WHEN a.numa_nodes = 1 THEN
            CASE WHEN a.max_per_node <= 8 THEN a.max_per_node ELSE 8 END
        ELSE
            CASE 
                WHEN a.max_per_node <= 8 THEN a.max_per_node
                ELSE IIF(CEILING(a.max_per_node/2.0) > 16, 16, CEILING(a.max_per_node/2.0))
            END
    END AS recommended_MAXDOP
FROM agg a;
