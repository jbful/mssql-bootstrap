#!/bin/bash
echo $1
docker run  -itd -e 'ACCEPT_EULA=Y' \
	-e 'SA_PASSWORD=3mm!Dev!' \
	-p 1433:1433 \
	--name  $1\
	-h $1 \
	mssql
