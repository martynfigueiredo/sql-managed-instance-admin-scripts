1) Prereq: make sure Query Store is on (per DB)
ALTER DATABASE [YourDB] SET QUERY_STORE = ON;
ALTER DATABASE [YourDB]
  SET QUERY_STORE (OPERATION_MODE = READ_WRITE, DATA_FLUSH_INTERVAL_SECONDS = 60);

2) Turn on Automatic Tuning for this database only
ALTER DATABASE [YourDB]
  SET AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = ON );


To turn it off just for this DB:

ALTER DATABASE [YourDB]
  SET AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = OFF );


To inherit whatever the instance policy is (if set):

ALTER DATABASE [YourDB]
  SET AUTOMATIC_TUNING ( FORCE_LAST_GOOD_PLAN = DEFAULT );

3) Verify status (per DB)
SELECT name, desired_state_desc, actual_state_desc, reason_desc
FROM sys.database_automatic_tuning_options
WHERE name = 'FORCE_LAST_GOOD_PLAN';

4) See what it’s doing (recommendations / actions)
-- Current/Recent tuning recommendations for this DB
SELECT reason, score, state, details, implemented_plan_id, last_refresh
FROM sys.dm_db_tuning_recommendations;

-- (Optional) Query Store forced plans still apply alongside Automatic Tuning
SELECT qsq.query_id, qsp.plan_id, qsp.is_forced_plan, qsp.last_force_failure_reason_desc
FROM sys.query_store_plan AS qsp
JOIN sys.query_store_query AS qsq ON qsp.query_id = qsq.query_id
WHERE qsq.object_id = OBJECT_ID('BocaVoxSystem.prc_ProcessBulk');
