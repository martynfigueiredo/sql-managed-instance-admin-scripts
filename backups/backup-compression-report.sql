/*
    backup-compression-report.sql
    Shows backup size, compressed size and compression ratio for recent backups.
*/

SELECT
    bs.database_name AS DatabaseName,
    bs.backup_finish_date AS BackupFinish,
    CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(18,2)) AS BackupSizeMB,
    CAST(bs.compressed_backup_size / 1024.0 / 1024.0 AS DECIMAL(18,2)) AS CompressedSizeMB,
    CAST((1 - (bs.compressed_backup_size * 1.0 / bs.backup_size)) * 100 AS DECIMAL(5,2)) AS CompressionRatioPercent,
    CASE bs.[type]
         WHEN 'D' THEN 'Full'
         WHEN 'I' THEN 'Differential'
         WHEN 'L' THEN 'Log'
         ELSE bs.[type]
    END AS BackupType
FROM msdb.dbo.backupset bs
WHERE bs.backup_finish_date >= DATEADD(day, -30, GETDATE())
ORDER BY bs.backup_finish_date DESC;
