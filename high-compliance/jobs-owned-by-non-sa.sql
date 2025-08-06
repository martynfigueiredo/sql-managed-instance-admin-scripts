/*
    jobs-owned-by-non-sa.sql
    Finds SQL Agent jobs that are not owned by the sa login and includes job metadata.

    Refs: CIS SQL Server 8.1
*/
SELECT
    j.job_id,
    j.name AS JobName,
    sp.name AS JobOwner,
    j.enabled,
    j.description,
    j.date_created,
    j.date_modified,
    c.name AS Category
FROM msdb.dbo.sysjobs AS j
JOIN sys.server_principals AS sp
    ON j.owner_sid = sp.sid
LEFT JOIN msdb.dbo.syscategories AS c
    ON j.category_id = c.category_id
WHERE sp.name <> 'sa';
