# High Compliance Scripts

This directory contains T-SQL scripts to help Azure SQL Managed Instance and SQL Server environments meet stringent regulatory or organizational compliance requirements. The scripts highlight configuration or schema issues that could cause audit findings and provide guidance for remediation.

## Compliance Objectives

These scripts support common compliance goals such as maintaining supported features, following secure configuration practices and preparing for external audits. They can help satisfy controls from the following frameworks:

- [Center for Internet Security (CIS) Microsoft SQL Server Benchmarks](https://www.cisecurity.org/benchmark/microsoft_sql_server)
- [Payment Card Industry Data Security Standard (PCI DSS)](https://www.pcisecuritystandards.org/)
- [ISO/IEC 27001 – Information Security Management](https://www.iso.org/isoiec-27001-information-security.html)
- [HIPAA Security Rule](https://www.hhs.gov/hipaa/for-professionals/security/index.html)

## Using the Scripts

1. Connect to the target database with SQL Server Management Studio (SSMS), Azure Data Studio or the `sqlcmd` utility.
2. Modify any placeholders in the script (e.g. replace the sample database name) before execution.
3. Execute the script and review the result set.
4. Apply the recommended changes in accordance with your change management process.

## Available Scripts

| Script | Goal | Required Permissions | Expected Output |
| --- | --- | --- | --- |
| `get-deprecated-data-types.sql` | Identify columns that use deprecated data types and recommend supported replacements to aid modernization and compliance. | Ability to query metadata in the target database (e.g. membership in `db_owner` or `VIEW DEFINITION`). | A list showing database, schema, table, column, current data type, and the recommended alternative. |

