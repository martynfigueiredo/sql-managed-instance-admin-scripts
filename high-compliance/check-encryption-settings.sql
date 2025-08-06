/* Enable TDE & SSL. Refs: CIS SQL Server, PCI DSS 4.0, ISO 27001 A.10.1 */
SELECT
    Issue,
    DatabaseName,
    IsEncrypted,
    EncryptionState,
    SessionId,
    LoginName,
    ClientNetAddress,
    NetTransport,
    EncryptOption
FROM (
    SELECT
        'NO_TDE' AS Issue,
        d.name AS DatabaseName,
        d.is_encrypted AS IsEncrypted,
        dek.encryption_state AS EncryptionState,
        NULL AS SessionId,
        NULL AS LoginName,
        NULL AS ClientNetAddress,
        NULL AS NetTransport,
        NULL AS EncryptOption
    FROM sys.databases AS d
    LEFT JOIN sys.dm_database_encryption_keys AS dek
        ON d.database_id = dek.database_id
    WHERE d.is_encrypted = 0

    UNION ALL

    SELECT
        'NON_SSL' AS Issue,
        DB_NAME(s.database_id) AS DatabaseName,
        NULL AS IsEncrypted,
        NULL AS EncryptionState,
        c.session_id AS SessionId,
        s.login_name AS LoginName,
        c.client_net_address AS ClientNetAddress,
        c.net_transport AS NetTransport,
        c.encrypt_option AS EncryptOption
    FROM sys.dm_exec_connections AS c
    JOIN sys.dm_exec_sessions AS s
        ON c.session_id = s.session_id
    WHERE c.encrypt_option <> 'TRUE'
) AS findings
ORDER BY Issue, DatabaseName, SessionId;
