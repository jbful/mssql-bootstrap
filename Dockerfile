FROM microsoft/mssql-server-linux:2017-CU7
MAINTAINER bfultz@emmisolutions.com
#CMD ["opt/mssql/bin/sqlservr"]

ENTRYPOINT [ "uid_entrypoint" ]

CMD /opt/mssql/bin/sqlservr
