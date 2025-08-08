/*
    always-encrypted-columns.sql
    Always Encrypted configuration info.
*/

DECLARE @sql NVARCHAR(MAX);

;WITH dbs AS (
    SELECT name
    FROM sys.databases
    WHERE state_desc = 'ONLINE'
      AND database_id > 4
)
SELECT @sql = STRING_AGG(
    'SELECT ' + QUOTENAME(name, '''') + ' AS database_name,
            t.schema_id,
            sch.name AS schema_name,
            t.name AS table_name,
            c.name AS column_name,
            c.column_id,
            c.is_nullable,
            TYPE_NAME(c.user_type_id) AS data_type,
            c.max_length,
            c.encryption_type_desc,
            cek.name AS column_encryption_key_name,
            cek.create_date AS cek_create_date,
            cek.modify_date AS cek_modify_date,
            cekv.encryption_algorithm_name,
            cekv.encryption_type_desc,
            cekv.encryption_state,
            cmk.name AS column_master_key_name,
            cmk.key_store_provider_name,
            cmk.key_path,
            cmk.create_date AS cmk_create_date,
            cmk.modify_date AS cmk_modify_date
     FROM ' + QUOTENAME(name) + '.sys.columns AS c
     JOIN ' + QUOTENAME(name) + '.sys.tables AS t
          ON c.object_id = t.object_id
     JOIN ' + QUOTENAME(name) + '.sys.schemas AS sch
          ON t.schema_id = sch.schema_id
     JOIN ' + QUOTENAME(name) + '.sys.column_encryption_key_values AS cekv
          ON c.column_encryption_key_id = cekv.column_encryption_key_id
     JOIN ' + QUOTENAME(name) + '.sys.column_encryption_keys AS cek
          ON cekv.column_encryption_key_id = cek.column_encryption_key_id
     JOIN ' + QUOTENAME(name) + '.sys.column_master_keys AS cmk
          ON cekv.column_master_key_id = cmk.column_master_key_id
     WHERE c.encryption_type IS NOT NULL',
    CHAR(13)+CHAR(10)+'UNION ALL'+CHAR(13)+CHAR(10)
    ) WITHIN GROUP (ORDER BY name)
FROM dbs;

EXEC sys.sp_executesql @sql;
