/*
    certificates-asymmetric-keys.sql
    Certificates and asymmetric keys with usage.
*/

SELECT
    c.certificate_id        AS object_id,
    c.name                  AS object_name,
    'CERTIFICATE'           AS object_type,
    c.subject,
    c.start_date,
    c.expiry_date,
    c.thumbprint,
    c.pvt_key_encryption_type_desc,
    c.is_active_for_begin_dialog,
    c.is_active_for_database_encryption,
    sp.principal_id         AS owner_principal_id,
    sp.name                 AS owner_name,
    sp.type_desc            AS owner_type
FROM sys.certificates AS c
LEFT JOIN sys.database_principals AS sp
       ON c.principal_id = sp.principal_id
UNION ALL
SELECT
    ak.asymmetric_key_id    AS object_id,
    ak.name                 AS object_name,
    'ASYMMETRIC KEY'        AS object_type,
    NULL                    AS subject,
    ak.create_date          AS start_date,
    ak.modify_date          AS expiry_date,
    NULL                    AS thumbprint,
    ak.pvt_key_encryption_type_desc,
    NULL                    AS is_active_for_begin_dialog,
    NULL                    AS is_active_for_database_encryption,
    sp.principal_id         AS owner_principal_id,
    sp.name                 AS owner_name,
    sp.type_desc            AS owner_type
FROM sys.asymmetric_keys AS ak
LEFT JOIN sys.database_principals AS sp
       ON ak.principal_id = sp.principal_id;
