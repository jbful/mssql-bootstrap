#!/bin/bash
    echo "usage: $0 forceUpdate sqlserver sapwd dirtoprocess"
    echo "  forceUpdate		tell script to force update of certain items if objects exists (1|0)"
    echo "  sqlserver		target server to run scripts on"
    echo "  sapwd		password for sa account"
    echo "  dirtoprocess	directory of files to process"

export forceUpdate=$1
export workingDir=$PWD
sleep 60s
find db/*.txt -print0 | xargs -0 -I {} /opt/mssql-tools/bin/sqlcmd -S $2 -U sa -P $3 -i {}

