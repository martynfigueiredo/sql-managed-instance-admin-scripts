/*
    server-audit-specifications.sql
    Lists server audit specifications and their status with audited actions.

    Refs: PCI DSS 10.2
*/
SELECT
    sas.server_specification_id,
    sas.name AS SpecificationName,
    a.name AS AuditName,
    sas.is_state_enabled,
    sas.create_date,
    sas.modify_date,
    sad.audit_action_id,
    sad.audited_result
FROM sys.server_audit_specifications AS sas
JOIN sys.server_audits AS a
    ON sas.audit_guid = a.audit_guid
LEFT JOIN sys.server_audit_specification_details AS sad
    ON sas.server_specification_id = sad.server_specification_id;
