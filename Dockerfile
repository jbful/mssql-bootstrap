FROM microsoft/mssql-server-linux:2017-CU7
ENV ACCEPT_EULA Y
ENV SA_PASSWAORD p@ssword
COPY entrypoint.sh /
COPY db /sqlbootstrap
WORKDIR /sqlbootstrap
CMD ["/entrypoint.sh"]
