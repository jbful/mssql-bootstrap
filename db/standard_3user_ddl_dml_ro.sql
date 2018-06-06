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

:r $(workingDir)/create_db.sql

:r $(workingDir)/tde.sql

:r $(workingDir)/create_login.sql

Logins:
	exec dbo.#logins @uid = '$(ddluser)', @pwd = N'$(ddlPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(dmluser)', @pwd = N'$(dmlPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(rouser)', @pwd = N'$(roPWD)', @forceUpdate= $(forceUpdate)

	if object_id ('tempdb..#logins') is not null
		drop procedure #logins


Security:
begin
	use $(dbname)

	if not exists(select * from sys.database_principals sp where name = '$(ddluser)' and type='S') and len('$(ddluser)')>0
		exec sp_executesql N'create USER [$(ddluser)] FOR LOGIN [$(ddluser)] WITH DEFAULT_SCHEMA=[dbo]'

	if not exists(select * from sys.database_principals sp where name = '$(dmluser)' and type='S') and len('$(dmluser)')>0
		exec sp_executesql N'create USER [$(dmluser)] FOR LOGIN [$(dmluser)] WITH DEFAULT_SCHEMA=[dbo]'
	
	if not exists(select * from sys.database_principals sp where name = '$(rouser)' and type='S') and len('$(rouser)')>0
		exec sp_executesql N'create USER [$(rouser)] FOR LOGIN [$(rouser)] WITH DEFAULT_SCHEMA=[dbo]'
	
	if len('$(dmluser)')>0
	begin
		exec sp_addrolemember 'db_datareader','$(dmluser)'
		exec sp_addrolemember 'db_datawriter','$(dmluser)'
	end

	if len('$(rouser)')>0
	begin
		exec sp_addrolemember 'db_datareader','$(rouser)'
	end

	if len('$(ddluser)')>0
		exec sp_addrolemember 'db_owner','$(ddluser)'
end

if @@ERROR=0
begin
	goto Done
end

Error:
	return

Done:
	print 'completed'





