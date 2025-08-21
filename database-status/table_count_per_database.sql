-- Count tables per database

CREATE TABLE #Results (
    DatabaseName SYSNAME,
    TableCount INT
);

DECLARE @db SYSNAME;
DECLARE @sql NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'
  AND database_id > 4; -- ignora master, model, msdb, tempdb

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @db;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'
        INSERT INTO #Results (DatabaseName, TableCount)
        SELECT N''' + @db + ''', COUNT(*)
        FROM ' + QUOTENAME(@db) + N'.sys.tables;
    ';
    EXEC (@sql);

    FETCH NEXT FROM db_cursor INTO @db;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

SELECT * FROM #Results ORDER BY TableCount DESC;
DROP TABLE #Results;

