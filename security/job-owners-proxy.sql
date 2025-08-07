/*
    job-owners-proxy.sql
    SQL Agent job owners and proxy accounts (run in msdb).
*/

USE msdb;
SELECT
    j.job_id,
    j.name AS job_name,
    j.enabled,
    j.owner_sid,
    sp.name AS owner_name,
    j.description,
    j.category_id,
    j.date_created,
    j.date_modified,
    j.notify_email_operator_id,
    ja.step_id,
    ja.step_name,
    ja.subsystem,
    ja.proxy_id,
    p.name AS proxy_name,
    p.credential_id,
    p.enabled AS proxy_enabled
FROM dbo.sysjobs AS j
LEFT JOIN master.sys.server_principals AS sp
       ON j.owner_sid = sp.sid
LEFT JOIN dbo.sysjobsteps AS ja
       ON j.job_id = ja.job_id
LEFT JOIN dbo.sysproxies AS p
       ON ja.proxy_id = p.proxy_id
ORDER BY j.name;
