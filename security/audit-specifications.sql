/*
    audit-specifications.sql
    Server and database audit specifications.
*/

-- Server audits
SELECT
    sa.audit_id,
    sa.name               AS audit_name,
    sa.audit_guid,
    sa.audit_file_path,
    sa.audit_destination,
    sa.max_file_size,
    sa.max_rollover_files,
    sa.queue_delay,
    sa.on_failure,
    sa.is_state_enabled,
    sa.is_automated_process,
    sa.principal_id,
    sa.create_date,
    sa.modify_date
FROM sys.server_audits AS sa;

-- Database audits for each database
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql +
'SELECT ''' + name + ''' AS database_name,
       da.audit_specification_id,
       da.audit_specification_guid,
       da.name AS audit_spec_name,
       da.is_state_enabled,
       da.user_defined_predicate,
       da.principal_id,
       da.create_date,
       da.modify_date
FROM [' + name + '].sys.database_audit_specifications AS da
UNION ALL
'
FROM sys.databases
WHERE state_desc = ''ONLINE''
  AND database_id > 4;

SET @sql = LEFT(@sql, LEN(@sql)-LEN(''UNION ALL'')-2);
EXEC sys.sp_executesql @sql;
