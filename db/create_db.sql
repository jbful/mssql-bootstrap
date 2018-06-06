/*

	ToDos:
		Validate Folder existence for data/log

*/
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
	else 
	begin
		set @defData = coalesce(@userData,@defData) + '$(dbname).mdf'
		set @defLog = coalesce(@userLog,@defLog) + '$(dbname).ldf'
	end
end

set @tsql =
'
	create database [$(dbname)] 
	containment=none
	on primary
	(name =  N''$(dbname)'',filename='''+@defData+''',filegrowth=1024MB)
	log on 
	(name = N''$(dbname)_log'',filename='''+@defLog+''',filegrowth=1024MB)
'
print @tsql

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