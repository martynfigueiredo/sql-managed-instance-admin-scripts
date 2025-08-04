/*
    check-backup-status.sql
    Returns the last backup times for each database in the instance.

    This script shows the most recent Full, Differential, and Log backup dates for each database.
    It can help DBAs quickly identify databases that may not be backed up regularly.
*/

SELECT
    db.name AS DatabaseName,
    MAX(CASE WHEN bs.type = 'D' THEN bs.backup_finish_date END) AS LastFullBackup,
    MAX(CASE WHEN bs.type = 'I' THEN bs.backup_finish_date END) AS LastDifferentialBackup,
    MAX(CASE WHEN bs.type = 'L' THEN bs.backup_finish_date END) AS LastLogBackup,
    DATEDIFF(day, MAX(CASE WHEN bs.type = 'D' THEN bs.backup_finish_date END), GETDATE()) AS DaysSinceFullBackup
FROM sys.databases AS db
LEFT JOIN msdb.dbo.backupset AS bs
    ON bs.database_name = db.name
    AND bs.type IN ('D','I','L')
    AND bs.is_copy_only = 0
GROUP BY db.name
ORDER BY db.name;
