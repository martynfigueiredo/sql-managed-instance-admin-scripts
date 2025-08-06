/*
    databases-with-trustworthy-on.sql
    Reports databases where TRUSTWORTHY is enabled with additional metadata.

    Refs: CIS SQL Server 3.2
*/
SELECT
    name AS DatabaseName,
    database_id,
    containment_desc,
    state_desc,
    owner_sid,
    create_date,
    is_trustworthy_on,
    is_db_chaining_on,
    is_broker_enabled,
    user_access_desc,
    recovery_model_desc
FROM sys.databases
WHERE is_trustworthy_on = 1;
