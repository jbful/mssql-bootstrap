:on error resume
TDE:
begin
	use master
	if not exists (SELECT 1 FROM sys.symmetric_keys where name like '%DatabaseMasterKey%')	
		create master key encryption by password = '3mm!Dev!'

	/*
		One TDE key per server? per DB? load from file or generate?
	*/
	if not exists (select 1 from sys.certificates where  name='TdeCert')
		begin
			create certificate TdeCert
			with subject = 'TDE certificate'
		end
end

	go
	USE [$(dbname)]

	
	if not exists (select 1 FROM sys.dm_database_encryption_keys as ddek where database_id = db_id('$(dbname)'))
		create database encryption key
		with algorithm = aes_256
		encryption by server certificate TdeCert

	if not exists( select 1 from sys.databases where name='$(dbname)' and is_encrypted=1)
		alter DATABASE $(dbname) set ENCRYPTION ON;

