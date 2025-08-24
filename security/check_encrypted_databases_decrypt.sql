
select * from sys.databases where is_encrypted = 1;
GO
use master
go
alter database [ADVENTUREWORKS2025] set encryption Off
go
use [ADVENTUREWORKS2025]
go
DROP DATABASE ENCRYPTION KEY
GO
