:on error exit

/*
	Set Server level variables:
	https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf

	get hashed logins from source servers:
	SELECT LOGINPROPERTY('emmimanager','PASSWORDHASH')

	ToDos:
		Validate Folder existence for data/log
*/

use master
go
Init:
begin	
	declare @isLinux bit,@defData nvarchar(max), @defLog nvarchar(max),@tsql nvarchar(max),@userData nvarchar(max),@userLog nvarchar(max),@init bit=0declare @forceUpdate bit
	set @forceUpdate = cast('$(forceUpdate)' as bit)
	select @isLinux=case when lower(@@VERSION) like '%linux%' then 1 else 0 end

	set @userData = case when len('$(dataFolder)')>1 then '$(dataFolder)' else null end
	set @userLog = case when len('$(logFolder)')>1 then '$(logFolder)' else null end
		
	select @defData = convert(nvarchar(max),serverproperty('InstanceDefaultDataPath') )
	select @defLog = convert(nvarchar(max),serverproperty('InstanceDefaultLogPath') )

	if @isLinux=1
	begin
		set @defData = coalesce(@userData,@defData) + '/$(dbname).mdf'
		set @defLog = coalesce(@userLog,@defLog) + '/$(dbname).ldf'
	end
end


set @tsql =
'
	create database [$(dbname)] 
	containment=none
	on primary
	(name =  N''$(dbname)'',filename='''+@defData+''',filegrowth=1024GB)
	log on 
	(name = N''$(dbname)_log'',filename='''+@defLog+''',filegrowth=1024gb)
'

if not exists (select 1 from sys.databases where name='$(dbname)')
	begin
		exec sp_executesql @tsql
		set @init =1
	end

if @forceUpdate =1 or @init=1
begin
	exec sp_executesql N'alter DATABASE [$(dbname)] SET RECOVERY $(recoveryMode)' 
	
	exec sp_executesql N'
	alter database [$(dbname)] collate $(collate)
	alter database [$(dbname)] set ansi_null_default off
	alter database [$(dbname)] set ansi_nulls off 
	alter database [$(dbname)] set ansi_padding off 
	alter database [$(dbname)] set ansi_warnings off 
	alter database [$(dbname)] set arithabort off 
	alter database [$(dbname)] set concat_null_yields_null off 
	alter database [$(dbname)] set numeric_roundabort off 
	alter database [$(dbname)] set quoted_identifier off '
end

Logins:
begin
	declare @pwd nvarchar(max), @isHashed bit
	set @pwd = '$(ddlPWD)'
	set @isHashed = case when left(@pwd,2) ='0x' then 1 else 0 end

	if not exists(select * from sys.server_principals sp where name = '$(ddluser)' and type='S')
		begin
			if @isHashed=0
				create login [$(ddluser)] WITH PASSWORD=N'$(ddlPWD)', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=on
			else
				create login [$(ddluser)] WITH PASSWORD=$(ddlPWD) hashed, DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=on
		end
	else
		begin
			if @isHashed=0
				alter login [$(ddluser)] WITH PASSWORD=N'$(ddlPWD)'
			else
				alter login [$(ddluser)] WITH PASSWORD=$(ddlPWD) hashed,check_policy=off
				alter login [$(ddluser)] WITH check_policy=on
		end

	set @pwd = null
	set @isHashed = null
	
	set @pwd = '$(dmlPWD)'
	set @isHashed = case when left(@pwd,2) ='0x' then 1 else 0 end
	
	if not exists(select * from sys.server_principals sp where name = '$(dmluser)' and type='S')
		begin
			if @isHashed=0
				create login [$(dmluser)] WITH PASSWORD=N'$(dmlPWD)', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=on
			else
				create login [$(dmluser)] WITH PASSWORD=$(dmlPWD) hashed, DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=on
		end
	else
		begin
			if @isHashed=0
				alter login [$(dmluser)] WITH PASSWORD=N'$(dmlPWD)'
			else
				alter login [$(dmluser)] WITH PASSWORD=$(dmlPWD) hashed,check_policy=off
				alter login [$(dmluser)] WITH check_policy=on

		end
end

TDE:
begin
	use master
	begin try
		create master key encryption by password = '3mm!Dev!'
	end try
	begin catch end catch

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


Security:
begin
	use $(dbname)

	if not exists(select * from sys.database_principals sp where name = '$(ddluser)' and type='S')
		create USER [$(ddluser)] FOR LOGIN [$(ddluser)] WITH DEFAULT_SCHEMA=[dbo]

	if not exists(select * from sys.database_principals sp where name = '$(dmluser)' and type='S')
		create USER [$(dmluser)] FOR LOGIN [$(dmluser)] WITH DEFAULT_SCHEMA=[dbo]
	
	exec sp_addrolemember 'db_datareader','$(dmluser)'
	exec sp_addrolemember 'db_datawriter','$(dmluser)'

	exec sp_addrolemember 'db_owner','$(ddluser)'
end






