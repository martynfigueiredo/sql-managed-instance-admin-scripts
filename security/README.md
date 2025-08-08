# Security Reporting

Scripts in this folder provide comprehensive security reports for SQL Managed Instances and on-prem SQL Server environments.

Each script targets reporting needs such as logins, permissions, encryption, auditing, and more. All scripts emit wide result sets to give deep visibility into security metadata.

## Available Scripts

- active-sessions-security.sql – session information with security context
- always-encrypted-columns.sql – columns using Always Encrypted and their key associations
- audit-events-report.sql – recent audit events from audit files
- audit-specifications.sql – server and database audit specification settings
- built-in-role-assignments.sql – fixed server roles and their members
- certificates-asymmetric-keys.sql – certificates and asymmetric keys with owners
- column-permissions-all-dbs.sql – column-level permission assignments per database
- database-object-permissions-all-dbs.sql – object-level permissions across databases
- database-principals-all-dbs.sql – database principals in all online databases
- database-role-members-all-dbs.sql – role membership per database
- database-scoped-credentials.sql – database scoped credentials and associated principals
- db-trustworthy-ownership-chain.sql – TRUSTWORTHY and ownership chain settings for each database
- dynamic-data-masking.sql – dynamic data masking rules defined per table and column
- endpoint-permissions.sql – endpoints and granted permissions
- job-owners-proxy.sql – SQL Agent job owners and proxy usage
- linked-servers-security.sql – linked servers with security mappings
- orphaned-db-users.sql – database users without corresponding server logins
- row-level-security-policies.sql – row-level security policies and predicate functions
- schema-ownership-permissions.sql – schema owners and permissions
- server-credentials.sql – server-level credentials
- server-permissions.sql – server-level permission assignments
- server-principals-and-roles.sql – server principals with role membership and policy settings
- server-role-members.sql – membership for all server roles
- sql-logins-policy-status.sql – password and policy settings for SQL logins
- tde-status.sql – Transparent Data Encryption state and key information
Use them to audit logins, permissions, role memberships, encryption settings, dynamic data masking, and other security-related aspects across instances and databases. Each script returns an extensive set of columns to deliver deep visibility into security metadata.

