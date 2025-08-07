/*
    db-trustworthy-ownership-chain.sql
    Database trustworthy and ownership chain info.
*/

SELECT
    d.database_id,
    d.name           AS database_name,
    d.state_desc,
    d.user_access_desc,
    d.containment_desc,
    d.recovery_model_desc,
    d.collation_name,
    d.owner_sid,
    sp.name          AS owner_name,
    d.trustworthy,
    d.is_db_chaining_on,
    d.is_encrypted,
    d.is_read_only,
    d.log_reuse_wait_desc,
    d.create_date,
    d.modify_date
FROM sys.databases AS d
LEFT JOIN sys.server_principals AS sp
       ON d.owner_sid = sp.sid
ORDER BY d.name;
