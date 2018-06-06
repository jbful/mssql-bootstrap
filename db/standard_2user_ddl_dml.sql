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

	if object_id ('tempdb..#logins') is not null
		drop procedure #logins



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

if @@ERROR=0
begin
	goto Done
end

Error:
	return

Done:
	print 'completed'





