/*
    backup-log-delay-report.sql
    Shows time elapsed since the last log backup for each user database and classifies status.
*/

SELECT
    db.name AS DatabaseName,
    MAX(bs.backup_finish_date) AS LastLogBackup,
    DATEDIFF(MINUTE, MAX(bs.backup_finish_date), GETDATE()) AS MinutesSinceLastLog,
    CASE
        WHEN MAX(bs.backup_finish_date) IS NULL THEN 'Never'
        WHEN DATEDIFF(MINUTE, MAX(bs.backup_finish_date), GETDATE()) > 60 THEN 'Delayed'
        ELSE 'On schedule'
    END AS LogBackupStatus
FROM sys.databases db
LEFT JOIN msdb.dbo.backupset bs
    ON bs.database_name = db.name
    AND bs.type = 'L'
    AND bs.is_copy_only = 0
WHERE db.database_id > 4
GROUP BY db.name
ORDER BY MinutesSinceLastLog DESC;
