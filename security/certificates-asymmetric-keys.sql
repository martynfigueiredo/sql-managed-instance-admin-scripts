/*
    certificates-asymmetric-keys.sql
    Certificates and asymmetric keys with usage.
*/


SELECT
    c.certificate_id        AS ObjectId,
    c.name                  AS ObjectName,
    'CERTIFICATE'           AS ObjectType,
    c.subject,
    c.start_date,
    c.expiry_date,
    c.thumbprint,
    c.pvt_key_encryption_type_desc,
    c.is_active_for_begin_dialog,
    sp.principal_id         AS OwnerPrincipalId,
    sp.name                 AS OwnerName,
    sp.type_desc            AS OwnerType
FROM sys.certificates AS c
LEFT JOIN sys.database_principals AS sp
    ON c.principal_id = sp.principal_id

UNION ALL

SELECT
    ak.asymmetric_key_id    AS ObjectId,
    ak.name                 AS ObjectName,
    'ASYMMETRIC KEY'        AS ObjectType,
    NULL                    AS Subject,
    NULL                    AS StartDate,
    NULL                    AS ExpiryDate,
    NULL                    AS Thumbprint,
    ak.pvt_key_encryption_type_desc,
    NULL                    AS IsActiveForBeginDialog,
    sp.principal_id         AS OwnerPrincipalId,
    sp.name                 AS OwnerName,
    sp.type_desc            AS OwnerType
FROM sys.asymmetric_keys AS ak
LEFT JOIN sys.database_principals AS sp
    ON ak.principal_id = sp.principal_id;
