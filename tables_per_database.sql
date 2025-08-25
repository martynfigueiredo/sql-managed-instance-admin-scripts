CREATE TABLE #TableCounts (
    DatabaseName sysname,
    TableCount int
);

EXEC sp_MSforeachdb
'USE [?];
 INSERT INTO #TableCounts
 SELECT DB_NAME() AS DatabaseName, COUNT(*)
 FROM sys.tables
 WHERE type = ''U'';';

SELECT *
FROM #TableCounts
ORDER BY TableCount DESC, DatabaseName;

DROP TABLE #TableCounts;
