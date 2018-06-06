:setvar workingDir "C:\cygwin64\home\bfultz\Work\sqlbootstrap\db"
:r $(workingDir)/create_login.sql

:setvar ddluser			"emmi_15_ddl"
:setvar ddlPWD			"SS0tlpUInyi6npIMhpOQ"

exec dbo.#logins @uid = '$(ddluser)', @pwd = N'$(ddlPWD)', @forceUpdate= 0
if object_id ('tempdb..#logins') is not null
	drop procedure #logins

declare @dbs table (dbname sysname)
declare @dbname sysname
declare @tsql nvarchar(max)
insert @dbs values ('EMMI_15'),('EMMI_CONV'),('EMMI_EP_INTEG')
while exists (select 1 from @dbs as d)
begin
	select @dbname= d.dbname from @dbs as d
	if not exists(select * from sys.database_principals sp where name = '$(ddluser)' and type='S') and len('$(ddluser)')>0
		set @tsql = N'
			USE ' + @dbname+ '
			if not exists(select * from sys.database_principals sp where name = ''$(ddluser)'' and type=''S'') and len(''$(ddluser)'')>0
				create USER [$(ddluser)] FOR LOGIN [$(ddluser)] WITH DEFAULT_SCHEMA=[dbo]
			if len(''$(ddluser)'')>0
				exec sp_addrolemember ''db_owner'',''$(ddluser)''
			'
		exec sp_executesql @tsql
	delete from @dbs where dbname=@dbname
end

