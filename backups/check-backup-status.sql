/*
    check-backup-status.sql
    Returns a comprehensive backup status report for each database in the instance.

    For each database this report provides:
    - Recovery model and database state.
    - Last Full, Differential and Log backup dates (excluding copy-only backups).
    - Last backup file path and size for each backup type.
    - Days since the last Full backup.
    This information helps administrators ensure that backup policies are being adhered to and quickly identify any databases with stale or missing backups.
*/

SELECT 
    db.name AS DatabaseName,
    db.recovery_model_desc AS RecoveryModel,
    db.state_desc AS DatabaseState,

    -- Last full backup details
    bs_full.backup_finish_date AS LastFullBackup,
    bm_full.physical_device_name AS FullBackupFile,
    CAST(bs_full.backup_size / 1024.0 / 1024.0 AS DECIMAL(18,2)) AS FullBackupSizeMB,

    -- Last differential backup details
    bs_diff.backup_finish_date AS LastDifferentialBackup,
    bm_diff.physical_device_name AS DifferentialBackupFile,
    CAST(bs_diff.backup_size / 1024.0 / 1024.0 AS DECIMAL(18,2)) AS DifferentialBackupSizeMB,

    -- Last log backup details
    bs_log.backup_finish_date AS LastLogBackup,
    bm_log.physical_device_name AS LogBackupFile,
    CAST(bs_log.backup_size / 1024.0 / 1024.0 AS DECIMAL(18,2)) AS LogBackupSizeMB,

    -- Days since last full backup
    DATEDIFF(day, bs_full.backup_finish_date, GETDATE()) AS DaysSinceFullBackup

FROM sys.databases AS db

-- Last full backup
OUTER APPLY (
    SELECT TOP 1 backup_finish_date, backup_size, media_set_id
    FROM msdb.dbo.backupset 
    WHERE database_name = db.name AND type = 'D' AND is_copy_only = 0
    ORDER BY backup_finish_date DESC
) AS bs_full

OUTER APPLY (
    SELECT TOP 1 physical_device_name
    FROM msdb.dbo.backupmediafamily
    WHERE media_set_id = bs_full.media_set_id
) AS bm_full

-- Last differential backup
OUTER APPLY (
    SELECT TOP 1 backup_finish_date, backup_size, media_set_id
    FROM msdb.dbo.backupset 
    WHERE database_name = db.name AND type = 'I' AND is_copy_only = 0
    ORDER BY backup_finish_date DESC
) AS bs_diff

OUTER APPLY (
    SELECT TOP 1 physical_device_name
    FROM msdb.dbo.backupmediafamily
    WHERE media_set_id = bs_diff.media_set_id
) AS bm_diff

-- Last log backup
OUTER APPLY (
    SELECT TOP 1 backup_finish_date, backup_size, media_set_id
    FROM msdb.dbo.backupset 
    WHERE database_name = db.name AND type = 'L' AND is_copy_only = 0
    ORDER BY backup_finish_date DESC
) AS bs_log

OUTER APPLY (
    SELECT TOP 1 physical_device_name
    FROM msdb.dbo.backupmediafamily
    WHERE media_set_id = bs_log.media_set_id
) AS bm_log

WHERE db.database_id > 4 -- Skip system databases like master, model, msdb, tempdb
ORDER BY db.name;
