/*
    backup-history-report.sql
    Returns a chronological list of backup events with useful details.

    Shows database name, backup start and finish times, duration, backup file, backup type, backup size and compressed size.
*/

SELECT
    bs.database_name           AS DatabaseName,
    bs.backup_start_date       AS BackupStart,
    bs.backup_finish_date      AS BackupFinish,
    DATEDIFF(MINUTE, bs.backup_start_date, bs.backup_finish_date) AS DurationMinutes,
    bmf.physical_device_name   AS BackupFile,
    CASE bs.[type]
         WHEN 'D' THEN 'Full Backup'
         WHEN 'I' THEN 'Differential Backup'
         WHEN 'L' THEN 'Log Backup'
         WHEN 'F' THEN 'File/Filegroup'
         WHEN 'G' THEN 'Differential File'
         WHEN 'P' THEN 'Partial'
         WHEN 'Q' THEN 'Differential Partial'
    END AS BackupType,
    ROUND(bs.backup_size / 1024.0 / 1024.0, 2)           AS BackupSizeMB,
    ROUND(bs.compressed_backup_size / 1024.0 / 1024.0, 2) AS CompressedSizeMB
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
-- Optional: filter by time period
-- WHERE bs.backup_finish_date >= DATEADD(day, -30, GETDATE())
ORDER BY bs.backup_start_date DESC;
