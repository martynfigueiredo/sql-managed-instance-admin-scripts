/*
    check-deprecated-settings.sql
    Identifies configuration options that may violate compliance policies.

    Refs: CIS SQL Server, PCI DSS 4.0, ISO 27001.

    Recommended values appear in the query output; change with
    EXEC sp_configure '<option>', <value>; RECONFIGURE;
*/

WITH ConfigRecommendations AS (
    SELECT 'xp_cmdshell' AS name, 0 AS RecommendedValue,
        'Blocks OS command execution.' AS ComplianceRationale,
        'CIS 2.1' AS ComplianceReference
    UNION ALL SELECT 'Ad Hoc Distributed Queries', 0,
        'Blocks unvetted remote data access.', 'CIS 2.2'
    UNION ALL SELECT 'remote login timeout', 20,
        'Use default to bound remote login attempts.', 'CIS 2.3'
    UNION ALL SELECT 'Ole Automation Procedures', 0,
        'Blocks OLE automation.', 'CIS 2.4'
    UNION ALL SELECT 'SQL Mail XPs', 0,
        'Removes deprecated SQL Mail.', 'CIS 2.5'
    UNION ALL SELECT 'Database Mail XPs', 0,
        'Only if Database Mail needed.', 'CIS 2.6'
    UNION ALL SELECT 'Agent XPs', 0,
        'Only if SQL Agent needed.', 'CIS 2.7'
    UNION ALL SELECT 'cross db ownership chaining', 0,
        'Prevents cross-database escalation.', 'CIS 2.8'
    UNION ALL SELECT 'remote access', 0,
        'Blocks remote procedure calls.', 'CIS 2.9'
    UNION ALL SELECT 'clr enabled', 0,
        'Prevents CLR execution.', 'CIS 2.10'
    UNION ALL SELECT 'external scripts enabled', 0,
        'Blocks external R/Python scripts.', 'CIS 2.11'
    UNION ALL SELECT 'remote admin connections', 0,
        'Restricts DAC to local machine.', 'CIS 2.12'
    UNION ALL SELECT 'scan for startup procs', 0,
        'Prevents automatic proc execution.', 'CIS 2.13'
    UNION ALL SELECT 'SMO and DMO XPs', 0,
        'Disables legacy management interfaces.', 'CIS 2.14'
    UNION ALL SELECT 'allow updates', 0,
        'Prevents direct system table writes.', 'CIS 2.15'
    UNION ALL SELECT 'filestream access level', 0,
        'Disables FILESTREAM feature.', 'CIS 2.16'
    UNION ALL SELECT 'contained database authentication', 0,
        'Blocks partially contained databases.', 'CIS 2.17'
    UNION ALL SELECT 'c2 audit mode', 0,
        'Deprecated C2 auditing.', 'CIS 2.18'
    UNION ALL SELECT 'common criteria compliance enabled', 0,
        'Avoids performance hit unless required.', 'CIS 2.19'
    UNION ALL SELECT 'default trace enabled', 1,
        'Captures basic audit trail.', 'CIS 2.20'
    UNION ALL SELECT 'remote proc trans', 0,
        'Prevents DTC promotion.', 'CIS 2.21'
    UNION ALL SELECT 'Replication XPs', 0,
        'Disable replication if unused.', 'CIS 2.22'
    UNION ALL SELECT 'Web Assistant Procedures', 0,
        'Removes obsolete web features.', 'CIS 2.23'
    UNION ALL SELECT 'show advanced options', 0,
        'Hides advanced options.', 'CIS 2.24'
    UNION ALL SELECT 'lightweight pooling', 0,
        'Avoids fiber mode.', 'CIS 2.25'
    UNION ALL SELECT 'priority boost', 0,
        'Prevents CPU priority issues.', 'CIS 2.26'
    UNION ALL SELECT 'remote query timeout (s)', 600,
        'Bounds remote query execution.', 'CIS 2.27'
    UNION ALL SELECT 'disallow results from triggers', 1,
        'Forces triggers to not return data.', 'CIS 2.28'
    UNION ALL SELECT 'clr strict security', 1,
        'Requires signed CLR assemblies.', 'CIS 2.29'
    UNION ALL SELECT 'user connections', 0,
        'Use default unlimited.', 'CIS 2.30'
    UNION ALL SELECT 'cursor close on commit', 1,
        'Releases cursor resources promptly.', 'CIS 2.31'
    UNION ALL SELECT 'optimize for ad hoc workloads', 1,
        'Reduces plan cache bloat.', 'CIS 2.32'
)
SELECT
    c.name AS ConfigurationName,
    c.value_in_use AS CurrentValue,
    r.RecommendedValue,
    r.ComplianceRationale,
    r.ComplianceReference
FROM sys.configurations AS c
JOIN ConfigRecommendations AS r
    ON c.name = r.name
ORDER BY c.name;
