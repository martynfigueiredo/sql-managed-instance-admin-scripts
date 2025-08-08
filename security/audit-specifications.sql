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
