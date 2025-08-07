/*
    server-credentials.sql
    Server-level credentials.
*/

SELECT
    credential_id,
    name           AS credential_name,
    credential_identity,
    target,
    target_id,
    target_type,
    create_date,
    modify_date
FROM sys.credentials
ORDER BY name;
