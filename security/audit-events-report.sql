/*
    audit-events-report.sql
    Recent audit events (works with file audits). Adjust path as needed.
*/

SELECT
    event_time,
    sequence_number,
    action_id,
    succeeded,
    server_instance_name,
    server_principal_name,
    server_principal_sid,
    database_principal_name,
    database_principal_id,
    target_server_principal_name,
    target_server_principal_sid,
    target_database_principal_name,
    target_database_principal_id,
    object_name,
    object_id,
    class_type,
    session_id,
    application_name,
    host_name,
    client_ip,
    client_connection_id,
    statement,
    additional_information
FROM sys.fn_get_audit_file('PATH_TO_AUDIT_FILES\\*.sqlaudit', DEFAULT, DEFAULT)
ORDER BY event_time DESC;
