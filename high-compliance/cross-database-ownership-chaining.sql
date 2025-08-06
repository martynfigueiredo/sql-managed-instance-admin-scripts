/*
    cross-database-ownership-chaining.sql
    Identifies databases with cross-database ownership chaining enabled.

    Refs: CIS SQL Server 3.3
*/
SELECT
    name AS DatabaseName,
    database_id,
    containment_desc,
    state_desc,
    owner_sid,
    create_date,
    is_db_chaining_on,
    is_trustworthy_on,
    is_broker_enabled,
    user_access_desc,
    recovery_model_desc
FROM sys.databases
WHERE is_db_chaining_on = 1;
