/*
    tde-status.sql
    Transparent Data Encryption status per database.
*/

SELECT
    d.database_id,
    d.name          AS database_name,
    d.state_desc,
    d.user_access_desc,
    d.recovery_model_desc,
    d.collation_name,
    d.is_encrypted,
    d.is_read_only,
    d.create_date,
    dm.encryption_state,
    dm.encryptor_type,
    dm.encryptor_thumbprint,
    dm.percent_complete,
    dm.key_algorithm,
    dm.key_length
FROM sys.databases AS d
LEFT JOIN sys.dm_database_encryption_keys AS dm
       ON d.database_id = dm.database_id
ORDER BY d.name;
