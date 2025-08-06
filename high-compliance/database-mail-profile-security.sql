/*
    database-mail-profile-security.sql
    Shows which principals have access to Database Mail profiles with expanded details.

    Refs: HIPAA 164.312(b)
*/
SELECT
    p.profile_id,
    p.name AS ProfileName,
    p.description,
    sp.principal_id,
    sp.name AS PrincipalName,
    sp.type_desc AS PrincipalType,
    sp.is_disabled,
    sp.create_date,
    sp.default_database_name,
    pp.is_default AS IsDefault
FROM msdb.dbo.sysmail_principalprofile AS pp
JOIN msdb.dbo.sysmail_profile AS p
    ON pp.profile_id = p.profile_id
LEFT JOIN sys.server_principals AS sp
    ON pp.principal_id = sp.principal_id;
