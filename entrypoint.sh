#!/bin/bash

RUN sed -i "s/<SERVER_PUBLIC_IP>/${SERVER_PUBLIC_IP}/g" ./db/setup_auth.sql

/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -i ./db/databases.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d GMRustyHearts -i ./db/GMRustyHearts.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts -i ./db/RustyHearts.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts -i ./db/RustyHearts_Procedures_Fix.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts_Account -i ./db/RustyHearts_Account.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts_Auth -i ./db/RustyHearts_Auth.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts_Auth -i ./db/RustyHearts_Auth_RealTimeEventTable.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts_Log -i ./db/RustyHearts_Log.sql
/opt/mssql-tools/bin/sqlcmd -S "$MSSQL_HOST" -U sa -P "$MSSQL_SA_PASSWORD" -d RustyHearts_Auth -i ./db/setup_auth.sql
