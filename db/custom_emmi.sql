:on error exit

/*
	Set Server level variables:
	https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf

	get hashed logins from source servers:
	SELECT LOGINPROPERTY('emmimanager','PASSWORDHASH')

*/

use master

:r $(workingDir)/create_db.sql

:r $(workingDir)/tde.sql

:r $(workingDir)/create_login.sql

Logins:
	exec dbo.#logins @uid = '$(ddluser)', @pwd = N'$(ddlPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(dmluser)', @pwd = N'$(dmlPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(jsuser)', @pwd = N'$(jsPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(ecuser)', @pwd = N'$(ecPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(ediuser)', @pwd = N'$(ediPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(reportuser)', @pwd = N'$(reportPWD)', @forceUpdate= $(forceUpdate)
	exec dbo.#logins @uid = '$(audituser)', @pwd = N'$(auditPWD)', @forceUpdate= $(forceUpdate)
	
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
		exec sp_executesql N'create USER [$(rouser)] FOR LOGIN [$(dmluser)] WITH DEFAULT_SCHEMA=[dbo]'
	
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

if @@ERROR!=0
begin
	goto Error
end
else
	goto Done

Error:
	print 'Errors occured, incomplete'
	
	if object_id ('tempdb..#logins') is not null
		drop procedure #logins
	return

Done:
	print 'completed'
	
	if object_id ('tempdb..#logins') is not null
		drop procedure #logins
	return
