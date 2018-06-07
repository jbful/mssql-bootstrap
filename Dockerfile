FROM microsoft/mssql-server-linux:2017-CU7
COPY entrypoint.sh /
COPY db /sqlbootstrap
WORKDIR /sqlbootstrap
CMD ["/entrypoint.sh"]
