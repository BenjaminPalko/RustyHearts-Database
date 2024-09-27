#!/bin/bash

/opt/mssql/bin/sqlservr &
(
	sleep 10 &&
		/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -i databases.sql &&
		/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -i setup_auth.sql
)
BACK_PID=$!
wait "$BACK_PID"
