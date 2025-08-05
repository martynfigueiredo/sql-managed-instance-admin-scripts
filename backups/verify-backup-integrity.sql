/*
    verify-backup-integrity.sql
    For each user database, show the most recent full backup and its details.

*/

SELECT 
    db.name AS DatabaseName,
    bs_full.backup_finish_date       AS LastFullBackupDate,
    bmf_full.physical_device_name    AS BackupFile,
    CAST(ROUND(bs_full.backup_size / 1024.0 / 1024.0, 2) AS DECIMAL(18,2))           AS BackupSizeMB,
    CAST(ROUND(bs_full.compressed_backup_size / 1024.0 / 1024.0, 2) AS DECIMAL(18,2)) AS CompressedSizeMB
FROM sys.databases AS db
OUTER APPLY (
    SELECT TOP 1 backup_finish_date, backup_size, compressed_backup_size, media_set_id
    FROM msdb.dbo.backupset
    WHERE database_name = db.name AND type = 'D' AND is_copy_only = 0
    ORDER BY backup_finish_date DESC
) AS bs_full
OUTER APPLY (
    SELECT TOP 1 physical_device_name
    FROM msdb.dbo.backupmediafamily
    WHERE media_set_id = bs_full.media_set_id
) AS bmf_full
WHERE db.database_id > 4
ORDER BY db.name;
