IF DB_ID('GMRustyHearts') IS NOT NULL
  CREATE DATABASE GMRustyHearts
  ON 
    (name = so1,   filename = N'/var/opt/mssql/rusty/GMRustyHearts.mdf'),
    (name = solog, filename = N'/var/opt/mssql/rusty/GMRustyHearts_log.ldf')
  FOR ATTACH;
  GO

IF DB_ID('RustyHearts') IS NOT NULL
  CREATE DATABASE RustyHearts
  ON 
    (name = so1,   filename = N'/var/opt/mssql/rusty/RustyHearts.mdf'),
    (name = solog, filename = N'/var/opt/mssql/rusty/RustyHearts_log.ldf')
  FOR ATTACH;
  GO

IF DB_ID('RustyHearts_Account') IS NOT NULL
  CREATE DATABASE RustyHearts_Account
  ON 
    (name = so1,   filename = N'/var/opt/mssql/rusty/RustyHearts_Account.mdf'),
    (name = solog, filename = N'/var/opt/mssql/rusty/RustyHearts_Account_log.ldf')
  FOR ATTACH;
  GO

IF DB_ID('RustyHearts_Auth') IS NOT NULL
  CREATE DATABASE RustyHearts_Auth
  ON 
    (name = so1,   filename = N'/var/opt/mssql/rusty/RustyHearts_Auth.mdf'),
    (name = solog, filename = N'/var/opt/mssql/rusty/RustyHearts_Auth_log.ldf')
  FOR ATTACH;
  GO

IF DB_ID('RustyHearts_Log') IS NOT NULL
  CREATE DATABASE RustyHearts_Log
  ON 
    (name = so1,   filename = N'/var/opt/mssql/rusty/RustyHearts_Log.mdf'),
    (name = solog, filename = N'/var/opt/mssql/rusty/RustyHearts_Log_log.ldf')
  FOR ATTACH;
  GO

