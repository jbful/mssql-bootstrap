FROM microsoft/mssql-server-linux:2017-cu7
ENV RUN_USER 500
ENV RUN_GROUP 0
ENV ACCEPT_EULA Y
ENV SA_PASSWORD YOURPWDHERE
COPY entrypoint.sh /
COPY db /sqlbootstrap
WORKDIR /sqlbootstrap
CMD ["/entrypoint.sh"]
