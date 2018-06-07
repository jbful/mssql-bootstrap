:setvar dbname			"OUTAGE_MANAGER"

:setvar dmluser			"outage_manager_dml"
:setvar dmlPWD			"d1V67aZilMmfyw7xIfSk"

:setvar ddluser			"outage_manager_ddl"
:setvar ddlPWD			"Y146wC7C5aIc0boIZivc"

:setvar rouser			""
:setvar roPWD			""

:setvar recoveryMode	"simple"
:setvar collate			"SQL_Latin1_General_CP1_CI_AS"		
:setvar dataFolder		""
:setvar logFolder		""

:r $(workingDir)/standard_3user_ddl_dml_ro.sql
