/*
    verify-backup-integrity.sql
    For each database, locate the most recent full backup and run RESTORE VERIFYONLY
    to confirm that the backup is readable.

    Optionally, use Ola Hallengren's DatabaseBackup stored procedure with @Verify='Y'
    and @LogToTable='Y' to automate verification and logging.
*/

DECLARE @dbName SYSNAME;
DECLARE db_cursor CURSOR FOR
    SELECT name FROM sys.databases WHERE database_id > 4; -- Skip system databases

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @dbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @backupFile NVARCHAR(260);

    SELECT TOP 1 @backupFile = bmf.physical_device_name
    FROM msdb.dbo.backupset bs
    JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
    WHERE bs.database_name = @dbName
          AND bs.type = 'D'
          AND bs.is_copy_only = 0
    ORDER BY bs.backup_finish_date DESC;

    IF @backupFile IS NOT NULL
    BEGIN
        DECLARE @sql NVARCHAR(4000) = N'RESTORE VERIFYONLY FROM DISK = ''' + @backupFile + ''';';
        EXEC(@sql);
    END;

    -- To use Ola Hallengren's solution instead, uncomment and configure:
    /*
    EXEC dbo.DatabaseBackup
         @Databases    = @dbName,
         @Directory    = 'C:\Backup',
         @BackupType   = 'FULL',
         @Verify       = 'Y',
         @LogToTable   = 'Y';
    */

    FETCH NEXT FROM db_cursor INTO @dbName;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;
