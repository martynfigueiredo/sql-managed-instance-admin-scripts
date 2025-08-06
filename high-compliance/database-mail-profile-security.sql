/*
    database-mail-profile-security.sql
    Shows which principals have access to Database Mail profiles with expanded details.

    Refs: HIPAA 164.312(b)
*/
SELECT
    p.profile_id,
    p.name AS ProfileName,
    p.description,
    pp.is_default AS IsDefault,
    CONVERT(VARCHAR(85), pp.principal_sid, 1) AS PrincipalSID,
    sp.name AS PrincipalName,
    sp.type_desc AS PrincipalType,
    sp.is_disabled,
    sp.create_date,
    sp.default_database_name
FROM msdb.dbo.sysmail_profile AS p
JOIN msdb.dbo.sysmail_principalprofile AS pp
    ON pp.profile_id = p.profile_id
LEFT JOIN sys.server_principals AS sp
    ON pp.principal_sid = sp.sid
ORDER BY p.name, sp.name;
