/*
    backup-history-report.sql
    Returns a detailed chronological list of backup events.

*/

SELECT
    bs.database_name         AS DatabaseName,
    bs.server_name           AS ServerName,
    bs.backup_start_date     AS BackupStart,
    bs.backup_finish_date    AS BackupFinish,
    DATEDIFF(MILLISECOND, bs.backup_start_date, bs.backup_finish_date) AS DurationMilliseconds,
    bmf.physical_device_name AS BackupFile,
    CASE bs.[type]
         WHEN 'D' THEN 'Full Backup'
         WHEN 'I' THEN 'Differential Backup'
         WHEN 'L' THEN 'Log Backup'
         WHEN 'F' THEN 'File/Filegroup'
         WHEN 'G' THEN 'Differential File'
         WHEN 'P' THEN 'Partial'
         WHEN 'Q' THEN 'Differential Partial'
    END                       AS BackupType,
    CAST(ROUND(bs.backup_size / 1024.0 / 1024.0, 2) AS DECIMAL(18,2))           AS BackupSizeMB,
    CAST(ROUND(bs.compressed_backup_size / 1024.0 / 1024.0, 2) AS DECIMAL(18,2)) AS CompressedSizeMB,
    bs.user_name             AS BackupUser,
    bs.is_copy_only          AS IsCopyOnly
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
-- Optionally filter to recent history, e.g. last 30 days:
--WHERE bs.backup_finish_date >= DATEADD(day, -30, GETDATE())
ORDER BY bs.backup_start_date DESC;
