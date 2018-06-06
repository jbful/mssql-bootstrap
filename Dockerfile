FROM microsoft/mssql-server-linux:2017-CU7
MAINTAINER bfultz@emmisolutions.com
#RUN apt-get update && apt-get install -y realmd  && apt-get install -y krb5-user && apt-get install -y software-properties-common  && apt-get install -y python-software-properties && apt-get install -y packagekit
#RUN apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
#COPY entrypoint.sh /
#COPY db /sqlbootstrap
#WORKDIR /sqlbootstrap
#CMD ["/entrypoint.sh"]
CMD ["opt/mssql/bin/sqlservr"]
