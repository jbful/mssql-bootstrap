
if object_id ('tempdb..#logins') is not null
	drop procedure #logins
go

create procedure #logins (@uid sysname,@pwd nvarchar(max),@forceUpdate bit =0)
as 
begin
	declare @isHashed bit,@tsql nvarchar(max)

	set @isHashed = case when left(@pwd,2) ='0x' then 1 else 0 end
	if len(@uid)>0 
		begin 
			/*
				TODO:  More restrictive rules on passsword??
			*/
			if len(@pwd) = 0
				begin
					raiserror ('Invalid password',11,1,@pwd)
				end
		
			/*
				Hash to be dynamic, script won't parse if password is blank
				Goal is if username is blank, skip user creation. 
				blank user and blank pwd is valid config
			*/
			if not exists(select * from sys.server_principals sp where name = @uid and type='S') 
					begin
						if @isHashed=0
						begin
							set @tsql=N'create login ['+ @uid +'] WITH PASSWORD=N''' + @pwd + ''', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=off'
							exec sp_executesql @tsql
						end
						else
						begin
							set @tsql=N'create login ['+ @uid +'] WITH PASSWORD=' + @pwd + ' hashed, DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=off'
							exec sp_executesql @tsql
						end
					end
				else if @forceUpdate = 1
					begin
						if @isHashed=0
						begin
							set @tsql = N'alter login ['+ @uid + '] WITH PASSWORD=N'''+ @pwd + ''''
							exec sp_executesql @tsql
						end
						else
							begin
								set @tsql = N'alter login [' + @uid +'] WITH PASSWORD=' + @pwd + ' hashed,check_policy=off'
								exec sp_executesql @tsql
								set @tsql = N'alter login ['+@uid+'] WITH check_policy=on'
								exec sp_executesql @tsql
							end
					end
			end	
end
go