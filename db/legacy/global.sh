#!/bin/bash
export forceUpdate=$1
echo $1
echo $2
echo $3
find *.txt -print0 | xargs -0 -I {} /opt/mssql-tools/bin/sqlcmd -S $2 -U sa -P $3 -i {}


