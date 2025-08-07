/*
    linked-servers-security.sql
    Linked servers with security details.
*/

SELECT
    ls.server_id,
    ls.name            AS linked_server_name,
    ls.product,
    ls.provider,
    ls.data_source,
    ls.location,
    ls.catalog,
    ls.is_collation_compatible,
    ls.uses_remote_collation,
    ls.is_data_access_enabled,
    ls.is_rpc_out_enabled,
    ls.is_rpc_enabled,
    ls.is_remote_login_enabled,
    ls.connect_timeout,
    ls.query_timeout,
    ls.modify_date,
    ssp.local_principal_id,
    sp.name            AS local_principal_name,
    ssp.credential_id,
    ssp.uses_self_credential,
    ssp.remote_name,
    ssp.modify_date    AS login_modify_date
FROM sys.servers AS ls
LEFT JOIN sys.linked_logins AS ssp
       ON ls.server_id = ssp.server_id
LEFT JOIN sys.server_principals AS sp
       ON ssp.local_principal_id = sp.principal_id
WHERE ls.is_linked = 1
ORDER BY ls.name;
