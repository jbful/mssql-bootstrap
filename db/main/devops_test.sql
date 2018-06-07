:setvar dbname			"devops_test"

:setvar dmluser			"devops_dml"
:setvar dmlPWD			"devOps!"

:setvar ddluser			"devops_ddl"
:setvar ddlPWD			"devOps@"

:setvar rouser			""
:setvar roPWD			""

:setvar recoveryMode	"simple"
:setvar collate			"SQL_Latin1_General_CP1_CI_AS"		
:setvar dataFolder		""
:setvar logFolder		""

:r $(workingDir)/standard_3user_ddl_dml_ro.sql
