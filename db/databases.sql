IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'GMRustyHearts')
  BEGIN
    CREATE DATABASE [GMRustyHearts]
  END

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'RustyHearts')
  BEGIN
    CREATE DATABASE [RustyHearts]
  END

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'RustyHearts_Account')
  BEGIN
    CREATE DATABASE [RustyHearts_Account]
  END

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'RustyHearts_Auth')
  BEGIN
    CREATE DATABASE [RustyHearts_Auth]
  END

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'RustyHearts_Log')
  BEGIN
    CREATE DATABASE [RustyHearts_Log]
  END
