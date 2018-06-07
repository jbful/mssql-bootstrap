
select name,LOGINPROPERTY('audit','PASSWORDHASH') 

exec sp_msforeachdb '
use [?]
SELECT DB=''?'', name,LOGINPROPERTY(name,''PASSWORDHASH'') FROM sys.database_principals dp where type=''S'' and dp.authentication_type=1'


/*
EMMI	JBOSS_SRVR	0x020067ABD99DCB17F92095BE6E9CD6ACEB13712BF9A6586FDEDF445DBE0BE043B79F798119DD8D741C6F38FBFC9158C8D3AB3F1B8C244F491B578D610C8210CBC0017595C96D
EMMI	emmimanager	0x0200D50E944C15BEEA827AFA0EABA9173B2B352DFC6CE82F0E1CADD724D136AD1BF86B99A632D7637831A722134AAFE45FFFAEBCDA2852D82B230B9DB8E3D0C257774E5D8C1E
EMMI	EMMI_CONV	0x02004C44760F2771F577AB660C91A52E70C6B58726857DACBF9DD8B0080C98202CE46885EF02597ED4146A4F4432B47D4B0603518484FE3DAAE5A0EC1FAD85519D8C8FA39CE3
EMMI	em2cleanup	0x020031DE4177C21B61B088F6D7F58063F48EEEC16F9D5DDA72EBBB8A179E7867EF7162F80FBF08745920EE50C323F75A1687DDBF4690216A3DEEC1BD0FB29B8FD3389A90B765



dbo	NULL	dbo	1	S	SQL_USER	dbo	2003-04-08 09:10:42.287	2016-05-25 23:43:02.557	NULL	0x01	0	1	INSTANCE	NULL	NULL
JBOSS_SRVR	0x0200903635A00F8FEDD984355D2E037B190CE8FDE6A1C76F979527C15A302A07F16DD179460FB7BB18FAA8D86C76D27EE080422621DC0018D7BEEE03DFD08128E64A851CAD57	JBOSS_SRVR	5	S	SQL_USER	dbo	2016-05-25 23:50:13.700	2016-05-25 23:50:13.700	NULL	0x4D160A792F8C894F9506C83C5F37BBE4	0	1	INSTANCE	NULL	NULL
emmimanager	0x0200742F6E003A7EC428DE1CB5FAD55CAF3ED3C94DE5E8C8ADA5AE6351B6E818D056920DABD3D2F9E237DFED4D4ABED320073C85119873B365AB5113C8C539D8521DF8744A1F	emmimanager	7	S	SQL_USER	dbo	2016-05-25 23:51:49.593	2016-05-25 23:51:49.593	NULL	0x4A546801F6F96E4F9799DF493F34779B	0	1	INSTANCE	NULL	NULL
EMMI_CONV	0x02004C44760F2771F577AB660C91A52E70C6B58726857DACBF9DD8B0080C98202CE46885EF02597ED4146A4F4432B47D4B0603518484FE3DAAE5A0EC1FAD85519D8C8FA39CE3	EMMI_CONV	9	S	SQL_USER	dbo	2016-06-17 11:26:03.117	2016-06-17 11:26:03.117	NULL	0x7DCA2AD3A004BA4DB163D750CED283F3	0	1	INSTANCE	NULL	NULL

EDI_login	0x020061866FD345BDBE42E56EE5AA80FD54B84081765E819C88E2781D1F0E21C6F9E66399D7A640698E24FA0AA1DBC8FE78742069515423BD4D4B04DBE530F42782497453867B	EDI_login	10	S	SQL_USER	dbo	2016-06-23 13:28:12.070	2016-06-23 13:28:12.070	NULL	0x4F7BA5B31E96ED41A78FE3E3548FD5E0	0	1	INSTANCE	NULL	NULL
audit	0x0200FA9ABAB9F603E3384E46763A077A82E01619D4CF1ABCD249D1683D6F9EB36F23E83571B42D0A4EC932213F5312E25204676660BCA4381E756D478C4DE79F3BEF626CF096	audit	15	S	SQL_USER	dbo	2016-07-25 12:03:04.123	2016-07-25 12:03:04.123	NULL	0xD527CD74DF5F6A479078178D7B78992A	0	1	INSTANCE	NULL	NULL
reports	0x0200E365A2EABE6EB4544A13F762E323C74928FB84C20C049C42CF9BD03BCC3373241D4E9D079F8FF537D3F468AA8A555EE8C74AC5D086BA73819EA3A24B7E51EF6FF726328F	reports	16	S	SQL_USER	dbo	2016-07-27 11:50:17.727	2016-07-27 11:50:17.727	NULL	0x8CB9F502EBE3B749A12A9EE1D1226699	0	1	INSTANCE	NULL	null
*/