/*
    check-auditing-status.sql
    Lists configured server audits with detailed information.

    Refs: PCI DSS 10.2, ISO 27001 A.12.4
*/
SELECT
    audit_guid,
    name AS AuditName,
    type_desc,
    on_failure_desc,
    is_state_enabled,
    queue_delay,
    audit_file_path,
    predicate,
    create_date,
    modify_date
FROM sys.server_audits;
