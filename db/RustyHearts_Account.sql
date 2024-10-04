/*
 Navicat Premium Data Transfer

 Source Server         : RH VM
 Source Server Type    : SQL Server
 Source Server Version : 16001105
 Source Host           : 192.168.100.202:1433
 Source Catalog        : RustyHearts_Account
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001105
 File Encoding         : 65001

 Date: 12/12/2023 01:47:43
*/


-- ----------------------------
-- Table structure for AccountTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountTable]') AND type IN ('U'))
	DROP TABLE [dbo].[AccountTable]
GO

CREATE TABLE [dbo].[AccountTable] (
  [AccountID] int  IDENTITY(1,1) NOT NULL,
  [WindyCode] varchar(50) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [AccountPwd] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [Email] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [RegisterIP] varchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [CreatedAt] datetime DEFAULT getdate() NOT NULL,
  [LastLogin] datetime DEFAULT getdate() NOT NULL,
  [IsLocked] bit  NOT NULL,
  [LoginAttempts] int  NOT NULL,
  [LastLoginIP] varchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [Token] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[AccountTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of AccountTable
-- ----------------------------
SET IDENTITY_INSERT [dbo].[AccountTable] ON
GO

INSERT INTO [dbo].[AccountTable] ([AccountID], [WindyCode], [AccountPwd], [Email], [RegisterIP], [CreatedAt], [LastLogin], [IsLocked], [LoginAttempts], [LastLoginIP], [Token]) VALUES (N'1', N'ragezone', N'$2a$10$Er7UoQNTihU1ibrX/iSglO3gukkIidUk8P9DthmV5VpfeZ8YOp8kK', N'example@gmail.com', N'192.168.1.1', N'2023-05-27 19:12:19.897', N'2023-12-11 18:45:35.617', N'0', N'0', N'192.168.100.2', N'f3df1542996269928c9f45bd0693269b14cfff39bb72cc3705590957945df170')
GO

SET IDENTITY_INSERT [dbo].[AccountTable] OFF
GO


-- ----------------------------
-- Table structure for BillingLog
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[BillingLog]') AND type IN ('U'))
	DROP TABLE [dbo].[BillingLog]
GO

CREATE TABLE [dbo].[BillingLog] (
  [bid] int  IDENTITY(1,1) NOT NULL,
  [BuyTime] datetime  NULL,
  [WindyCode] varchar(50) COLLATE Chinese_PRC_CI_AS  NULL,
  [CharId] varchar(128) COLLATE Chinese_PRC_CI_AS  NULL,
  [UniqueId] varchar(128) COLLATE Chinese_PRC_CI_AS  NULL,
  [Amount] int  NULL,
  [ItemId] int  NULL,
  [ItemCount] int  NULL
)
GO

ALTER TABLE [dbo].[BillingLog] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of BillingLog
-- ----------------------------
SET IDENTITY_INSERT [dbo].[BillingLog] ON
GO

SET IDENTITY_INSERT [dbo].[BillingLog] OFF
GO


-- ----------------------------
-- Table structure for CashTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[CashTable]') AND type IN ('U'))
	DROP TABLE [dbo].[CashTable]
GO

CREATE TABLE [dbo].[CashTable] (
  [WindyCode] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [WorldId] int  NULL,
  [Zen] bigint  NULL
)
GO

ALTER TABLE [dbo].[CashTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of CashTable
-- ----------------------------
INSERT INTO [dbo].[CashTable] ([WindyCode], [WorldId], [Zen]) VALUES (N'ragezone', N'10101', N'500000')
GO


-- ----------------------------
-- Table structure for VerificationCode
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[VerificationCode]') AND type IN ('U'))
	DROP TABLE [dbo].[VerificationCode]
GO

CREATE TABLE [dbo].[VerificationCode] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [Email] varchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [VerificationCode] varchar(10) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [ExpirationTime] datetime  NOT NULL,
  [Type] varchar(20) COLLATE Chinese_PRC_CI_AS  NOT NULL
)
GO

ALTER TABLE [dbo].[VerificationCode] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of VerificationCode
-- ----------------------------
SET IDENTITY_INSERT [dbo].[VerificationCode] ON
GO

SET IDENTITY_INSERT [dbo].[VerificationCode] OFF
GO


-- ----------------------------
-- procedure structure for GetVerificationCode
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVerificationCode]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[GetVerificationCode]
GO

CREATE PROCEDURE [dbo].[GetVerificationCode]
    @VerificationCode varchar(10),
    @Email varchar(255),
		@VerificationCodeType varchar(20)
AS
BEGIN
		DECLARE @Result varchar(30)
    DECLARE @ExpirationTime DATETIME
    DECLARE @Now DATETIME = GETDATE()
		DECLARE @VerificationCodeExists int;

    SELECT @VerificationCodeExists = COUNT(*) FROM VerificationCode
    WHERE Email = @Email AND VerificationCode = @VerificationCode AND Type = @VerificationCodeType
		
		-- Check if VerificationCode exists
         IF @VerificationCodeExists > 0
        SET @Result = 'VerificationCodeExists';
        ELSE 
        SET @Result = 'InvalidVerificationCode';
		
		
    SELECT @ExpirationTime = ExpirationTime
    FROM VerificationCode
    WHERE Email = @Email AND VerificationCode = @VerificationCode

IF @Result = 'VerificationCodeExists' 
    BEGIN
				IF @ExpirationTime > @Now
		
				SET @Result = 'ValidVerificationCode';
				ELSE 
				SET @Result = 'ExpiredVerificationCode';
				END

    SELECT @Result as Result;
END
GO


-- ----------------------------
-- procedure structure for UpdateAccountPassword
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateAccountPassword]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[UpdateAccountPassword]
GO

CREATE PROCEDURE [dbo].[UpdateAccountPassword]
    @AccountPwd varchar(255),
    @Email varchar(255)
AS
BEGIN
    SET NOCOUNT ON;
		
		DECLARE @Result varchar(20)
    DECLARE @AccountExists int;
		
		BEGIN TRY
		BEGIN TRANSACTION

    SELECT @AccountExists = COUNT(*) FROM AccountTable
    WHERE Email = @Email;


-- Check if account exists
         IF @AccountExists > 0
        SET @Result = 'AccountExists';
        ELSE 
        SET @Result = 'Failed';

    -- Update password
    IF @Result = 'AccountExists' 
    BEGIN
        UPDATE AccountTable SET AccountPwd = @AccountPwd
WHERE Email = @Email;
		
		SET @Result = 'PasswordChanged';

END;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
SET @Result = 'TransactionFailed';
END CATCH

SELECT @Result as Result;

END
GO


-- ----------------------------
-- procedure structure for ClearVerificationCode
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ClearVerificationCode]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[ClearVerificationCode]
GO

CREATE PROCEDURE [dbo].[ClearVerificationCode]
    @Email varchar(255)
AS
BEGIN
    SET NOCOUNT ON;
		
		DECLARE @Result varchar(30)
    DECLARE @VerificationCodeExists int;
		
		BEGIN TRY
		BEGIN TRANSACTION

    SELECT @VerificationCodeExists = COUNT(*) FROM VerificationCode
    WHERE Email = @Email;


-- Check if VerificationCode exists
         IF @VerificationCodeExists > 0
        SET @Result = 'VerificationCodeExists';
        ELSE 
        SET @Result = 'NoVerificationCode';

    -- DELETE VerificationCodes
    IF @Result = 'VerificationCodeExists' 
    BEGIN
        DELETE FROM VerificationCode WHERE Email = @Email;
		
		SET @Result = 'VerificationCodeClean';

END;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
SET @Result = 'TransactionFailed';
END CATCH

SELECT @Result as Result;

END
GO


-- ----------------------------
-- procedure structure for GetAccount
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAccount]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[GetAccount]
GO

CREATE PROCEDURE [dbo].[GetAccount]
    @Identifier varchar(255)
AS
BEGIN

    DECLARE @Result varchar(20)
    DECLARE @AccountExists int;
		DECLARE @WindyCode varchar(50)
		DECLARE @AccountPwd varchar(255)
	

    SELECT @AccountExists = COUNT(*) FROM AccountTable
    WHERE Email = @Identifier OR WindyCode = @Identifier;
		SELECT @WindyCode = WindyCode FROM AccountTable
    WHERE Email = @Identifier OR WindyCode = @Identifier;
		SELECT @AccountPwd = AccountPwd FROM AccountTable
    WHERE Email = @Identifier OR WindyCode = @Identifier;


-- Check if account exists
         IF @AccountExists > 0
        SET @Result = 'AccountExists';
        ELSE 
        SET @Result = 'AccountNotFound';

    SELECT @Result as Result, @WindyCode as WindyCode, @AccountPwd as AccountPwd;

END
GO


-- ----------------------------
-- procedure structure for GetCurrency
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCurrency]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[GetCurrency]
GO

CREATE PROCEDURE [dbo].[GetCurrency]
    @UserId varchar(50),
    @ServerId int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Result varchar(20)
    DECLARE @Zen int;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Check if entry with given UserId and ServerId exists
        SELECT @Zen = Zen FROM CashTable
        WHERE WindyCode = @UserId AND WorldId = @ServerId;

        IF @@ROWCOUNT > 0 -- entry exists
        BEGIN
            SET @Result = 'Success';
        END
        ELSE -- entry does not exist, insert new one
        BEGIN
            INSERT INTO CashTable (WindyCode, WorldId, Zen)
            VALUES (@UserId, @ServerId, 0);

            SET @Result = 'Success';
            SET @Zen = 0;
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Result = 'TransactionFailed';
        SET @Zen = 0;
    END CATCH

    SELECT @Result as Result, @Zen as Zen;
END
GO


-- ----------------------------
-- procedure structure for SetPasswordVerificationCode
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[SetPasswordVerificationCode]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[SetPasswordVerificationCode]
GO

CREATE PROCEDURE [dbo].[SetPasswordVerificationCode]
    @VerificationCode varchar(10),
    @Email varchar(255),
    @ExpirationTime DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Result varchar(20);
    DECLARE @VerificationCodeCount int;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Retrieve count of existing verification codes for the user
        SELECT @VerificationCodeCount = COUNT(*) FROM VerificationCode
        WHERE Email = @Email;

        -- Check if count of existing verification codes is less than 5
        IF @VerificationCodeCount < 5
        BEGIN
            -- Insert new verification code
            INSERT INTO VerificationCode (VerificationCode, Email, ExpirationTime, Type)
            VALUES (@VerificationCode, @Email, @ExpirationTime, 'Password');
            SET @Result = 'Success';
        END
        ELSE
        BEGIN
            -- Delete all existing verification codes for the user
            DELETE FROM VerificationCode WHERE Email = @Email;

            -- Insert new verification code
            INSERT INTO VerificationCode (VerificationCode, Email, ExpirationTime, Type)
            VALUES (@VerificationCode, @Email, @ExpirationTime, 'Password');
            SET @Result = 'Success';
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Result = 'TransactionFailed';
    END CATCH;

    SELECT @Result as Result;
END;
GO


-- ----------------------------
-- procedure structure for SetCurrency
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[SetCurrency]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[SetCurrency]
GO

CREATE PROCEDURE [dbo].[SetCurrency]
    @UserId varchar(50),
    @ServerId int,
		@NewBalance int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Result varchar(20)
		DECLARE @Zen int;

    BEGIN TRY
        BEGIN TRANSACTION

        -- Check if entry with given UserId and ServerId exists
        SELECT @Zen = Zen FROM CashTable
        WHERE WindyCode = @UserId AND WorldId = @ServerId;

        IF @@ROWCOUNT > 0 -- entry exists
        BEGIN
            UPDATE CashTable SET Zen = @NewBalance
						WHERE WindyCode = @UserId AND WorldId = @ServerId;
						
						SET @Zen = @NewBalance;
            SET @Result = 'Success';
        END
        ELSE -- entry does not exist
        BEGIN
            SET @Result = 'Failed';
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Result = 'TransactionFailed';
    END CATCH

    SELECT @Result as Result, @Zen as Zen;
END
GO


-- ----------------------------
-- procedure structure for SetBillingLog
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[SetBillingLog]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[SetBillingLog]
GO

CREATE PROCEDURE [dbo].[SetBillingLog]
(
  @userid varchar(50),
  @charid varchar(128),
  @uniqueid varchar(128),
  @amount int,
  @itemid int,
  @itemcount int
)
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    -- Insert the values into the BillingLog table
    INSERT INTO BillingLog (BuyTime, WindyCode, CharId, UniqueId, Amount, ItemId, ItemCount)
        VALUES (GETDATE(), @userid, @charid, @uniqueid, @amount, @itemid, @itemcount);

    -- Return a success message
    SELECT 'Success' AS Result;
  END TRY
  BEGIN CATCH
    -- Log the error and return an error message
    DECLARE @errorMessage varchar(4000) = ERROR_MESSAGE();
    RAISERROR(@errorMessage, 16, 1);

    -- Return an error message
    SELECT 'Error: ' + @errorMessage AS Result;
  END CATCH;
END;
GO


-- ----------------------------
-- procedure structure for CreateAccount
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateAccount]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[CreateAccount]
GO

CREATE PROCEDURE [dbo].[CreateAccount]
    @WindyCode varchar(50),
    @AccountPwd varchar(255),
    @Email varchar(255),
    @RegisterIP varchar(16)
AS
BEGIN
    SET NOCOUNT ON;
		
		DECLARE @Result varchar(20)
    DECLARE @AccountExists int;
		DECLARE @WindyCodeExists int;
		
		BEGIN TRY
		BEGIN TRANSACTION


    SELECT @AccountExists = COUNT(*) FROM AccountTable
    WHERE WindyCode = @WindyCode OR Email = @Email;
		SELECT @WindyCodeExists = COUNT(*) FROM RustyHearts_Auth.dbo.AuthTable
    WHERE WindyCode = @WindyCode;


-- Check if account exists
         IF @AccountExists > 0
        SET @Result = 'AccountExists';
				ELSE IF @WindyCodeExists > 0
        SET @Result = 'WindyCodeExists';
        ELSE 
        SET @Result = 'NewUser';

    -- Create new account
    IF @Result = 'NewUser' 
    BEGIN
        INSERT INTO AccountTable (WindyCode, AccountPwd, Email, RegisterIP, CreatedAt, LastLogin, IsLocked, LoginAttempts, LastLoginIP)
    VALUES (@WindyCode, @AccountPwd, @Email, @RegisterIP, GETDATE(), GETDATE(), 0, 0, @RegisterIP);
		
		INSERT INTO RustyHearts_Auth.dbo.AuthTable (WindyCode, world_id, AuthID, Tcount, online, CTime, BTime, LTime, IP, LCount, ServerIP, ServerType, HostID, DBCIndex, InquiryCount, event_inquiry, CashMileage, channelling, pc_room_point, externcash, mac_addr, mac_addr02, mac_addr03, second_pass) 
    VALUES (@WindyCode, 0, NEWID(), 0, '0', GETDATE(), GETDATE(), GETDATE(), @RegisterIP, 0, 0, 0, 0, 0, 5, 1, 0, 1, 0, 0, '00-00-00-00-00-00', '00-00-00-00-00-00', '00-00-00-00-00-00', '');
		
		INSERT INTO CashTable (WindyCode, WorldId, Zen)
    VALUES (@WindyCode, 10101, 0);
		
		
		SET @Result = 'AccountCreated';

END;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
SET @Result = 'TransactionFailed';
END CATCH

SELECT @Result as Result;

END
GO


-- ----------------------------
-- procedure structure for AuthenticateUser
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[AuthenticateUser]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[AuthenticateUser]
GO

CREATE PROCEDURE [dbo].[AuthenticateUser]
@Identifier varchar(255),
@password_verify_result BIT,
@LastLoginIP varchar(15)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @Result varchar(20)
DECLARE @WindyCode varchar(50)
DECLARE @AuthID varchar(50)
DECLARE @LoginAttempts int
DECLARE @IsLocked BIT
DECLARE @Now datetime = GETDATE()
DECLARE @LastLogin datetime
DECLARE @Token NVARCHAR(64)
DECLARE @RandomBytes VARBINARY(32)

BEGIN TRY
    BEGIN TRANSACTION

    -- Retrieve account information
    SELECT @WindyCode = WindyCode, @LoginAttempts = LoginAttempts, @IsLocked = IsLocked, @LastLogin = LastLogin
    FROM AccountTable 
    WHERE WindyCode = @Identifier OR Email = @Identifier;
		SELECT @AuthID = AuthID
    FROM RustyHearts_Auth.dbo.AuthTable
    WHERE WindyCode = @WindyCode;
		
    -- Check if last login attempt is within 5 minutes
    IF DATEDIFF(minute, @LastLogin, @Now) > 5 
    BEGIN
        UPDATE AccountTable SET LoginAttempts = 0 WHERE WindyCode = @Identifier OR Email = @Identifier;
    END
	    
    -- Verify password
    IF @password_verify_result = 1 
    BEGIN
        SET @Result = 'LoginSuccess';
        
				SET @RandomBytes = CAST(CRYPT_GEN_RANDOM(32) AS VARBINARY(32)) -- Generate 32 random bytes
				SET @Token = LOWER(CONVERT(NVARCHAR(64), HashBytes('SHA2_256', @RandomBytes), 2)) -- Hash the random bytes using SHA256 and convert to lowercase hexadecimal string
    END
    ELSE 
        SET @Result = 'InvalidCredentials';

    -- Check account status
    IF @Result = 'LoginSuccess' AND @IsLocked = 1
    SET @Result = 'Locked';
    ELSE IF @LoginAttempts >= 10 
    SET @Result = 'TooManyAttempts';
    ELSE 

    -- Update login attempts, token, and last login IP
    IF @Result = 'LoginSuccess' 
    BEGIN
        UPDATE AccountTable SET LoginAttempts = 0, Token = @Token, LastLoginIP = @LastLoginIP, LastLogin = @Now WHERE (WindyCode = @Identifier OR Email = @Identifier);
    END
    ELSE IF @Result = 'InvalidCredentials' 
    BEGIN
        UPDATE AccountTable SET LoginAttempts = @LoginAttempts + 1, LastLogin = @Now WHERE (WindyCode = @Identifier OR Email = @Identifier);
    END

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SET @Result = 'TransactionFailed';
END CATCH

SELECT @Result as Result, @WindyCode as WindyCode, @AuthID as AuthID, @Token as Token;
END
GO


-- ----------------------------
-- procedure structure for SetAccountVerificationCode
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[SetAccountVerificationCode]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[SetAccountVerificationCode]
GO

CREATE PROCEDURE [dbo].[SetAccountVerificationCode]
    @VerificationCode varchar(10),
    @Email varchar(255),
		@ExpirationTime DATETIME
AS
BEGIN
    SET NOCOUNT ON;
		
		DECLARE @Result varchar(20)
    DECLARE @AccountExists int;
		DECLARE @VerificationCodeCount int;
		
		BEGIN TRY
		BEGIN TRANSACTION

    SELECT @AccountExists = COUNT(*) FROM AccountTable
    WHERE Email = @Email;


-- Check if account exists
         IF @AccountExists > 0
        SET @Result = 'AccountExists';
        ELSE 
        SET @Result = 'AccountDontExists';

    IF @Result = 'AccountDontExists' 
     -- Retrieve count of existing verification codes for the user
        SELECT @VerificationCodeCount = COUNT(*) FROM VerificationCode
        WHERE Email = @Email;

        -- Check if count of existing verification codes is less than 5
        IF @VerificationCodeCount < 5
        BEGIN
            -- Insert new verification code
            INSERT INTO VerificationCode (VerificationCode, Email, ExpirationTime, Type)
            VALUES (@VerificationCode, @Email, @ExpirationTime, 'Account');
            SET @Result = 'Success';
        END
        ELSE
        BEGIN
            -- Delete all existing verification codes for the user
            DELETE FROM VerificationCode WHERE Email = @Email;

            -- Insert new verification code
            INSERT INTO VerificationCode (VerificationCode, Email, ExpirationTime, Type)
            VALUES (@VerificationCode, @Email, @ExpirationTime, 'Account');
            SET @Result = 'Success';
        END;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
SET @Result = 'TransactionFailed';
END CATCH

SELECT @Result as Result;

END
GO


-- ----------------------------
-- Auto increment value for AccountTable
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[AccountTable]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table AccountTable
-- ----------------------------
ALTER TABLE [dbo].[AccountTable] ADD CONSTRAINT [PK__AccountT__349DA586E13EC640] PRIMARY KEY CLUSTERED ([AccountID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for BillingLog
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[BillingLog]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table BillingLog
-- ----------------------------
ALTER TABLE [dbo].[BillingLog] ADD CONSTRAINT [PK_BillingLog] PRIMARY KEY CLUSTERED ([bid])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for VerificationCode
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[VerificationCode]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table VerificationCode
-- ----------------------------
ALTER TABLE [dbo].[VerificationCode] ADD CONSTRAINT [PK__Password__3213E83FA2A48C58] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

