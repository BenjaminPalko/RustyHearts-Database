#!/bin/bash

HOST=$MSSQL_HOST
PASSWORD=$MSSQL_SA_PASSWORD

/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -i ./db/databases.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d GMRustyHearts -i ./db/GMRustyHearts.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts -i ./db/RustyHearts.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts_Account -i ./db/RustyHearts_Account.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts_Auth -i ./db/RustyHearts_Auth.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts_Auth_RealTimeEventTable -i ./db/RustyHearts_Auth_RealTimeEventTable.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts_Log -i ./db/RustyHearts_Log.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts_Procedures -i ./db/RustyHearts_Procedures Fix.sql
/opt/mssql-tools/bin/sqlcmd -S "$HOST" -U sa -P "$PASSWORD" -d RustyHearts_Auth -i ./db/setup_auth.sql
