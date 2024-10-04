/*
 Navicat Premium Data Transfer

 Source Server         : RH VM
 Source Server Type    : SQL Server
 Source Server Version : 16001105
 Source Host           : 192.168.100.202:1433
 Source Catalog        : RustyHearts_Log
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001105
 File Encoding         : 65001

 Date: 12/12/2023 01:48:54
*/


-- ----------------------------
-- Table structure for Base_DungeonTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Base_DungeonTable]') AND type IN ('U'))
	DROP TABLE [dbo].[Base_DungeonTable]
GO

CREATE TABLE [dbo].[Base_DungeonTable] (
  [MapID] int  NOT NULL,
  [Name] nvarchar(20) COLLATE Chinese_PRC_CI_AS  NOT NULL
)
GO

ALTER TABLE [dbo].[Base_DungeonTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Base_DungeonTable
-- ----------------------------

-- ----------------------------
-- Table structure for Daily_World_Gold
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Daily_World_Gold]') AND type IN ('U'))
	DROP TABLE [dbo].[Daily_World_Gold]
GO

CREATE TABLE [dbo].[Daily_World_Gold] (
  [log_id] int  NOT NULL,
  [world_id] int  NOT NULL,
  [gold] bigint  NOT NULL,
  [storage_gold] bigint  NOT NULL,
  [date] datetime  NOT NULL
)
GO

ALTER TABLE [dbo].[Daily_World_Gold] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Daily_World_Gold
-- ----------------------------

-- ----------------------------
-- Table structure for R_Visit_Monthly_Table
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[R_Visit_Monthly_Table]') AND type IN ('U'))
	DROP TABLE [dbo].[R_Visit_Monthly_Table]
GO

CREATE TABLE [dbo].[R_Visit_Monthly_Table] (
  [auth_id] uniqueidentifier  NOT NULL,
  [date] datetime  NOT NULL,
  [r_visit_num] int  NOT NULL,
  [standard_date] datetime  NOT NULL,
  [is_use] tinyint  NOT NULL
)
GO

ALTER TABLE [dbo].[R_Visit_Monthly_Table] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of R_Visit_Monthly_Table
-- ----------------------------

-- ----------------------------
-- Table structure for R_Visit_Table
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[R_Visit_Table]') AND type IN ('U'))
	DROP TABLE [dbo].[R_Visit_Table]
GO

CREATE TABLE [dbo].[R_Visit_Table] (
  [auth_id] uniqueidentifier  NOT NULL,
  [date] datetime  NOT NULL,
  [r_visit_num] int  NOT NULL,
  [standard_date] datetime  NOT NULL,
  [is_use] tinyint  NOT NULL
)
GO

ALTER TABLE [dbo].[R_Visit_Table] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of R_Visit_Table
-- ----------------------------

-- ----------------------------
-- Table structure for Sanction_Log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Sanction_Log]') AND type IN ('U'))
	DROP TABLE [dbo].[Sanction_Log]
GO

CREATE TABLE [dbo].[Sanction_Log] (
  [log_type] tinyint  NOT NULL,
  [sanction_uid] uniqueidentifier  NOT NULL,
  [world_id] tinyint  NOT NULL,
  [bcust_id] nvarchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [item_uid] uniqueidentifier  NOT NULL,
  [character_id] uniqueidentifier  NOT NULL,
  [char_name] nvarchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [item_name] nvarchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [start_time] nvarchar(50) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [end_time] nvarchar(50) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [personnel] nvarchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [releaser] nvarchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [cause] nvarchar(50) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [comment] nvarchar(128) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [is_release] tinyint  NOT NULL,
  [reg_date] datetime  NOT NULL
)
GO

ALTER TABLE [dbo].[Sanction_Log] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Sanction_Log
-- ----------------------------

-- ----------------------------
-- procedure structure for Plan_DailyWorldSave
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Plan_DailyWorldSave]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Plan_DailyWorldSave]
GO

CREATE PROCEDURE [dbo].[Plan_DailyWorldSave]
	@world_id		int,
	@gold			bigint,
	@storage_gold	bigint,
	@entry_date		datetime
as
set nocount on

set xact_abort on
begin tran

insert into Daily_World_Gold(world_id, gold, storage_gold, date)
values(@world_id, @gold, @storage_gold, @entry_date)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for Plan_MCUSave
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Plan_MCUSave]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Plan_MCUSave]
GO

CREATE PROCEDURE [dbo].[Plan_MCUSave]
	@log_type		smallint, 
	@world_id		int,
	@user_num		int,	
	@entry_date		datetime
as
set nocount on

set xact_abort on
begin tran

exec Local_CreateMCUTable @entry_date

declare @br nvarchar(1500)

declare @year nvarchar(50)
declare @month nvarchar(50)
set @year	= convert(nvarchar, datepart(yy,@entry_date))
set @month	= convert(nvarchar, datepart(mm,@entry_date))

SET @br = 'insert into MCU_Log_'+@year+'_'+@month+'(log_type, world_id, user_num, date) values('
+''''+convert(nvarchar,		@log_type)+''''+','
+''''+convert(nvarchar,		@world_id)+''''+','
+''''+convert(nvarchar,		@user_num)+''''+','
+ '''' +convert(nvarchar,	@entry_date)+ '''' + ')'

EXEC(@br)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_insert_log_Account
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_Account]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_Account]
GO

CREATE PROCEDURE [dbo].[up_insert_log_Account]
	@C1 int,
	@C2 int,
	@C3 int,
	@AuthID [uniqueidentifier],
	@nam1 nvarchar(16),
	@CharID [uniqueidentifier],
	@name nvarchar(16),
	@S1  int,
	@S2  int,
	@S3  int,
	@S4  int,
	@S5  int,
	@S6  int
AS
GO


-- ----------------------------
-- procedure structure for up_insert_log_auction
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_auction]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_auction]
GO

CREATE PROCEDURE [dbo].[up_insert_log_auction]
	 @log_type				int	
	,@world_id				int	
	,@auth_id				uniqueidentifier	
	,@character_id			uniqueidentifier	
	,@character_name		nvarchar(16)	
	,@item_guid				uniqueidentifier	
	,@item_id				int	
	,@item_header			int	
	,@enchant_level			tinyint	
	,@item_active			int	
	,@socket_count			tinyint	
	,@remain_recon			tinyint	
	,@durability			int
	,@item_option1			int	
	,@item_option2			int	
	,@item_option3			int	
	,@item_option_value1    int
	,@item_option_value2    int
	,@item_option_value3    int
	,@item_socket_option1	int	
	,@item_socket_option2	int	
	,@item_socket_option3	int	
	,@item_socket_value1    int
	,@item_socket_value2    int
	,@item_socket_value3    int
	,@item_socket_color1	int	
	,@item_socket_color2	int	
	,@item_socket_color3	int	
	,@item_count			int	
	,@start_price			int
	,@before_price			int
	,@buy_price				int
	,@guarantee_price		int	
	,@commission			int	
	,@auction_period		int
	,@before_money			int	
	,@after_money			int	
	,@change_money			int	
	,@target_name			nvarchar(16)
	,@result	            int		
	

as begin	

set nocount on	
	-------------------------------------------------------
	
	begin
		exec RustyHearts_Log.dbo.up_SetAuction	@log_type				
												,@world_id				
												,@auth_id				
												,@character_id			
												,@character_name		
												,@item_guid				
												,@item_id				
												,@item_header			
												,@enchant_level			
												,@item_active			
												,@socket_count			
												,@remain_recon	
												,@durability		
												,@item_option1			
												,@item_option2			
												,@item_option3			
												,@item_option_value1    
												,@item_option_value2    
												,@item_option_value3    
												,@item_socket_option1	
												,@item_socket_option2	
												,@item_socket_option3	
												,@item_socket_value1    
												,@item_socket_value2    
												,@item_socket_value3    
												,@item_socket_color1	
												,@item_socket_color2	
												,@item_socket_color3	
												,@item_count			
												,@start_price			
												,@before_price			
												,@buy_price				
												,@guarantee_price		
												,@commission			
												,@auction_period
												,@before_money			
												,@after_money			
												,@change_money			
												,@target_name			
												,@result	            

	end

end

SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_auth_succeed
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_auth_succeed]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_auth_succeed]
GO

CREATE PROCEDURE [dbo].[up_insert_log_auth_succeed]
	@AuthID [uniqueidentifier],
	@server int,
	@real_ip varchar(16)
as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	declare @char_name nvarchar(30)
	declare @character_id [uniqueidentifier]
	set @bcust_id = ''
	set @char_name = ''
	set @character_id = '00000000-0000-0000-0000-000000000000'

	declare @sql nvarchar(max)
	
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetConnectionUV 4, @server, @AuthID, @bcust_id, 
				@character_id, @char_name, 0, @real_ip, 0, 0, 0, 0
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_channel_select]    Script Date: 04/08/2011 23:10:12 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_cashbuy
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_cashbuy]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_cashbuy]
GO

CREATE PROCEDURE [dbo].[up_insert_log_cashbuy]
 @log_type				int
,@auth_id				uniqueidentifier
,@product_id				uniqueidentifier
,@productcode				int
,@productcount				int
,@bcust_id				nvarchar(24)
,@character_name			nvarchar(16)
,@gift_recvname				nvarchar(16)
,@addopt1				int
,@addopt2				int
,@addopt3				int


as
begin	

set nocount on

	-------------------------------------------------------
	-- ??????? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetCashBuy 					 @log_type				
																,@auth_id				
																,@product_id				
																,@productcode		
																,@productcount				
																,@bcust_id			
																,@character_name
																,@gift_recvname		
																,@addopt1
																,@addopt2
																,@addopt3
																					

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_channel_select
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_channel_select]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_channel_select]
GO

CREATE PROCEDURE [dbo].[up_insert_log_channel_select]
	@AuthID [uniqueidentifier],
	@server int,
	@channelID int,
	@real_ip varchar(16)
as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	declare @char_name nvarchar(30)
	declare @character_id [uniqueidentifier]
	set @bcust_id = ''
	set @char_name = ''
	set @character_id = '00000000-0000-0000-0000-000000000000'

	declare @sql nvarchar(max)
	
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetConnectionUV 1, @server, @AuthID, @bcust_id, 
				@character_id, @char_name, @channelID, @real_ip, 0, 0, 0, 0
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_char_in]    Script Date: 04/08/2011 23:10:19 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_char_in
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_char_in]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_char_in]
GO

CREATE PROCEDURE [dbo].[up_insert_log_char_in]
	@AuthID [uniqueidentifier],
	@CharID [uniqueidentifier],
	@server int,
	@channelID int,
	@name nvarchar(16),
	@real_ip varchar(24),
	@inven_gold		 int,	
	@storage_gold	 int,	
	@character_level int,	
	@character_exp	 bigint
as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	set @bcust_id = ''

	declare @sql nvarchar(max)
	
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetConnectionUV 2, @server, @AuthID, @bcust_id, 
				@CharID, @name, @channelID, @real_ip, @inven_gold, @storage_gold, @character_level,	@character_exp
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_char_in_dungeon]    Script Date: 04/08/2011 23:10:25 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_char_in_dungeon
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_char_in_dungeon]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_char_in_dungeon]
GO

CREATE PROCEDURE [dbo].[up_insert_log_char_in_dungeon]
	@AuthID [uniqueidentifier],
	@CharID [uniqueidentifier],
	@server int,
	@channelID int,
	@name nvarchar(16),
	@real_ip varchar(24),
	@inven_gold		 int,	
	@storage_gold	 int,	
	@character_level int,	
	@character_exp	 bigint
as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	set @bcust_id = ''

	declare @sql nvarchar(max)
	
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetConnectionUV 190, @server, @AuthID, @bcust_id, 
				@CharID, @name, @channelID, @real_ip, @inven_gold, @storage_gold, @character_level,	@character_exp
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_character]    Script Date: 04/08/2011 23:11:42 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_character
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_character]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_character]
GO

CREATE PROCEDURE [dbo].[up_insert_log_character]
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@channelid				smallint
,@bcust_id				nvarchar(24)
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@character_class		int
,@character_Job			int
,@character_Level		int
,@guildpoint			int
,@character_count		int
,@b_character_name		nvarchar(16)
,@b_Job					int
,@b_Level				int


   as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	
	begin
		exec RustyHearts_Log.dbo.up_SetCharacter
																@log_type				
																,@world_id				
																,@auth_id				
																,@channelid		
																,@bcust_id				
																,@character_id			
																,@character_name		
																,@character_class		
																,@character_Job			
																,@character_Level		
																,@guildpoint			
																,@character_count		
																,@b_character_name		
																,@b_Job					
																,@b_Level				
																			

	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_dungeon]    Script Date: 04/08/2011 23:11:49 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_chat
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_chat]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_chat]
GO

CREATE PROCEDURE [dbo].[up_insert_log_chat]
 @log_type				int
,@world_id				int	
,@auth_id				uniqueidentifier
,@channel_group				int
,@channel_num				int
,@character_id				uniqueidentifier
,@bcust_id				nvarchar(16)
,@character_name			nvarchar(16)
,@chat_target				nvarchar(16)
,@chats					nvarchar(100)




as
begin	

set nocount on

	-------------------------------------------------------
	-- ??????? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetChat						 @log_type				
																,@world_id				
																,@auth_id				
																,@channel_group		
																,@channel_num
																,@bcust_id			
																,@character_id														
																,@character_name														
																,@chat_target														
																,@chats													
																			

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_connection
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_connection]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_connection]
GO

CREATE PROCEDURE [dbo].[up_insert_log_connection]
	@log_type		 smallint,
	@auth_id		 [uniqueidentifier], 
	@character_id	 [uniqueidentifier], 
	@world_id		 int, 
	@Gold  int,
	@character_name	 nvarchar(50), 
	@real_ip varchar(16),

	@Otherauth_id		 int, 
	@Otherbcust_id		 int, 
	@Other_id			  int, 
	@Otherch		 int,
	@bcust_id		 nvarchar(50)

as
GO


-- ----------------------------
-- procedure structure for up_insert_log_dungeon
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_dungeon]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_dungeon]
GO

CREATE PROCEDURE [dbo].[up_insert_log_dungeon]
	
	 @log_type			int	
	,@intance_id		[uniqueidentifier]	
	,@world_id			int	
	,@dungeonid			int	
	,@difficulty		tinyint	
	,@membercountstart	tinyint	
	,@death				tinyint	
	,@rebirth			tinyint	

as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetDungeon  @log_type, @intance_id, @world_id, @dungeonid, @difficulty, @membercountstart, @death, @rebirth
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_dungeon_clear]    Script Date: 04/08/2011 23:12:01 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_dungeon_clear
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_dungeon_clear]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_dungeon_clear]
GO

CREATE PROCEDURE [dbo].[up_insert_log_dungeon_clear]
	 @log_type			int	
	,@instance_id		uniqueidentifier	
	,@bcust_id			varchar(24)	
	,@character_id		uniqueidentifier	
	,@character_name	nvarchar(16)	
	,@character_class	int			
	,@character_level	int	
	,@membercountclear	tinyint	
	,@clearrank			nvarchar(4)	
	,@stylishpoint		smallint	
	,@hitcount			smallint	
	,@chain				smallint	
	,@killcount			smallint	
	,@cleartime			int	
	,@cardid			int	
	,@cardrewardid		int	
	,@cardrewardcount	int	
	,@addexp			int	
	,@death				tinyint	
	,@rebirth			smallint	
	,@replay			tinyint
	,@dungeonid			int	
	,@difficulty		int	
	,@playpoint			int

as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
			
	begin
		exec RustyHearts_Log.dbo.up_SetDungeonClear						@log_type			
																	   ,@instance_id		
																	   ,@bcust_id			
																	   ,@character_id		
																	   ,@character_name	
																	   ,@character_class	
																	   ,@character_level	
																	   ,@membercountclear	
																	   ,@clearrank			
																	   ,@stylishpoint		
																	   ,@hitcount			
																	   ,@chain				
																	   ,@killcount			
																	   ,@cleartime			
																	   ,@cardid			
																	   ,@cardrewardid		
																	   ,@cardrewardcount	
																	   ,@addexp			
																	   ,@death				
																	   ,@rebirth			
																	   ,@replay			
																	   ,@dungeonid
																	   ,@difficulty
																	   ,@playpoint


	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_gold]    Script Date: 04/08/2011 23:12:08 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_gold
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_gold]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_gold]
GO

CREATE PROCEDURE [dbo].[up_insert_log_gold]
	@server int,
    @date   datetime,
	@AuthID [uniqueidentifier],
	@CharID [uniqueidentifier],
	@Name nvarchar(16),
	@OtherAuthID [uniqueidentifier] = NULL,
	@OtherCharID [uniqueidentifier] = NULL,
	@OtherName nvarchar(16) = NULL,
	@Type smallint,
	@Gold_Prev int,
	@Gold_Change int,
	@Gold_After int,
	@N1 nvarchar(16),
	@N2 nvarchar(16)

as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30),
			@bcust_id2 nvarchar(30)
	set @bcust_id = ''
	set @bcust_id2 = ''

	declare @sql nvarchar(max)
	
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id
		
		if( @OtherAuthID <> '00000000-0000-0000-0000-000000000000' )
		begin
				set @sql = ' select top 1 @bcust_id2 = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@OtherAuthID)+''''''')'
										select @sql

				exec dbo.sp_executesql @sql, N'@bcust_id2 nvarchar(30) output', @bcust_id2 output
				select @bcust_id2

--				select top 1 @bcust_id2=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @OtherAuthID

		end
		
		exec RustyHearts_Log.dbo.up_SetGold @Type, @server, @AuthID, @bcust_id, @CharID, @Name,
			@OtherAuthID, @bcust_id2, @OtherCharID, @OtherName, @Gold_Prev, @Gold_Change, @Gold_After, @date

	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_guild]    Script Date: 04/08/2011 23:12:18 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_guild
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_guild]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_guild]
GO

CREATE PROCEDURE [dbo].[up_insert_log_guild]

	 @log_type                   int
	,@world_id                   int
	,@Guild_id					 [uniqueidentifier]	
	,@Guild_Name	             nvarchar(20)	
	,@Guild_Master	             nvarchar(16)
	,@Guild_MemberCount	         int	
	,@Guild_Level	             int	
	,@Guild_Exp	                 bigint	
	,@Guild_SkillCount	         smallint	
	,@Guild_Target	             nvarchar(16)
	,@Auth_Grade	             nvarchar(20)	
	,@Guild_Point	             int


as begin	

set nocount on

	
	begin
		begin
			exec RustyHearts_Log.dbo.up_Set_Guild_Log   @log_type          
																		 ,@world_id           
																		 ,@Guild_id			
																		 ,@Guild_Name	    
																		 ,@Guild_Master	    
																		 ,@Guild_MemberCount		
																		 ,@Guild_Level	    
																		 ,@Guild_Exp	            
																		 ,@Guild_SkillCount		
																		 ,@Guild_Target	    
																		 ,@Auth_Grade	    
																		 ,@Guild_Point	    
																		 
	    end	
	end

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_inquiry_chatting]    Script Date: 04/08/2011 23:12:24 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_inquiry_chatting
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_inquiry_chatting]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_inquiry_chatting]
GO

CREATE PROCEDURE [dbo].[up_insert_log_inquiry_chatting]
@world_id			int
,@inquiry_id		int	
,@chatting_number	int
,@sender			nvarchar(16)
,@chatting			nvarchar(255)

as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	
	begin
		exec RustyHearts_Log.dbo.up_SetInquiryChatting  
																	@world_id			
																	,@inquiry_id		
																	,@chatting_number	
																	,@sender			
																	,@chatting			

	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_inquiry_complete]    Script Date: 04/08/2011 23:12:33 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_inquiry_complete
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_inquiry_complete]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_inquiry_complete]
GO

CREATE PROCEDURE [dbo].[up_insert_log_inquiry_complete]
@log_id				int
,@log_type			int	
,@world_id			int
,@end_status		tinyint
,@start_status		tinyint
,@target_bcustno	nvarchar(16)
,@target_character	nvarchar(16)
,@GM				nvarchar(16)
,@former_GM			nvarchar(16)
,@remain_number		tinyint
,@inquery_use		nvarchar(1)
,@group_processing	nvarchar(1)
,@post_time			datetime
,@start_time		datetime

as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetInquiryComplete  
																		@world_id	
																		,@log_id		
																		,@log_type			
																		,@end_status		
																		,@start_status		
																		,@target_bcustno	
																		,@target_character	
																		,@GM				
																		,@former_GM			
																		,@remain_number		
																		,@inquery_use		
																		,@group_processing	
																		,@post_time			
																		,@start_time		

	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_item]    Script Date: 04/08/2011 23:12:40 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_item
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_item]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_item]
GO

CREATE PROCEDURE [dbo].[up_insert_log_item]
	 @log_type				int	
	,@world_id				int	
	,@auth_id				uniqueidentifier	
	,@bcust_id				nvarchar(24)	
	,@character_id			uniqueidentifier	
	,@character_name		nvarchar(16)	
	,@item_guid				uniqueidentifier	
	,@item_id				int	
	,@item_header			int	
	,@enchant_level			tinyint	
	,@item_active			int	
	,@socket_count			tinyint	
	,@remain_recon			tinyint	
	,@item_option1			int	
	,@item_option2			int	
	,@item_option3			int	
	,@item_count			int	
	,@target_itemid			int	
	,@before_money			int	
	,@after_money			int	
	,@change_money			int	
	,@result	            int		
	,@item_option_value1    int
	,@item_option_value2    int
	,@item_option_value3    int

	--,@value1    int
	--,@value2    int
	--,@value3    int
--	,@value4    int
--	,@value5    int
--	,@value6    int
--	,@value7    int
--	,@value8    int
--	,@value9    int
--	,@value10    int
	--,@value11    int
--	,@value1    int







as begin	

set nocount on	
	-------------------------------------------------------

	begin
		exec RustyHearts_Log.dbo.up_set_item_log  @log_type			
																   ,@world_id			
																   ,@auth_id			
																   ,@bcust_id			
																   ,@character_id		
																   ,@character_name	
																   ,@item_guid			
																   ,@item_id			
																   ,@item_header		
																   ,@enchant_level		
																   ,@item_active		
																   ,@socket_count		
																   ,@remain_recon		
																   ,@item_option1		
																   ,@item_option2		
																   ,@item_option3		
																   ,@item_count		
																   ,@target_itemid		
																   ,@before_money		
																   ,@after_money		
																   ,@change_money		
																   ,@result	        
																   ,@item_option_value1
																   ,@item_option_value2
																   ,@item_option_value3
	end

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_item_enchant]    Script Date: 04/08/2011 23:12:49 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_item_enchant
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_item_enchant]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_item_enchant]
GO

CREATE PROCEDURE [dbo].[up_insert_log_item_enchant]
	@server int,
    @date   datetime,
	@AuthID [uniqueidentifier],
	@CharID [uniqueidentifier],
	@Name nvarchar(16),
	@Type smallint,
	@ItemID [uniqueidentifier],
	@Item_kind  int,
	@enchant_level int,
	@flag tinyint,
	@fag nvarchar(50)--2022

as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)

	declare @sql nvarchar(max)

	set @bcust_id = ''
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID
		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetEnchanteItem @Type, @server, @AuthID, @bcust_id, @CharID, @Name,
			@ItemID, @Item_kind, @enchant_level, @flag
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_itemtrade]    Script Date: 04/08/2011 23:12:58 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_itemmail
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_itemmail]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_itemmail]
GO

CREATE PROCEDURE [dbo].[up_insert_log_itemmail]
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@item_guid				uniqueidentifier
,@item_ID				int
,@item_header			int
,@enchant_level			int
,@item_active			int
,@socket_count			tinyint
,@item_recon			tinyint
,@durability			int
,@item_option1			int
,@item_option2			int
,@item_option3			int
,@item_option_value1	int
,@item_option_value2	int
,@item_option_value3	int
,@item_socket_option1	int
,@item_socket_option2	int
,@item_socket_option3	int
,@item_socket_value1	int
,@item_socket_value2	int
,@item_socket_value3	int
,@item_socket_color1	int
,@item_socket_color2	int
,@item_socket_color3	int
,@item_count			int
,@before_money			int
,@after_money			int
,@change_money			int
,@target_name			nvarchar(16)
,@mail_type				int

   as
begin	

set nocount on
	begin
		exec RustyHearts_Log.dbo.up_SetItemMail
@log_type
,@world_id
,@auth_id
,@character_id
,@character_name
,@item_guid
,@item_ID
,@item_header
,@enchant_level
,@item_active
,@socket_count
,@item_recon
,@durability
,@item_option1
,@item_option2
,@item_option3
,@item_option_value1
,@item_option_value2
,@item_option_value3
,@item_socket_option1
,@item_socket_option2
,@item_socket_option3
,@item_socket_value1
,@item_socket_value2
,@item_socket_value3
,@item_socket_color1
,@item_socket_color2
,@item_socket_color3
,@item_count
,@before_money
,@after_money
,@change_money
,@target_name
,@mail_type

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_items
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_items]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_items]
GO

CREATE PROCEDURE [dbo].[up_insert_log_items]
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@item_guid				uniqueidentifier
,@item_ID				int
,@item_header			int
,@enchant_level			int
,@item_active			int
,@socket_count			tinyint
,@item_recon			tinyint
,@durability			int
,@item_option1			int
,@item_option2			int
,@item_option3			int
,@item_option_value1	int
,@item_option_value2	int
,@item_option_value3	int
,@item_socket_option1	int
,@item_socket_option2	int
,@item_socket_option3	int
,@item_socket_value1	int
,@item_socket_value2	int
,@item_socket_value3	int
,@item_socket_color1	int
,@item_socket_color2	int
,@item_socket_color3	int
,@item_count			int
,@before_money			int
,@after_money			int
,@change_money			int
,@before_date			int
,@after_date			int
,@result				int

,@value1    int


   as
begin	

set nocount on
	begin
		exec RustyHearts_Log.dbo.up_SetItems
@log_type
,@world_id
,@auth_id
,@character_id
,@character_name
,@item_guid
,@item_ID
,@item_header
,@enchant_level
,@item_active
,@socket_count
,@item_recon
,@durability
,@item_option1
,@item_option2
,@item_option3
,@item_option_value1
,@item_option_value2
,@item_option_value3
,@item_socket_option1
,@item_socket_option2
,@item_socket_option3
,@item_socket_value1
,@item_socket_value2
,@item_socket_value3
,@item_socket_color1
,@item_socket_color2
,@item_socket_color3
,@item_count
,@before_money
,@after_money
,@change_money
,@before_date
,@after_date
,@result

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_itemtrade
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_itemtrade]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_itemtrade]
GO

CREATE PROCEDURE [dbo].[up_insert_log_itemtrade]
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@bcust_id				nvarchar(16)	
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@other_auth_id			uniqueidentifier
,@other_bcust_id		nvarchar(16)
,@other_character_id	uniqueidentifier
,@other_character_name	nvarchar(16)
,@item_guid				uniqueidentifier
,@item_ID				int
,@item_header			int
,@enchant_level			int
,@item_active			int
,@socket_count			tinyint
,@item_recon			tinyint
,@durability			int
,@item_option1			int
,@item_option2			int
,@item_option3			int
,@item_option_value1	int
,@item_option_value2	int
,@item_option_value3	int
,@item_socket_option1	int
,@item_socket_option2	int
,@item_socket_option3	int
,@item_socket_value1	int
,@item_socket_value2	int
,@item_socket_value3	int
,@item_socket_color1	int
,@item_socket_color2	int
,@item_socket_color3	int
,@before_money			int
,@after_money			int
,@change_money			int
,@item_count			int

   as
begin	

set nocount on
	begin
		exec RustyHearts_Log.dbo.up_SetItemTrade
																@log_type				
																,@world_id				
																,@auth_id				
																,@bcust_id				
																,@character_id			
																,@character_name		
																,@other_auth_id			
																,@other_bcust_id		
																,@other_character_id	
																,@other_character_name	
																,@item_guid				
																,@item_ID				
																,@item_header			
																,@enchant_level			
																,@item_active			
																,@socket_count			
																,@item_recon	
																,@durability		
																,@item_option1			
																,@item_option2			
																,@item_option3	
																,@item_option_value1
																,@item_option_value2
																,@item_option_value3
																,@item_socket_option1
																,@item_socket_option2
																,@item_socket_option3
																,@item_socket_value1
																,@item_socket_value2
																,@item_socket_value3
																,@item_socket_color1
																,@item_socket_color2
																,@item_socket_color3
																,@before_money			
																,@after_money			
																,@change_money			
																,@item_count			

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_learnskill
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_learnskill]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_learnskill]
GO

CREATE PROCEDURE [dbo].[up_insert_log_learnskill]
 @log_type				int
,@character_id				uniqueidentifier
,@skill_table_id			int
,@skill_level				tinyint
,@character_class			int
,@character_level			tinyint
,@skillpoint_use			int
,@bcustid					nvarchar(16)
,@character_name			nvarchar(16)





as
begin	

set nocount on

	-------------------------------------------------------
	-- ??????? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetSkillLearn				 @log_type				
																,@character_id				
																,@skill_table_id				
																,@skill_level		
																,@character_class				
																,@character_level			
																,@skillpoint_use														
																,@bcustid			
																,@character_name					
																		

																			

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_level_up
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_level_up]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_level_up]
GO

CREATE PROCEDURE [dbo].[up_insert_log_level_up]
	@AuthID [uniqueidentifier],
	@CharID [uniqueidentifier],
	@ServerID  int,
	@Time datetime,
	@Class int,
	@Level smallint,
	@name nvarchar(16),
	@UI nvarchar(16)

as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	declare @sql nvarchar(max)

	set @bcust_id = ''
	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
--		select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetLevelUp 1, @ServerID, @AuthID, @bcust_id, 
				@CharID, @name, @Class, @Level, @Time
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_mcu]    Script Date: 04/08/2011 23:13:16 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_loginout
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_loginout]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_loginout]
GO

CREATE PROCEDURE [dbo].[up_insert_log_loginout]
 @log_type				int
,@world_id				int	
,@auth_id				uniqueidentifier
,@channel_group				tinyint
,@channel_num				int
,@bcust_id				nvarchar(16)
,@character_id				uniqueidentifier
,@character_name			nvarchar(16)
,@inven_gold				int
,@storage_gold				int
,@character_level			tinyint
,@character_exp				int
,@targetmap				int
,@playpoint				int
,@skillpoint				int
,@guildpoint				int
,@coin					int



as
begin	

set nocount on

	-------------------------------------------------------
	-- ??????? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetLoginOut							 @log_type				
																,@world_id				
																,@auth_id				
																,@channel_group		
																,@channel_num				
																,@bcust_id			
																,@character_id														
																,@character_name														
																,@inven_gold														
																,@storage_gold														
																,@character_level														
																,@character_exp														
																,@targetmap														
																,@playpoint														
																,@skillpoint														
																,@guildpoint														
																,@coin														

																			

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_mail
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_mail]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_mail]
GO

CREATE PROCEDURE [dbo].[up_insert_log_mail]
 @log_type				int
,@world_id				int	
,@auth_id				uniqueidentifier
,@channel_group				tinyint
,@channel_num				int
,@mail_id				uniqueidentifier
,@bcust_id				nvarchar(16)
,@character_id				uniqueidentifier
,@character_name			nvarchar(16)
,@receiver_name				nvarchar(16)
,@msg					nvarchar(50)
,@return_day				int
,@req_gold				int



as
begin	

set nocount on

	-------------------------------------------------------
	-- ??????? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetMail								 @log_type				
																,@world_id				
																,@auth_id				
																,@channel_group		
																,@channel_num
																,@mail_id				
																,@bcust_id			
																,@character_id														
																,@character_name														
																,@receiver_name														
																,@msg														
																,@return_day
																,@req_gold											
			
																			

	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_insert_log_mcu
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_mcu]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_mcu]
GO

CREATE PROCEDURE [dbo].[up_insert_log_mcu]
	@world_id int,
	@MCU int

as begin	

set nocount on

	begin
		declare @cur_date datetime
		set @cur_date = getdate()

		begin
			exec RustyHearts_Log.dbo.Plan_MCUSave 1, @world_id, @MCU, @cur_date
		end
	end

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_monitor_command]    Script Date: 04/08/2011 23:13:24 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_monitor_command
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_monitor_command]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_monitor_command]
GO

CREATE PROCEDURE [dbo].[up_insert_log_monitor_command]
@log_type			int
,@world_id			int
,@server_type		int
,@gm_id				nvarchar(16)
,@command			int
,@server_code		int


as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???

	begin
		exec RustyHearts_Log.dbo.up_SetMonitorCommand
																@log_type			
																,@world_id			
																,@server_type		
																,@gm_id				
																,@command			
																,@server_code		
																
	end

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_monitor_notice]    Script Date: 04/08/2011 23:13:31 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_monitor_notice
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_monitor_notice]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_monitor_notice]
GO

CREATE PROCEDURE [dbo].[up_insert_log_monitor_notice]
@log_type		int
,@world_id		int
,@target		int	
,@notice_type	tinyint
,@notice_cycle	tinyint
,@notice		nvarchar(255)	
,@gm_ID			nvarchar(16)


as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	
	begin
		exec RustyHearts_Log.dbo.up_SetMonitorNotice
																@log_type		
																,@world_id		
																,@target		
																,@notice_type	
																,@notice_cycle	
																,@notice		
																,@gm_ID	
	end

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_monitor_user]    Script Date: 04/08/2011 23:13:40 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_monitor_user
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_monitor_user]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_monitor_user]
GO

CREATE PROCEDURE [dbo].[up_insert_log_monitor_user]
@log_type		int
,@world_id		int
,@gate			int
,@lobby			int
,@dungeon		int
,@pvp			int
,@total			int


as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetMonitorUser		@log_type
														,@world_id
														,@gate
														,@lobby
														,@dungeon
														,@pvp
														,@total

																				
																			

	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_packet_overload]    Script Date: 04/08/2011 23:13:49 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_packet_overload
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_packet_overload]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_packet_overload]
GO

CREATE PROCEDURE [dbo].[up_insert_log_packet_overload]
	@func_name char(100),
	@time int
as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	begin
		exec RustyHearts_Log.dbo.up_SetPacketOverload @func_name, @time
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_play_time]    Script Date: 04/08/2011 23:14:00 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_pet
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_pet]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_pet]
GO

CREATE PROCEDURE [dbo].[up_insert_log_pet]
	@C1 int,
	@C2 int,
	@AuthID [uniqueidentifier],
	@nam1 nvarchar(16),
	@CharID [uniqueidentifier],
	@name nvarchar(16),
	@petID [uniqueidentifier],
	@petname nvarchar(16),
	@S1  int,
	@S2  int,
	@S3  int,
	@S4  int,
	@S5  int,
	@S6  int,
	@S7  int,
	@S8  int,
	@S9  int,
	@S10  int,
	@S11  int,
	@S12  int,
	@S13  int,
	@S14  int,
	@S15  int,
	@S16  int,
	@S17  int,
	@S18  int,
	@S19  int,
	@S20  int,
	@S21  int,
	@S22  int,
	@S23  int,
	@S24  int,
	@S25  int,
	@S26  int,
	@S27  int,
	@S28  int,
	@S29  int,
	@S30  int,
	@S31  int,
	@S32  int,
	@S33  int,
	@S34  int,
	@S35  int,
	@S36  int,
	@S37  int,
	@S38  int,
	@S39  int,
	@S40  int,
	@S41  int
AS
GO


-- ----------------------------
-- procedure structure for up_insert_log_play_time
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_play_time]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_play_time]
GO

CREATE PROCEDURE [dbo].[up_insert_log_play_time]
	@aa  int,
	@server int,
	@bb  int,
	@AuthID [uniqueidentifier],
	@nam1 nvarchar(16),
	@CharID [uniqueidentifier],
	@nam nvarchar(16),	
	@class   int,
	@level   smallint,
	@StartTime datetime,	
	@EndTime datetime	

as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	declare @char_name nvarchar(30)
	declare @character_id [uniqueidentifier]
	declare @sql nvarchar(max)

	set @bcust_id = ''
	set @char_name = ''
	set @character_id = @CharID



	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
		--select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetPlayTime 1, @server, @AuthID, @bcust_id, 
				@character_id, @char_name, @class, @level, 1, @StartTime, @EndTime
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_pvp_battle]    Script Date: 04/08/2011 23:14:08 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_play_time_copy
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_play_time_copy]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_play_time_copy]
GO

CREATE PROCEDURE [dbo].[up_insert_log_play_time_copy]
	@AuthID [uniqueidentifier],
	@CharID [uniqueidentifier],
	@server int,
	@StartTime datetime,	
	@EndTime datetime,	
	@class   int,
	@level   smallint

as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	declare @char_name nvarchar(30)
	declare @character_id [uniqueidentifier]
	declare @sql nvarchar(max)

	set @bcust_id = ''
	set @char_name = ''
	set @character_id = @CharID



	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql

	begin
		--select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetPlayTime 1, @server, @AuthID, @bcust_id, 
				@character_id, @char_name, @class, @level, 1, @StartTime, @EndTime
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_pvp_battle]    Script Date: 04/08/2011 23:14:08 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_pvp_battle
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_pvp_battle]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_pvp_battle]
GO

CREATE PROCEDURE [dbo].[up_insert_log_pvp_battle]
	@log_type				smallint,
	@auth_id				uniqueidentifier,
	@character_id			uniqueidentifier,
	@character_name			nvarchar(16),
	@character_class		int,
	@character_level		int,
	@channel_type			int,
	@room_id				uniqueidentifier,
	@room_world				int,
	@room_type				int,
	@red_leader_id			uniqueidentifier,
	@red_leader_name		nvarchar(16),
	@red_name1				nvarchar(16),
	@red_name2				nvarchar(16),
	@red_name3				nvarchar(16),
	@red_name4				nvarchar(16),
	@red_kill_count			smallint,
	@red_total_damage		int,
	@blue_leader_id			uniqueidentifier,
	@blue_leader_name		nvarchar(16),
	@blue_name1				nvarchar(16),
	@blue_name2				nvarchar(16),
	@blue_name3				nvarchar(16),
	@blue_name4				nvarchar(16),
	@blue_kill_count		smallint,
	@blue_total_damage		int,
	@user_start_count		smallint,
	@user_end_count			smallint,
	@win_character_name		nvarchar(16),
	@win_team				smallint,
	@clear_time				int,
	@clear				int --2022

   as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(50)
	declare @sql nvarchar(max)

	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@auth_id)+''''''')'
										select @sql
	begin
		--select @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @auth_id

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetPvpBattle 
@log_type, @bcust_id, @character_id, @character_name, @character_class, @character_level,
@channel_type, @room_id, @room_world, @room_type, @red_leader_id, @red_leader_name,
@red_name1, @red_name2, @red_name3, @red_name4, @red_kill_count, @red_total_damage, 
@blue_leader_id, @blue_leader_name, @blue_name1, @blue_name2, @blue_name3, @blue_name4, 
@blue_kill_count, @blue_total_damage, @user_start_count, @user_end_count, @win_character_name, 
@win_team, @clear_time
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_pvp_death]    Script Date: 04/08/2011 23:14:21 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_pvp_death
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_pvp_death]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_pvp_death]
GO

CREATE PROCEDURE [dbo].[up_insert_log_pvp_death]
	@log_type				smallint,
	@room_id				uniqueidentifier,
	@character_id			uniqueidentifier,
	@character_name			nvarchar(16),
	@character_class		int,
	@character_job			tinyint,
	@character_level		int,
	@kill_id				uniqueidentifier,
	@kill_name				nvarchar(16),
	@kill_class				int,
	@kill_job				tinyint,
	@kill_level				int

   as
begin	

set nocount on

-------------------------------------------------------
-- ?? ?? ?? DB? ???

	begin
		exec RustyHearts_Log.dbo.up_SetPvpDeath
									@log_type, @room_id
									, @character_id, @character_name, @character_class, @character_job, @character_level
									, @kill_id, @kill_name, @kill_class, @kill_job, @kill_level
	end
-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_pvp_result]    Script Date: 04/08/2011 23:14:29 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_pvp_ladder
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_pvp_ladder]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_pvp_ladder]
GO

CREATE PROCEDURE [dbo].[up_insert_log_pvp_ladder]
AS
GO


-- ----------------------------
-- procedure structure for up_insert_log_pvp_result
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_pvp_result]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_pvp_result]
GO

CREATE PROCEDURE [dbo].[up_insert_log_pvp_result]
	@log_type			smallint,
	@auth_id			uniqueidentifier,
	@character_id		uniqueidentifier,
	@character_name		nvarchar(16),
	@character_class	int,
	@character_level	int,
	@channel_type		int,
	@room_id			uniqueidentifier,
	@room_world			int,
	@room_type			int,
	@room_map			int,
	@pvp_team			smallint,
	@pvp_score			int,
	@pvp_point			int,
	@pvp_grade			int,
	@pvp_totalscore		int,
	@pvp_totalpoint		int,
	@pvp_rank			int,
	@pvp_kill			int,
	@pvp_die			int,
	@pvp_damage			int,
	@pvp_cleartime		int,
	@pvp_run			int--2022
   as
begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(50)
	declare @sql nvarchar(max)

	set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@auth_id)+''''''')'
										select @sql

	begin
		--select @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @auth_id

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_Log.dbo.up_SetPvpResult @log_type, @auth_id, @bcust_id, @character_id, @character_name, @character_class, @character_level, @channel_type, @room_id, @room_world, @room_type, @room_map, @pvp_team, @pvp_score, @pvp_point, @pvp_grade, @pvp_totalscore, @pvp_totalpoint, @pvp_rank, @pvp_kill, @pvp_die, @pvp_damage, @pvp_cleartime
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_pvp_room]    Script Date: 04/08/2011 23:14:41 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_pvp_room
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_pvp_room]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_pvp_room]
GO

CREATE PROCEDURE [dbo].[up_insert_log_pvp_room]
	@log_type			smallint,
	@auth_id			uniqueidentifier,
	@character_id		uniqueidentifier,
	@character_name		nvarchar(16),
	@channel_type		int,
	@room_id			uniqueidentifier,
	@room_world			int,
	@room_number		int,
	@room_name			nvarchar(50)

   as begin	

set nocount on

	begin
		exec RustyHearts_Log.dbo.up_SetPvpRoom @log_type, @auth_id, @character_id, @character_name, @channel_type, @room_id, @room_world, @room_number, @room_name
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_quest]    Script Date: 04/08/2011 23:14:52 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_quest
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_quest]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_quest]
GO

CREATE PROCEDURE [dbo].[up_insert_log_quest]

		 @log_type			int	
		,@world_id			int	
		,@auth_id			[uniqueidentifier]	
		,@channel_id		smallint	
		,@bcust_id			nvarchar(24)	
		,@character_id		[uniqueidentifier]	
		,@character_name	nvarchar(16)	
		,@character_class	int	
		,@character_job		tinyint	
		,@character_level	tinyint	
		,@quest_id			int	
		,@quest_type		int	
		,@quest_exp			int	


as begin	

set nocount on

	begin
		begin
			exec RustyHearts_Log.dbo.up_Set_Quest_Log   @log_type			
																		 ,@world_id			 
																		 ,@auth_id			
																		 ,@channel_id		
																		 ,@bcust_id			
																		 ,@character_id			
																		 ,@character_name	
																		 ,@character_class	    
																		 ,@character_job		
																		 ,@character_level	
																		 ,@quest_id			
																		 ,@quest_type		
																		 ,@quest_exp	
	    end	
	end

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_server_select]    Script Date: 04/08/2011 23:15:02 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_insert_log_server_select
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_server_select]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_server_select]
GO

CREATE PROCEDURE [dbo].[up_insert_log_server_select]
	@AuthID [uniqueidentifier],
	@server int
as begin	

set nocount on

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @bcust_id nvarchar(30)
	declare @char_name nvarchar(30)
	declare @character_id [uniqueidentifier]
	declare @sql nvarchar(max)

	set @bcust_id = ''
	set @char_name = ''
	set @character_id = '00000000-0000-0000-0000-000000000000'

		set @sql = ' select top 1 @bcust_id = WindyCode from openquery([RustyHeartsLinkAuth]
									, ''select top 1 WindyCode
										from [RustyHearts_Auth].[dbo].[AuthTable] 
										where AuthID = '''''+convert(varchar(255),@AuthID)+''''''')'
										select @sql


	begin
		--select top 1 @bcust_id=WindyCode from [RustyHeartsLinkAuth].[berRustyHeartsAuth].[dbo].[AuthTable] where AuthID = @AuthID
	

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(30) output', @bcust_id output
		select @bcust_id		

		exec RustyHearts_Log.dbo.up_SetConnectionUV 1, @server, @AuthID, @bcust_id, 
				@character_id, @char_name, 1, '', 0, 0, 0, 0
	end
	-------------------------------------------------------

end

/****** Object:  StoredProcedure [dbo].[up_insert_log_skill_learn]    Script Date: 04/08/2011 23:15:10 ******/
SET ANSI_NULLS ON
GO


-- ----------------------------
-- procedure structure for up_LogOut
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_LogOut]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_LogOut]
GO

CREATE PROCEDURE [dbo].[up_LogOut]
	@log_type		smallint,
	@world_id		int, 
	@auth_id		[uniqueidentifier], 
	@bcust_id		nvarchar(50), 
	@character_id	[uniqueidentifier], 
	@character_name	nvarchar(50), 
	@ChannelID		int,	
	@IP				char(16),
	@inven_gold		 int,	
	@storage_gold	 int,	
	@character_level int,	
	@character_exp	 bigint
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

-- Logout_Log ??? ??
exec Local_CreateLogoutLogTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id


 SET @updatesql ='insert into Logout_Log_'+ @year+'_'
	     +@month+'(log_type, world_id, auth_id, bcust_id, character_id, character_name, ChannelID, IP, date, inven_gold, storage_gold, character_level, character_exp) 
	      values (' 
	      + '''' +convert(nvarchar, @log_type) + '''' + ',' 
	      + '''' +convert(nvarchar, @world_id) + '''' + ',' 
	      + '''' +@char_auth_id + '''' + ','  
	      + '''' +@bcust_id+ '''' + ',' 
	      + '''' +@char_character_id+ '''' + ',' 
	      + '''' +@character_name+ '''' + ',' 
	      + '''' +convert(nvarchar, @ChannelID)+ '''' + ',' 
	      + '''' +@IP+ '''' + ',' 
	      + '''' +convert(nvarchar, @createtime)+ '''' + ',' 
	      + '''' +convert(nvarchar, @inven_gold)+ '''' + ','
	      + '''' +convert(nvarchar, @storage_gold)+ '''' + ','
	      + '''' +convert(nvarchar, @character_level)+ '''' + ','
	      + '''' +convert(nvarchar, @character_exp)+ '''' + ')'   
	     EXEC(@updatesql)
	if(@@error <> 0)
	begin
		rollback
		return
	end

	commit
GO


-- ----------------------------
-- procedure structure for up_save_logout
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_logout]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_logout]
GO

CREATE PROCEDURE [dbo].[up_save_logout]
	@auth_id uniqueidentifier,
	@CharID [uniqueidentifier],
	@server int,
	@channelID int,
	@name nvarchar(16),
	@real_ip varchar(16),
	@inven_gold		 int,	
	@storage_gold	 int,	
	@character_level int,	
	@character_exp	 bigint,
	@log_type 	    smallint

as begin
set nocount on

	declare @last_time datetime
	declare @bcust_id nvarchar(30)
	set @bcust_id = ''

	select @bcust_id=WindyCode, @last_time = BTime from AuthTable with (READUNCOMMITTED) where AuthID = @auth_id

	update AuthTable set world_id=0, [online] = '0', [BTime] = GETDATE(), [LTime] = @last_time from AuthTable where AuthID = @auth_id

	-------------------------------------------------------
	-- ?? ?? ?? DB? ???
	declare @srvname nvarchar(128)
	declare @srvid	smallint

	set @srvid = -1
	SELECT @srvid = srvid FROM master.dbo.sysservers where srvname = 'RustyHearts_LogDB'
	if(@srvid <> -1)
	begin
		exec RustyHearts_LogDB.RustyHearts_Log.dbo.up_LogOut @log_type, @server, @auth_id, @bcust_id, 
				@CharID, @name, @channelID, @real_ip, @inven_gold, @storage_gold, @character_level, @character_exp
	end
	-------------------------------------------------------
end
return @@error
GO


-- ----------------------------
-- procedure structure for up_save_logout_log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_logout_log]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_logout_log]
GO

CREATE PROCEDURE [dbo].[up_save_logout_log]
	@auth_id uniqueidentifier,
	@CharID [uniqueidentifier],
	@server int,
	@channelID int,
	@name nvarchar(16),
	@real_ip varchar(16),
	@inven_gold		 int,	
	@storage_gold	 int,	
	@character_level int,	
	@character_exp	 bigint,
	@log_type 	    smallint,
	@bcust_id nvarchar(30)

as begin
set nocount on

	begin
	exec dbo.up_LogOut			@log_type, 
												@server, 
												@auth_id, 
												@bcust_id, 
												@CharID, 
												@name, 
												@channelID, 
												@real_ip, 
												@inven_gold, 
												@storage_gold, 
												@character_level, 
												@character_exp
	end
	-------------------------------------------------------
end
return @@error
GO


-- ----------------------------
-- procedure structure for up_Set_Guild_Log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_Set_Guild_Log]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_Set_Guild_Log]
GO

CREATE PROCEDURE [dbo].[up_Set_Guild_Log]
	
	 @log_type                   int
	,@world_id                   int
	,@Guild_id					 [uniqueidentifier]	
	,@Guild_Name	             nvarchar(20)	
	,@Guild_Master	             nvarchar(16)
	,@Guild_MemberCount	         int	
	,@Guild_Level	             int	
	,@Guild_Exp	                 bigint	
	,@Guild_SkillCount	         smallint	
	,@Guild_Target	             nvarchar(16)
	,@Auth_Grade	             nvarchar(20)	
	,@Guild_Point	             int	

as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_guild_id nvarchar(50)

-- Login_Log ??? ??
exec Local_CreateGuildTable @createtime

set @char_guild_id = @Guild_id

SET	 @updatesql  = 'INSERT INTO tbl_guild_log_' + @year + '_' + @month + '(  date
																			 ,log_type          
																			 ,world_id          
																			 ,Guild_id			
																			 ,Guild_Name	    
																			 ,Guild_Master	    
																			 ,Guild_Member_Count	
																			 ,Guild_Level	    
																			 ,Guild_Exp	        
																			 ,Guild_Skill_Count	
																			 ,Guild_Target	    
																			 ,Auth_Grade
																			 ,Guild_Point)										
																			 VALUES ('
																			  + '''' +convert(nvarchar, @createtime) + '''' + ',' 
																			  + '''' +convert(nvarchar, @log_type) + '''' + ',' 
																			  + '''' +convert(nvarchar, @world_id) + '''' + ','  
																			  + '''' +@char_guild_id+ '''' + ',' 
																			  + '''' +@Guild_Name+ '''' + ',' 
																			  + '''' +convert(nvarchar, @Guild_Master)+ '''' + ',' 
																			  + '''' +convert(nvarchar, @Guild_MemberCount)+ '''' + ',' 
																			  + '''' +convert(nvarchar, @Guild_Level)+ '''' + ',' 
																			  + '''' +convert(nvarchar, @Guild_Exp)+ '''' + ','  
																			  + '''' +convert(nvarchar, @Guild_SkillCount)+ '''' +',' 
																			  + '''' +convert(nvarchar, @Guild_Target)+ '''' +',' 
																			  + '''' +convert(nvarchar, @Auth_Grade)+ '''' +',' 
 																			  + '''' +convert(nvarchar, @Guild_Point)+ '''' + ')'   

EXEC(@updatesql)


if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_set_item_log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_set_item_log]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_set_item_log]
GO

CREATE PROCEDURE [dbo].[up_set_item_log]	
	 @log_type				int	
	,@world_id				int	
	,@auth_id				uniqueidentifier	
	,@bcust_id				nvarchar(24)	
	,@character_id			uniqueidentifier	
	,@character_name		nvarchar(16)	
	,@item_guid				uniqueidentifier	
	,@item_id				int	
	,@item_header			int	
	,@enchant_level			tinyint	
	,@item_active			int	
	,@socket_count			tinyint	
	,@remain_recon			tinyint	
	,@item_option1			int	
	,@item_option2			int	
	,@item_option3			int	
	,@item_count			int	
	,@target_itemid			int	
	,@before_money			int	
	,@after_money			int	
	,@change_money			int	
	,@result	            int		
	,@item_option_value1    int
	,@item_option_value2    int
	,@item_option_value3    int
as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_item_id		nvarchar(50)


exec Local_CreateItemTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id
set @char_item_id = @item_guid

SET	 @updatesql  = 'INSERT INTO Item_Log_' + @year + '_' + @month + '(   log_type	    
																		,world_id	    
																		,auth_id	    
																		,bcust_id	    
																		,character_id	
																		,character_name
																		,item_guid	    
																		,item_id	    
																		,item_header	
																		,enchant_level	
																		,item_active	
																		,socket_count	
																		,remain_recon	
																		,item_option1	
																		,item_option2	
																		,item_option3	
																		,item_count	
																		,target_itemid	
																		,before_money	
																		,after_money	
																		,change_money	
																		,result	 
																		,item_option_value1 
																		,item_option_value2 
																		,item_option_value3)										
																	   VALUES ('
																	    + '''' +convert(nvarchar,@log_type) + '''' + ','	    
																		+ '''' +convert(nvarchar,@world_id) + '''' + ','	    
																		+ '''' +@char_auth_id+ '''' + ','	    
																		+ '''' +@bcust_id + '''' + ','	    
																		+ '''' +@char_character_id + '''' + ','	
																		+ '''' +@character_name+ '''' + ','
																		+ '''' +@char_item_id + '''' + ','	    
																		+ '''' +convert(nvarchar,@item_id) + '''' + ','	    
																		+ '''' +convert(nvarchar,@item_header) + '''' + ','	
																		+ '''' +convert(nvarchar,@enchant_level) + '''' + ','	
																		+ '''' +convert(nvarchar,@item_active) + '''' + ','	
																		+ '''' +convert(nvarchar,@socket_count) + '''' + ','	
																		+ '''' +convert(nvarchar,@remain_recon) + '''' + ','	
																		+ '''' +convert(nvarchar,@item_option1) + '''' + ','	
																		+ '''' +convert(nvarchar,@item_option2) + '''' + ','	
																		+ '''' +convert(nvarchar,@item_option3) + '''' + ','	
																		+ '''' +convert(nvarchar,@item_count) + '''' + ','	
																		+ '''' +convert(nvarchar,@target_itemid) + '''' + ','	
																		+ '''' +convert(nvarchar,@before_money) + '''' + ','	
																		+ '''' +convert(nvarchar,@after_money) + '''' + ','	
																		+ '''' +convert(nvarchar,@change_money) + '''' + ','	
																		+ '''' +convert(nvarchar,@result) + '''' + ','	 
																		+ '''' +convert(nvarchar,@item_option_value1) + '''' + ',' 
																		+ '''' +convert(nvarchar,@item_option_value2) + '''' + ',' 
																		+ '''' +convert(nvarchar,@item_option_value3) + '''' + ')'


EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_Set_Quest_Log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_Set_Quest_Log]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_Set_Quest_Log]
GO

CREATE PROCEDURE [dbo].[up_Set_Quest_Log]
	
		 @log_type			int	
		,@world_id			int	
		,@auth_id			[uniqueidentifier]	
		,@channel_id		smallint	
		,@bcust_id			nvarchar(24)	
		,@character_id		[uniqueidentifier]	
		,@character_name	nvarchar(16)	
		,@character_class	int	
		,@character_job		tinyint	
		,@character_level	tinyint	
		,@quest_id			int	
		,@quest_type		int	
		,@quest_exp			int	


as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

declare @updatesql nvarchar(2500)


-- Login_Log ??? ??
exec Local_CreateQuestTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id

	SET	 @updatesql  = 'INSERT INTO Quest_log_' + @year + '_' + @month + '( log_type			
																			,world_id			
																			,auth_id			
																			,channel_id		
																			,bcust_id			
																			,character_id		
																			,character_name	
																			,character_class	
																			,character_job		
																			,character_level	
																			,quest_id			
																			,quest_type		
																			,quest_exp)										
																			 VALUES ('
																		    + '''' +convert(nvarchar,@log_type) + '''' + ','			
																			+ '''' +convert(nvarchar,@world_id) + '''' + ','			
																			+ '''' +@char_auth_id + '''' + ','			
																			+ '''' +convert(nvarchar,@channel_id) + '''' + ','		
																			+ '''' +@bcust_id + '''' + ','			
																			+ '''' +@char_character_id + '''' + ','		
																			+ '''' +@character_name + '''' + ','	
																			+ '''' +convert(nvarchar,@character_class) + '''' + ','	
																			+ '''' +convert(nvarchar,@character_job) + '''' + ','		
																			+ '''' +convert(nvarchar,@character_level) + '''' + ','	
																			+ '''' +convert(nvarchar,@quest_id) + '''' + ','			
																			+ '''' +convert(nvarchar,@quest_type) + '''' + ','		
																			+ '''' +convert(nvarchar,@quest_exp)+ '''' + ')'   


EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetAuction
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetAuction]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetAuction]
GO

CREATE PROCEDURE [dbo].[up_SetAuction]	
	@log_type				int	
	,@world_id				int	
	,@auth_id				uniqueidentifier	
	,@character_id			uniqueidentifier	
	,@character_name		nvarchar(16)	
	,@item_guid				uniqueidentifier	
	,@item_id				int	
	,@item_header			int	
	,@enchant_level			tinyint	
	,@item_active			int	
	,@socket_count			tinyint	
	,@remain_recon			tinyint	
	,@durability			int
	,@item_option1			int	
	,@item_option2			int	
	,@item_option3			int	
	,@item_option_value1    int
	,@item_option_value2    int
	,@item_option_value3    int
	,@item_socket_option1	int	
	,@item_socket_option2	int	
	,@item_socket_option3	int	
	,@item_socket_value1    int
	,@item_socket_value2    int
	,@item_socket_value3    int
	,@item_socket_color1	int	
	,@item_socket_color2	int	
	,@item_socket_color3	int	
	,@item_count			int	
	,@start_price			int
	,@before_price			int
	,@buy_price				int
	,@guarantee_price		int	
	,@commission			int	
	,@auction_period		int
	,@before_money			int	
	,@after_money			int	
	,@change_money			int	
	,@target_name			nvarchar(16)
	,@result	            int	

as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_item_id		nvarchar(50)

set @char_auth_id		= @auth_id
set @char_character_id	= @character_id
set @char_item_id		= @item_guid

exec Local_CreateAuctionTable @createtime

SET	 @updatesql  = 'insert into Auction_Log_' + @year + '_' + @month + '(log_type
																		,world_id
																		,auth_id
																		,character_id
																		,character_name
																		,item_guid
																		,item_id
																		,item_header
																		,enchant_level
																		,item_active
																		,socket_count
																		,remain_recon
																		,durability
																		,item_option1
																		,item_option2
																		,item_option3
																		,item_option_value1
																		,item_option_value2
																		,item_option_value3
																		,item_socket_option1
																		,item_socket_option2
																		,item_socket_option3
																		,item_socket_value1	
																		,item_socket_value2	
																		,item_socket_value3	
																		,item_socket_color1	
																		,item_socket_color2	
																		,item_socket_color3	
																		,item_count			
																		,start_price		
																		,before_price		
																		,buy_price			
																		,guarantee_price	
																		,commission			
																		,auction_period
																		,before_money		
																		,after_money		
																		,change_money		
																		,target_name		
																		,result		)									
																	   VALUES ('
																	    + '''' +convert(nvarchar,@log_type)			+ '''' + ','
																		+ '''' +convert(nvarchar,@world_id)			+ '''' + ','
																		+ '''' +@char_auth_id					 	+ '''' + ','
																		+ '''' +@char_character_id				 	+ '''' + ','
																		+ '''' +@character_name					 	+ '''' + ','
																		+ '''' +@char_item_id						+ '''' + ','
																		+ '''' +convert(nvarchar,@item_id)			+ '''' + ','
																		+ '''' +convert(nvarchar,@item_header)		+ '''' + ','
																		+ '''' +convert(nvarchar,@enchant_level)	+ '''' + ','
																		+ '''' +convert(nvarchar,@item_active)		+ '''' + ','
																		+ '''' +convert(nvarchar,@socket_count)		+ '''' + ','
																		+ '''' +convert(nvarchar,@remain_recon)		+ '''' + ','
																		+ '''' +convert(nvarchar,@durability)		+ '''' + ','
																		+ '''' +convert(nvarchar,@item_option1)		+ '''' + ','
																		+ '''' +convert(nvarchar,@item_option2)		+ '''' + ','
																		+ '''' +convert(nvarchar,@item_option3)		+ '''' + ','
																		+ '''' +convert(nvarchar,@item_option_value1)+ '''' + ','
																		+ '''' +convert(nvarchar,@item_option_value2)+ '''' + ','
																		+ '''' +convert(nvarchar,@item_option_value3)+ '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_option1)+ '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_option2)+ '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_option3)+ '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_value1) + '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_value2) + '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_value3) + '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_color1) + '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_color2) + '''' + ','
																		+ '''' +convert(nvarchar,@item_socket_color3) + '''' + ','
																		+ '''' +convert(nvarchar,@item_count)		  + '''' + ','
																		+ '''' +convert(nvarchar,@start_price)		  + '''' + ','
																		+ '''' +convert(nvarchar,@before_price)		  + '''' + ','
																		+ '''' +convert(nvarchar,@buy_price)		  + '''' + ','
																		+ '''' +convert(nvarchar,@guarantee_price)	  + '''' + ','
																		+ '''' +convert(nvarchar,@commission)		  + '''' + ','
																		+ '''' +convert(nvarchar,@auction_period)	  + '''' + ','
																		+ '''' +convert(nvarchar,@before_money)		  + '''' + ','
																		+ '''' +convert(nvarchar,@after_money)		  + '''' + ','
																		+ '''' +convert(nvarchar,@change_money)		  + '''' + ','
																		+ '''' +@target_name						  + '''' + ','
																		+ '''' +convert(nvarchar,@result)			  + '''' + ')'



EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetCashBuy
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetCashBuy]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetCashBuy]
GO

CREATE PROCEDURE [dbo].[up_SetCashBuy]
	
				 @log_type				int
				,@auth_id				uniqueidentifier
				,@product_id				uniqueidentifier
				,@productcode				int
				,@productcount				int
				,@bcust_id				nvarchar(24)
				,@character_name		nvarchar(16)
				,@gift_recvname			nvarchar(16)
				,@addopt1				int
				,@addopt2				int
				,@addopt3				int	


as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)
DECLARE @world_id VARCHAR(5)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))
SET @world_id = CONVERT( VARCHAR, 1 )

set xact_abort on
begin tran

declare @char_auth_id		nvarchar(50)
declare @productid	nvarchar(50)

declare @updatesql nvarchar(2500)


-- CashBuy_Log ??? ??
exec Local_CreateCashBuyTable @createtime

set @char_auth_id = @auth_id
set @productid = @product_id


									SET	 @updatesql  = 'INSERT INTO Cash_Buy_log_' + @year + '_' + @month + '( 	date
																			,log_type			
																			,world_id
																			,auth_id			
																			,bcust_id			
																			,character_name	
																			,gift_recvname
																			,item_guid
																			,item_id
																			,item_count
																			,addopt1
																			,addopt2
																			,addopt3
																			)										
																			 VALUES ('
																			+ '''' +convert(nvarchar, @createtime) + '''' + ',' 
																		        + '''' +convert(nvarchar,@log_type) + '''' + ','
																		        + '''' +@world_id + '''' + ','	
																			+ '''' +@char_auth_id + '''' + ','			
																			+ '''' +@bcust_id + '''' + ','			
																			+ '''' +@character_name + '''' + ','	
																			+ '''' +@gift_recvname + '''' + ','
																			+ '''' +@productid + '''' + ','	
																			+ '''' +convert(nvarchar,@productcode) + '''' + ','	
																			+ '''' +convert(nvarchar,@productcount) + '''' + ','
																			+ '''' +convert(nvarchar,@addopt1) + '''' + ','
																			+ '''' +convert(nvarchar,@addopt2) + '''' + ','
																			+ '''' +convert(nvarchar,@addopt3) + '''' + ')'   


EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetCharacter
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetCharacter]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetCharacter]
GO

CREATE PROCEDURE [dbo].[up_SetCharacter]
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@channel_id			smallint
,@bcust_id				nvarchar(24)
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@character_class		int
,@character_Job		    int
,@character_Level		int
,@guildpoint			int
,@character_count		int
,@b_character_name		nvarchar(16)
,@b_Job					int
,@b_Level				int

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_char_id		nvarchar(50)

set @char_auth_id		= @auth_id
set @char_char_id		= @character_id

exec Local_CreateCharacterTable @createtime

 SET @updatesql ='insert into Character_Log_'+ @year+'_'+@month
				+'(log_type, world_id, auth_id, channel_id, bcust_id, character_id, character_name, character_class, character_Job, character_Level,		
				guildpoint, character_count, b_character_name, b_Job, b_Level, date)
				values (' 
				+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
				+ '''' +convert(nvarchar, @world_id) + '''' + ',' 
				+ '''' +@char_auth_id				+ '''' + ','  
				+ '''' +convert(nvarchar, @channel_id) + '''' + ',' 
				+ '''' +@bcust_id					+ '''' + ','  
				+ '''' +@char_char_id				+ '''' + ',' 
				+ '''' +@character_name				+ '''' + ',' 
				+ '''' +convert(nvarchar, @character_class) + '''' + ',' 
				+ '''' +convert(nvarchar, @character_Job)	+ '''' + ',' 
				+ '''' +convert(nvarchar, @character_Level) + '''' + ',' 
				+ '''' +convert(nvarchar, @guildpoint)		+ '''' + ',' 
				+ '''' +convert(nvarchar, @character_count) + '''' + ',' 
				+ '''' +@b_character_name				+ '''' + ',' 
				+ '''' +convert(nvarchar, @b_Job) + '''' + ',' 
				+ '''' +convert(nvarchar, @b_Level) + '''' + ',' 
				+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   


EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetChat
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetChat]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetChat]
GO

CREATE PROCEDURE [dbo].[up_SetChat]
 @log_type				int
,@world_id				int	
,@auth_id				uniqueidentifier
,@channel_group			int
,@channel_num			int
,@bcust_id				nvarchar(16)
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@chat_target			nvarchar(16)
,@chats					nvarchar(100)


as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year	varchar(50)
declare @month	varchar(50)
declare @day	varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))
set @day	= convert(varchar, datepart(dd,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(4000)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

set @char_auth_id		= @auth_id
set @char_character_id	= @character_id


-- Battle_Room_Log ??? ??
exec Local_CreateChatTable @createtime

 SET @updatesql ='insert into Chat_Log_'+ @year+'_'+@month+'_'+@day+
				'(	 log_type				
					,world_id				
					,auth_id				
					,channel_group			
					,channel_num			
					,bcust_id				
					,character_id			
					,character_name		
					,chat_target			
					,chats
					,date ) 
	      values (' 
			+ '''' +convert(nvarchar, @log_type)		+ '''' + ',' 
			+ '''' +convert(nvarchar, @world_id)		+ '''' + ',' 
			+ '''' +@char_auth_id						+ '''' + ',' 
			+ '''' +convert(nvarchar, @channel_group)	+ '''' + ','  
			+ '''' +convert(nvarchar, @channel_num)		+ '''' + ','   
			+ '''' +@bcust_id							+ '''' + ','  
			+ '''' +@char_character_id					+ '''' + ','  
			+ '''' +@character_name						+ '''' + ','  
			+ '''' +@chat_target						+ '''' + ','  
			+ '''' +@chats								+ '''' + ','  
			+ '''' +convert(nvarchar, @createtime)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetDungeon
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetDungeon]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetDungeon]
GO

CREATE PROCEDURE [dbo].[up_SetDungeon]
	
	 @log_type			int	
	,@intance_id		[uniqueidentifier]
	,@world_id			int	
	,@dungeonid			int	
	,@difficulty		tinyint	
	,@membercountstart	tinyint	
	,@death				tinyint	
	,@rebirth			tinyint	

as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_instance_id		nvarchar(50)


-- Login_Log ??? ??
exec Local_CreateDungeonTable @createtime

set @char_instance_id = @intance_id

	SET	 @updatesql  = 'INSERT INTO Dungeon_log_' + @year + '_' + @month + '(    log_type			
																				,instance_id		
																				,world_id			
																				,dungeon_id			
																				,difficulty		
																				,membercountstart	
																				,death				
																				,rebirth)
																				VALUES('
																				+ '''' +convert(nvarchar, @log_type)         + '''' + ',' 
																				+ '''' +@char_instance_id  + '''' + ','  
																				+ '''' +convert(nvarchar, @world_id)        + '''' + ','
																				+ '''' +convert(nvarchar, @dungeonid)        + '''' + ',' 
																				+ '''' +convert(nvarchar, @difficulty)       + '''' + ',' 
																				+ '''' +convert(nvarchar, @membercountstart) + '''' + ',' 
																				+ '''' +convert(nvarchar, @death)            + '''' + ',' 
																				+ '''' +convert(nvarchar, @rebirth)          + '''' + ')'   

EXEC(@updatesql)			

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetDungeonClear
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetDungeonClear]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetDungeonClear]
GO

CREATE PROCEDURE [dbo].[up_SetDungeonClear]
	 
	 @log_type			int	
	,@instance_id		uniqueidentifier	
	,@bcust_id			varchar(24)	
	,@character_id		uniqueidentifier	
	,@character_name	nvarchar(16)	
	,@character_class	int			
	,@character_level	int	
	,@membercountclear	tinyint	
	,@clearrank			nvarchar(4)	
	,@stylishpoint		smallint	
	,@hitcount			smallint	
	,@chain				smallint	
	,@killcount			smallint	
	,@cleartime			int	
	,@cardid			int	
	,@cardrewardid		int	
	,@cardrewardcount	int	
	,@addexp			int	
	,@death				tinyint	
	,@rebirth			smallint	
	,@replay			tinyint	
	,@dungeonid			int	
	,@difficulty		int	
	,@playpoint			int

as
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_instance_id nvarchar(50)
declare @char_character_id nvarchar(50)

-- Login_Log ??? ??
exec Local_CreateDungeonClearTable @createtime

set @char_instance_id  = @instance_id
set @char_character_id = @character_id

	SET	 @updatesql  = 'INSERT INTO DungeonClear_Log_' + @year + '_' + @month + '(
 log_type          
,instance_id		
,bcust_id			
,character_id		
,character_name	
,character_class	
,character_level	
,membercountclear	
,clearrank			
,stylishpoint		
,hitcount			
,chain				
,killcount			
,cleartime			
,cardid			
,cardrewardid		
,cardrewardcount	
,addexp			
,death				
,rebirth			
,replay	
,dungeonid
,difficulty
,playpoint
) VALUES (' 
 + '''' +convert(nvarchar,@log_type) + '''' + ','          
 + '''' +@char_instance_id + '''' + ','		
 + '''' +@bcust_id+ '''' + ','			
 + '''' +@char_character_id + '''' + ','		
 + '''' +@character_name + '''' + ','	
 + '''' +convert(nvarchar,@character_class) + '''' + ','	
 + '''' +convert(nvarchar,@character_level) + '''' + ','	
 + '''' +convert(nvarchar,@membercountclear) + '''' + ','	
 + '''' +@clearrank+ '''' + ','			
 + '''' +convert(nvarchar,@stylishpoint) + '''' + ','		
 + '''' +convert(nvarchar,@hitcount) + '''' + ','			
 + '''' +convert(nvarchar,@chain) + '''' + ','				
 + '''' +convert(nvarchar,@killcount) + '''' + ','			
 + '''' +convert(nvarchar,@cleartime) + '''' + ','			
 + '''' +convert(nvarchar,@cardid) + '''' + ','			
 + '''' +convert(nvarchar,@cardrewardid) + '''' + ','		
 + '''' +convert(nvarchar,@cardrewardcount) + '''' + ','	
 + '''' +convert(nvarchar,@addexp) + '''' + ','			
 + '''' +convert(nvarchar,@death) + '''' + ','				
 + '''' +convert(nvarchar,@rebirth) + '''' + ','			
 + '''' +convert(nvarchar,@replay)+ '''' + ','	
 + '''' +convert(nvarchar,@dungeonid) + '''' + ','			
 + '''' +convert(nvarchar,@difficulty) + '''' + ','			
 + '''' +convert(nvarchar,@playpoint)+ '''' + ')'	


EXEC(@updatesql)


if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetEnchanteItem
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetEnchanteItem]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetEnchanteItem]
GO

CREATE PROCEDURE [dbo].[up_SetEnchanteItem]
	@log_type		 smallint,
	@world_id		 int, 
	@auth_id		 [uniqueidentifier], 
	@bcust_id		 nvarchar(50), 
	@character_id	 [uniqueidentifier], 
	@character_name	 nvarchar(50), 
	@item_guid		 [uniqueidentifier],	-- ??? GUID 
	@item_kind		 int,					-- ??? ?? // 1-??, 2-???
	@enchante_level	 int,					-- ??? ??	
	@flag			 tinyint				-- ????	// 0 - ??, 1 - ??
	
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_item_id		nvarchar(50)

declare @succeed_num		int
declare @failed_num			int

--  ??? ??
exec Local_CreateEnchantItemTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id
set @char_item_id = @item_guid



 SET @updatesql ='insert into EnchantItem_Log_'+ @year+'_'
	     +@month+'(log_type, world_id, auth_id, bcust_id, character_id, character_name, item_guid, item_kind, enchant_level, flag, date ) 
	      values (' 
	      + '''' +convert(nvarchar, @log_type) + '''' + ',' 
	      + '''' +convert(nvarchar, @world_id) + '''' + ',' 
	      + '''' +@char_auth_id + '''' + ','  		  
	      + '''' +@bcust_id+ '''' + ',' 
	      + '''' +@char_character_id+ '''' + ',' 
	      + '''' +@character_name+ '''' + ',' 
		  + '''' +@char_item_id+ '''' + ',' 		  
		  + '''' +convert(nvarchar, @item_kind)+ '''' + ',' 		  
		  + '''' +convert(nvarchar, @enchante_level)+ '''' + ',' 		  
	      + '''' +convert(nvarchar, @flag)+ '''' + ',' 		  
		  + '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetGMInquiry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetGMInquiry]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetGMInquiry]
GO

CREATE PROCEDURE [dbo].[up_SetGMInquiry]
@inquiry_id				uniqueidentifier,
@auth_id				uniqueidentifier,
@char_id				uniqueidentifier,
@world_id				int,
@type					tinyint,
@character_name			nvarchar(20),
@bcust_id				nvarchar(20),
@memo					nvarchar(255)

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_inquiry_id	nvarchar(50)
declare @char_auth_id		nvarchar(50)
declare @char_char_id		nvarchar(50)

set @char_inquiry_id	= @inquiry_id
set @char_auth_id		= @auth_id
set @char_char_id		= @char_id


exec Local_CreateGMInquiryTable @createtime

 SET @updatesql ='insert into GMInquiry_'+ @year+'_'
	     +@month+'(		inquiry_id		
						,auth_id
						,char_id
						,world_id		
						,type			
						,character_name
						,state
						,online
						,bcust_id
						,memo
						,date ) 
	      values (' 
			+ '''' +@char_inquiry_id				+ '''' + ','  
			+ '''' +@char_auth_id					+ '''' + ','  
			+ '''' +@char_char_id					+ '''' + ',' 
			+ '''' +convert(nvarchar, @world_id)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @type)		+ '''' + ',' 
			+ '''' +@character_name					+ '''' + ',' 
			+ '''' +convert(nvarchar, 1)			+ '''' + ',' 
			+ '''' +convert(nvarchar, 1)			+ '''' + ',' 
			+ '''' +@bcust_id						+ '''' + ',' 
			+ '''' +@memo							+ '''' + ',' 
			+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetGold
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetGold]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetGold]
GO

CREATE PROCEDURE [dbo].[up_SetGold]
	@log_type		 smallint,
	@world_id		 int, 
	@auth_id		 [uniqueidentifier], 
	@bcust_id		 nvarchar(50) = NULL, 
	@character_id	 [uniqueidentifier], 
	@character_name	 nvarchar(50), 

	@Otherauth_id		 [uniqueidentifier], 
	@Otherbcust_id		 nvarchar(50) = NULL, 
	@Othercharacter_id	 [uniqueidentifier], 
	@Othercharacter_name	 nvarchar(50), 

	@Gold_Prev int,
	@Gold_Change int,
	@Gold_After int,
	@record_time	 datetime
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_other_auth_id		nvarchar(50)
declare @char_other_character_id	nvarchar(50)

-- Login_Log ??? ??
exec Local_CreateMoneyTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id
set @char_other_auth_id = @Otherauth_id
set @char_other_character_id = @Othercharacter_id


 SET @updatesql ='insert into Money_Log_'+ @year+'_'
	     +@month+'(log_type, world_id, auth_id, bcust_id, character_id, character_name, other_auth_id, other_bcust_id, other_character_id, other_character_name, before_money, after_money, change_money, entry_date ) 
	      values (' 
	      + '''' +convert(nvarchar, @log_type) + '''' + ',' 
	      + '''' +convert(nvarchar, @world_id) + '''' + ',' 
	      + '''' +@char_auth_id + '''' + ','  
	      + '''' +@bcust_id+ '''' + ',' 
	      + '''' +@char_character_id+ '''' + ',' 
	      + '''' +@character_name+ '''' + ','      
		  + '''' +@char_other_auth_id+ '''' + ',' 
		  + '''' +@Otherbcust_id+ '''' + ',' 
		  + '''' +@char_other_character_id+ '''' + ',' 
		  + '''' +@Othercharacter_name+ '''' + ','  
		  + '''' +convert(nvarchar, @Gold_Prev)+ '''' +',' 
		  + '''' +convert(nvarchar, @Gold_After)+ '''' +',' 
		  + '''' +convert(nvarchar, @Gold_Change)+ '''' +',' 
 	      + '''' +convert(nvarchar, @record_time, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetInquiryChatting
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetInquiryChatting]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetInquiryChatting]
GO

CREATE PROCEDURE [dbo].[up_SetInquiryChatting]
@world_id			int
,@inquiry_id		int	
,@chatting_number	int
,@sender			nvarchar(16)
,@chatting			nvarchar(255)

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

-- Login_Log ??? ??
exec Local_CreateInquiryChattingTable @createtime


 SET @updatesql ='insert into InquiryChatting_Log_'+ @year+'_'
	     +@month+	'( world_id
					,log_id
					,keyboarder
					,chat_number
					,dialog
					,date )
	      values (' 
		+ '''' +convert(nvarchar, @world_id)		+ '''' + ',' 
		+ '''' +convert(nvarchar, @inquiry_id)		+ '''' + ',' 
		+ '''' +@sender								+ '''' + ',' 
		+ '''' +convert(nvarchar, @chatting_number)	+ '''' + ',' 
		+ '''' +@chatting							+ '''' + ',' 
		+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetInquiryComplete
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetInquiryComplete]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetInquiryComplete]
GO

CREATE PROCEDURE [dbo].[up_SetInquiryComplete]
@world_id			int
,@log_id			int
,@log_type			int	
,@end_status		tinyint
,@start_status		tinyint
,@target_bcustno	nvarchar(16)
,@target_character	nvarchar(16)
,@GM				nvarchar(16)
,@former_GM			nvarchar(16)
,@remain_number		tinyint
,@inquery_use		nvarchar(1)
,@group_processing	nvarchar(1)
,@post_time			datetime
,@start_time		datetime
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

-- Login_Log ??? ??
exec Local_CreateInquiryCompleteTable @createtime


 SET @updatesql ='insert into InquiryComplete_Log_'+ @year+'_'
	     +@month+	'(world_id		
					,log_id	
					,log_type
					,end_status		
					,start_status		
					,target_bcustno	
					,target_character	
					,GM				
					,former_GM			
					,remain_number		
					,inquery_use		
					,group_processing	
					,post_time			
					,start_time ) 
	      values (' 
		+ '''' +convert(nvarchar, @world_id)		+ '''' + ',' 
		+ '''' +convert(nvarchar, @log_id)			+ '''' + ',' 
		+ '''' +convert(nvarchar, @log_type)		+ '''' + ',' 
		+ '''' +convert(nvarchar, @end_status)		+ '''' + ',' 
		+ '''' +convert(nvarchar, @start_status)	+ '''' + ',' 
		+ '''' +@target_bcustno						+ '''' + ',' 
		+ '''' +@target_character					+ '''' + ',' 
		+ '''' +@GM									+ '''' + ',' 
		+ '''' +@former_GM							+ '''' + ',' 
		+ '''' +convert(nvarchar, @remain_number)	+ '''' + ',' 
		+ '''' +@inquery_use						+ '''' + ',' 
		+ '''' +@group_processing					+ '''' + ',' 
		+ '''' +convert(nvarchar, @post_time, 109)	+ '''' + ',' 
		+ '''' +convert(nvarchar, @start_time, 109)	+ '''' + ')' 

EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetItemMail
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetItemMail]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetItemMail]
GO

CREATE PROCEDURE [dbo].[up_SetItemMail]	
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@item_guid				uniqueidentifier
,@item_ID				int
,@item_header			int
,@enchant_level			int
,@item_active			int
,@socket_count			tinyint
,@remain_recon			tinyint
,@durability			int
,@item_option1			int
,@item_option2			int
,@item_option3			int
,@item_option_value1	int
,@item_option_value2	int
,@item_option_value3	int
,@item_socket_option1	int
,@item_socket_option2	int
,@item_socket_option3	int
,@item_socket_value1	int
,@item_socket_value2	int
,@item_socket_value3	int
,@item_socket_color1	int
,@item_socket_color2	int
,@item_socket_color3	int
,@item_count			int
,@before_money			int
,@after_money			int
,@change_money			int
,@target_name			nvarchar(16)
,@mail_type				int

as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_item_id		nvarchar(50)

set @char_auth_id		= @auth_id
set @char_character_id	= @character_id
set @char_item_id		= @item_guid

exec Local_CreateItemMailTable @createtime

SET	 @updatesql  = 'insert into ItemMail_Log_' + @year + '_' + @month +
'(log_type
,world_id
,auth_id
,character_id
,character_name
,item_guid
,item_ID
,item_header
,enchant_level
,item_active
,socket_count
,item_recon
,durability
,item_option1
,item_option2
,item_option3
,item_option_value1
,item_option_value2
,item_option_value3
,item_socket_option1
,item_socket_option2
,item_socket_option3
,item_socket_value1
,item_socket_value2
,item_socket_value3
,item_socket_color1
,item_socket_color2
,item_socket_color3
,item_count
,before_money
,after_money
,change_money
,target_name
,mail_type	)									
VALUES ('
+ '''' +convert(nvarchar,@log_type)			+ '''' + ','
+ '''' +convert(nvarchar,@world_id)			+ '''' + ','
+ '''' +@char_auth_id					 	+ '''' + ','
+ '''' +@char_character_id				 	+ '''' + ','
+ '''' +@character_name					 	+ '''' + ','
+ '''' +@char_item_id						+ '''' + ','
+ '''' +convert(nvarchar,@item_id)			+ '''' + ','
+ '''' +convert(nvarchar,@item_header)		+ '''' + ','
+ '''' +convert(nvarchar,@enchant_level)	+ '''' + ','
+ '''' +convert(nvarchar,@item_active)		+ '''' + ','
+ '''' +convert(nvarchar,@socket_count)		+ '''' + ','
+ '''' +convert(nvarchar,@remain_recon)		+ '''' + ','
+ '''' +convert(nvarchar,@durability)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option1)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option2)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option3)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option_value1)+ '''' + ','
+ '''' +convert(nvarchar,@item_option_value2)+ '''' + ','
+ '''' +convert(nvarchar,@item_option_value3)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_option1)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_option2)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_option3)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_value1) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_value2) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_value3) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_color1) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_color2) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_color3) + '''' + ','
+ '''' +convert(nvarchar,@item_count)		  + '''' + ','
+ '''' +convert(nvarchar,@before_money)		  + '''' + ','
+ '''' +convert(nvarchar,@after_money)		  + '''' + ','
+ '''' +convert(nvarchar,@change_money)		  + '''' + ','
+ '''' +@target_name						  + '''' + ','
+ '''' +convert(nvarchar,@mail_type)		  + '''' + ')'

EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetItems
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetItems]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetItems]
GO

CREATE PROCEDURE [dbo].[up_SetItems]	
@log_type				int
,@world_id				int
,@auth_id				uniqueidentifier
,@character_id			uniqueidentifier
,@character_name		nvarchar(16)
,@item_guid				uniqueidentifier
,@item_ID				int
,@item_header			int
,@enchant_level			int
,@item_active			int
,@socket_count			tinyint
,@remain_recon			tinyint
,@durability			int
,@item_option1			int
,@item_option2			int
,@item_option3			int
,@item_option_value1	int
,@item_option_value2	int
,@item_option_value3	int
,@item_socket_option1	int
,@item_socket_option2	int
,@item_socket_option3	int
,@item_socket_value1	int
,@item_socket_value2	int
,@item_socket_value3	int
,@item_socket_color1	int
,@item_socket_color2	int
,@item_socket_color3	int
,@item_count			int
,@before_money			int
,@after_money			int
,@change_money			int
,@before_date			int
,@after_date			int
,@result				int

as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(4000)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_item_id		nvarchar(50)

set @char_auth_id		= @auth_id
set @char_character_id	= @character_id
set @char_item_id		= @item_guid

exec Local_CreateItemsTable @createtime

SET	 @updatesql  = 'insert into Items_Log_' + @year + '_' + @month +
'(log_type
,world_id
,auth_id
,character_id
,character_name
,item_guid
,item_ID
,item_header
,enchant_level
,item_active
,socket_count
,item_recon
,durability
,item_option1
,item_option2
,item_option3
,item_option_value1
,item_option_value2
,item_option_value3
,item_socket_option1
,item_socket_option2
,item_socket_option3
,item_socket_value1
,item_socket_value2
,item_socket_value3
,item_socket_color1
,item_socket_color2
,item_socket_color3
,item_count
,before_money
,after_money
,change_money
,before_date
,after_date
,result		)									
VALUES ('
+ '''' +convert(nvarchar,@log_type)			+ '''' + ','
+ '''' +convert(nvarchar,@world_id)			+ '''' + ','
+ '''' +@char_auth_id					 	+ '''' + ','
+ '''' +@char_character_id				 	+ '''' + ','
+ '''' +@character_name					 	+ '''' + ','
+ '''' +@char_item_id						+ '''' + ','
+ '''' +convert(nvarchar,@item_id)			+ '''' + ','
+ '''' +convert(nvarchar,@item_header)		+ '''' + ','
+ '''' +convert(nvarchar,@enchant_level)	+ '''' + ','
+ '''' +convert(nvarchar,@item_active)		+ '''' + ','
+ '''' +convert(nvarchar,@socket_count)		+ '''' + ','
+ '''' +convert(nvarchar,@remain_recon)		+ '''' + ','
+ '''' +convert(nvarchar,@durability)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option1)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option2)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option3)		+ '''' + ','
+ '''' +convert(nvarchar,@item_option_value1)+ '''' + ','
+ '''' +convert(nvarchar,@item_option_value2)+ '''' + ','
+ '''' +convert(nvarchar,@item_option_value3)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_option1)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_option2)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_option3)+ '''' + ','
+ '''' +convert(nvarchar,@item_socket_value1) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_value2) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_value3) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_color1) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_color2) + '''' + ','
+ '''' +convert(nvarchar,@item_socket_color3) + '''' + ','
+ '''' +convert(nvarchar,@item_count)		  + '''' + ','
+ '''' +convert(nvarchar,@before_money)		  + '''' + ','
+ '''' +convert(nvarchar,@after_money)		  + '''' + ','
+ '''' +convert(nvarchar,@change_money)		  + '''' + ','
+ '''' +convert(nvarchar,@before_date)		  + '''' + ','
+ '''' +convert(nvarchar,@after_date)		  + '''' + ','
+ '''' +convert(nvarchar,@result)			  + '''' + ')'

EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetItemTrade
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetItemTrade]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetItemTrade]
GO

CREATE PROCEDURE [dbo].[up_SetItemTrade]
AS
GO


-- ----------------------------
-- procedure structure for up_SetLevelUp
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetLevelUp]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetLevelUp]
GO

CREATE PROCEDURE [dbo].[up_SetLevelUp]
	@log_type		 smallint,
	@world_id		 int, 
	@auth_id		 [uniqueidentifier], 
	@bcust_id		 nvarchar(50), 
	@character_id	 [uniqueidentifier], 
	@character_name	 nvarchar(50), 
	@character_class int,
	@character_level int,
	@record_time	 datetime
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

-- Login_Log ??? ??
exec Local_CreateLevelUpTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id


 SET @updatesql ='insert into LevelUp_Log_'+ @year+'_'
	     +@month+'(log_type, world_id, auth_id, bcust_id, character_id, character_name, character_class, character_level, record_date, date ) 
	      values (' 
	      + '''' +convert(nvarchar, @log_type) + '''' + ',' 
	      + '''' +convert(nvarchar, @world_id) + '''' + ',' 
	      + '''' +@char_auth_id + '''' + ','  		  
	      + '''' +@bcust_id+ '''' + ',' 
	      + '''' +@char_character_id+ '''' + ',' 
	      + '''' +@character_name+ '''' + ',' 
		  + '''' +convert(nvarchar, @character_class)+ '''' + ',' 
		  + '''' +convert(nvarchar, @character_level)+ '''' + ',' 
		  + '''' +convert(nvarchar, @record_time, 109)+ '''' + ',' 
	      + '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetLoginOut
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetLoginOut]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetLoginOut]
GO

CREATE PROCEDURE [dbo].[up_SetLoginOut]
	
		 @log_type			int	
		,@world_id			int	
		,@auth_id			uniqueidentifier	
		,@channel_group		tinyint	
		,@channel_num		int	
		,@bcust_id			nvarchar(16)	
		,@character_id		uniqueidentifier	
		,@character_name	nvarchar(16)	
		,@inven_gold		int	
		,@storage_gold		int	
		,@character_level	tinyint	
		,@character_exp		int	
		,@targetmap			int	
		,@playpoint			int	
		,@skillpoint		int	
		,@guildpoint		int	
		,@coin				int	
as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

declare @updatesql nvarchar(2500)


-- Login_Log ??? ??
exec Local_CreateLoginOutTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id

	SET	 @updatesql  = 'INSERT INTO LoginOut_Log_' + @year + '_' + @month + '(   log_type			
																				,world_id				
																				,auth_id				
																				,channel_group		
																				,channel_num			
																				,bcust_id				
																				,character_id		
																				,character_name		
																				,inven_gold			
																				,storage_gold			
																				,character_level		
																				,character_exp		
																				,targetmap			
																			    ,playpoint			
																			    ,skillpoint		
																			    ,guildpoint		
																			    ,coin																						
																			)										
																			 VALUES ('
																		    + '''' +convert(nvarchar,@log_type) + '''' + ','			
																			+ '''' +convert(nvarchar,@world_id) + '''' + ','			
																			+ '''' +@char_auth_id + '''' + ','			
																			+ '''' +convert(nvarchar,@channel_group) + '''' + ','	
																			+ '''' +convert(nvarchar,@channel_num) + '''' + ','
																			+ '''' +@bcust_id + '''' + ','			
																			+ '''' +@char_character_id + '''' + ','		
																			+ '''' +@character_name + '''' + ','	
																			+ '''' +convert(nvarchar,@inven_gold) + '''' + ','	
																			+ '''' +convert(nvarchar,@storage_gold) + '''' + ','		
																			+ '''' +convert(nvarchar,@character_level) + '''' + ','	
																			+ '''' +convert(nvarchar,@character_exp) + '''' + ','			
																			+ '''' +convert(nvarchar,@targetmap) + '''' + ','																						
																			+ '''' +convert(nvarchar,@playpoint) + '''' + ','
																						+ '''' +convert(nvarchar,@skillpoint) + '''' + ','
																			+ '''' +convert(nvarchar,@guildpoint) + '''' + ','		
																			+ '''' +convert(nvarchar,@coin)+ '''' + ')'   


EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetMail
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetMail]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetMail]
GO

CREATE PROCEDURE [dbo].[up_SetMail]
	
	 @log_type        int	
	,@world_id	      int	
	,@auth_id	      uniqueidentifier	
	,@channel_group	  tinyint	
	,@channel_num	  int	
	,@mail_id	      uniqueidentifier	
	,@bcust_id	      nvarchar(16)	
	,@character_id	  uniqueidentifier	
	,@character_name  nvarchar(16)	
	,@receiver_name	  nvarchar(16)	
	,@msg	          nvarchar(50)	
	,@return_day	  int	
	,@req_gold	      int	

as 
set nocount on

declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(2500)

declare @char_auth_id nvarchar(50)
declare @char_mail_id nvarchar(50)
declare @char_character_id nvarchar(50)


-- Login_Log ??? ??
exec Local_CreateMailTable @createtime

set @char_auth_id = @auth_id
set @char_mail_id = @mail_id
set @char_character_id = @character_id

SET	 @updatesql  = 'INSERT INTO Mail_Log_' + @year + '_' + @month + '(   log_type      
																		,world_id	    
																		,auth_id	    
																		,channel_group	
																		,channel_num	
																		,mail_id	    
																		,bcust_id	    
																		,character_id	
																		,character_name
																		,receiver_name	
																		,msg	        
																		,return_day								
																		,req_gold)
																		 VALUES ('
																		
																		+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
																		+ '''' +convert(nvarchar, @world_id) + '''' + ','  
																		+ '''' +@char_auth_id+ '''' + ',' 
																		+ '''' +convert(nvarchar, @channel_group)+ '''' + ',' 
																		+ '''' +convert(nvarchar, @channel_num)+ '''' + ',' 
																		+ '''' +@char_auth_id+ '''' + ',' 
																		+ '''' +@bcust_id+ '''' + ',' 
																		+ '''' +@char_character_id+ '''' + ','
																		+ '''' +@character_name+ '''' +','  
																		+ '''' +@receiver_name+ '''' +',' 
																		+ '''' +@msg+ '''' +',' 
																		+ '''' +convert(nvarchar, @return_day)+ '''' +',' 
 																		+ '''' +convert(nvarchar, @req_gold)+ '''' + ')'   

EXEC(@updatesql)


if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetMonitorCommand
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetMonitorCommand]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetMonitorCommand]
GO

CREATE PROCEDURE [dbo].[up_SetMonitorCommand]
@log_type			int
,@world_ID			int
,@server_type		int
,@GM_ID				nvarchar(16)
,@command			int
,@server_code		int

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

exec Local_CreateMonitorCommandTable @createtime

 SET @updatesql ='insert into MonitorCommand_Log_'+ @year+'_'+@month
				+'(log_type, world_id, channel_ID, executer_ID, command, target, date)
				values (' 
				+ '''' +convert(nvarchar, @log_type)		+ '''' + ',' 
				+ '''' +convert(nvarchar, @world_id)		+ '''' + ',' 
				+ '''' +convert(nvarchar, @server_type)		+ '''' + ',' 
				+ '''' +@GM_ID								+ '''' + ','  
				+ '''' +convert(nvarchar, @command)			+ '''' + ',' 
				+ '''' +convert(nvarchar, @server_code)		+ '''' + ',' 
				+ '''' +convert(nvarchar, @createtime, 109)	+ '''' + ')'   

EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetMonitorNotice
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetMonitorNotice]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetMonitorNotice]
GO

CREATE PROCEDURE [dbo].[up_SetMonitorNotice]
@log_type		int
,@world_id		int
,@target		int
,@notice_type	tinyint
,@notice_cycle	tinyint
,@notice		nvarchar(255)	
,@gm_ID			nvarchar(16)

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

exec Local_CreateMonitorNoticeTable @createtime

 SET @updatesql ='insert into MonitorNotice_Log_'+ @year+'_'+@month
				+'(log_type, world_id, target, notice_type, notice_cycle, notice, gm_ID, date)
				values (' 
				+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
				+ '''' +convert(nvarchar, @world_id) + '''' + ',' 
				+ '''' +convert(nvarchar, @target)	 + '''' + ','  
				+ '''' +convert(nvarchar, @notice_type) + '''' + ',' 
				+ '''' +convert(nvarchar, @notice_cycle)	+ '''' + ',' 
				+ '''' +@notice				+ '''' + ','  
				+ '''' +@gm_ID				+ '''' + ','  
				+ '''' +convert(nvarchar, @createtime, 109)	+ '''' + ')'   

EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetMonitorUser
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetMonitorUser]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetMonitorUser]
GO

CREATE PROCEDURE [dbo].[up_SetMonitorUser]
@log_type		int
,@world_id		int
,@gate			int
,@lobby			int
,@dungeon		int
,@pvp			int
,@total			int
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

-- Battle_Room_Log ??? ??
exec Local_CreateMonitorUserTable @createtime

 SET @updatesql ='insert into MonitorUser_Log_'+ @year+'_'
	     +@month+'( log_type, world_ID, CU_gate, CU_lobby, CU_PVP, CU_dungeon, CU_total, date ) 
	      values (' 
			+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
			+ '''' +convert(nvarchar, @world_id) + '''' + ',' 
			+ '''' +convert(nvarchar, @gate) + '''' + ',' 
			+ '''' +convert(nvarchar, @lobby) + '''' + ',' 
			+ '''' +convert(nvarchar, @dungeon) + '''' + ',' 
			+ '''' +convert(nvarchar, @pvp) + '''' + ',' 
			+ '''' +convert(nvarchar, @total) + '''' + ',' 
			+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetPacketOverload
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetPacketOverload]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetPacketOverload]
GO

CREATE PROCEDURE [dbo].[up_SetPacketOverload]
	@func_name	char(100), 
	@time		int
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(500)

-- PacketOverload_Log ??? ??
exec Local_CreatePacketOverloadLogTable @createtime


 SET @updatesql ='insert into PacketOverload_Log_'+ @year+'_'
	     +@month+'(func_name, time, date) 
	      values (' 
	      + '''' +convert(nvarchar, @func_name)+ '''' + ',' 
	      + '''' +convert(nvarchar, @time)+ '''' + ',' 
	      + '''' +convert(nvarchar, @createtime)+ '''' + ')'   
	     EXEC(@updatesql)


	if(@@error <> 0)
	begin
		rollback
		return
	end

	commit
GO


-- ----------------------------
-- procedure structure for up_SetPlayTime
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetPlayTime]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetPlayTime]
GO

CREATE PROCEDURE [dbo].[up_SetPlayTime]
	@log_type		 smallint,
	@world_id		 int, 
	@auth_id		 [uniqueidentifier], 
	@bcust_id		 nvarchar(50), 
	@character_id	 [uniqueidentifier], 
	@character_name	 nvarchar(50), 
	@character_class int,
	@character_level int,
	@channel_id		 int,
	@start_time		 datetime,
	@end_time		 datetime
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

-- Login_Log ??? ??
exec Local_CreatePTTable @createtime

set @char_auth_id = @auth_id
set @char_character_id = @character_id


 SET @updatesql ='insert into PT_Log_'+ @year+'_'
	     +@month+'(log_type, world_id, auth_id, bcust_id, ChannelID, character_id, character_name, character_class, character_level, p_start_date, p_end_date, date ) 
	      values (' 
	      + '''' +convert(nvarchar, @log_type) + '''' + ',' 
	      + '''' +convert(nvarchar, @world_id) + '''' + ',' 
	      + '''' +@char_auth_id + '''' + ','  
	      + '''' +@bcust_id+ '''' + ',' 
		  + '''' +convert(nvarchar, @channel_id) + '''' + ',' 
	      + '''' +@char_character_id+ '''' + ',' 
	      + '''' +@character_name+ '''' + ',' 
		  + '''' +convert(nvarchar, @character_class)+ '''' + ',' 
		  + '''' +convert(nvarchar, @character_level)+ '''' + ',' 
		  + '''' +convert(nvarchar, @start_time, 109)+ '''' + ',' 
		  + '''' +convert(nvarchar, @end_time, 109)+ '''' + ',' 
	      + '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetPvpDeath
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetPvpDeath]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetPvpDeath]
GO

CREATE PROCEDURE [dbo].[up_SetPvpDeath]
	@log_type				smallint,
	@room_id				uniqueidentifier,
	@character_id			uniqueidentifier,
	@character_name			nvarchar(16),
	@character_class		int,
	@character_job			tinyint,
	@character_level		int,
	@kill_id				uniqueidentifier,
	@kill_name				nvarchar(16),
	@kill_class				int,
	@kill_job				tinyint,
	@kill_level				int

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_room_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_kill_id		nvarchar(50)

set @char_room_id		= @room_id
set @char_character_id	= @character_id
set @char_kill_id		= @kill_id


-- Battle_Room_Log ??? ??
exec Local_CreatePvpDeathTable @createtime

 SET @updatesql ='insert into Pvp_Death_Log_'+ @year+'_'+@month
			+'(log_type, room_id
			, character_id, character_name, character_class, character_job, character_level
			, kill_id, kill_name, kill_class, kill_job, kill_level, date ) 
	      values (' 
			+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
			+ '''' +@char_room_id		+ '''' + ','  
			+ '''' +@char_character_id	+ '''' + ','  
			+ '''' +@character_name		+ '''' + ',' 
			+ '''' +convert(nvarchar, @character_class	)+ '''' + ',' 
			+ '''' +convert(nvarchar, @character_job	)+ '''' + ',' 
			+ '''' +convert(nvarchar, @character_level	)+ '''' + ',' 
			+ '''' +@char_kill_id		+ '''' + ',' 
			+ '''' +@kill_name			+ '''' + ',' 
			+ '''' +convert(nvarchar, @kill_class	)+ '''' + ',' 
			+ '''' +convert(nvarchar, @kill_job	)+ '''' + ',' 
			+ '''' +convert(nvarchar, @kill_level	)+ '''' + ',' 
			+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetPvpResult
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetPvpResult]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetPvpResult]
GO

CREATE PROCEDURE [dbo].[up_SetPvpResult]
	@log_type			smallint,
	@auth_id			uniqueidentifier,
	@bcust_id			nvarchar(24),
	@character_id		uniqueidentifier,
	@character_name		nvarchar(16),
	@character_class	int,
	@character_level	int,
	@channel_type		int,
	@room_id			uniqueidentifier,
	@room_world			int,
	@room_type			int,
	@room_map			int,
	@pvp_team			smallint,
	@pvp_score			int,
	@pvp_point			int,
	@pvp_grade			int,
	@pvp_totalscore		int,
	@pvp_totalpoint		int,
	@pvp_rank			int,
	@pvp_kill			int,
	@pvp_die			int,
	@pvp_damage			int,
	@pvp_cleartime		int
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_pvp_room_id	nvarchar(50)

set @char_auth_id		= @auth_id
set @char_character_id	= @character_id
set @char_pvp_room_id	= @room_id


-- Battle_Room_Log ??? ??
exec Local_CreatePvpResultTable @createtime

 SET @updatesql ='insert into Pvp_Result_Log_'+ @year+'_'
	     +@month+'(log_type, auth_id, bcust_id, character_id, character_name, character_class, character_level, channel_type, room_id, room_world, room_type, PZoneID, pvp_team, pvp_score, pvp_point, pvp_grade, pvp_totalscore, pvp_totalpoint, pvp_rank, pvp_kill, pvp_die, pvp_damage, pvp_cleartime, date ) 
	      values (' 
			+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
			+ '''' +@char_auth_id		+ '''' + ','  
			+ '''' +@bcust_id			+ '''' + ',' 
			+ '''' +@char_character_id	+ '''' + ','  
			+ '''' +@character_name		+ '''' + ',' 
			+ '''' +convert(nvarchar, @character_class)+ '''' + ',' 
			+ '''' +convert(nvarchar, @character_level)+ '''' + ',' 
			+ '''' +convert(nvarchar, @channel_type)+ '''' + ',' 
			+ '''' +@char_pvp_room_id	+ '''' + ',' 
			+ '''' +convert(nvarchar, @room_world)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @room_type)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @room_map)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_team)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_score)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_point)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_grade)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_totalscore)+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_totalpoint)+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_rank)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_kill)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_die)		+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_damage)	+ '''' + ',' 
			+ '''' +convert(nvarchar, @pvp_cleartime)+ '''' + ',' 
			+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetPvpRoom
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetPvpRoom]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetPvpRoom]
GO

CREATE PROCEDURE [dbo].[up_SetPvpRoom]
	@log_type			smallint,
	@auth_id			uniqueidentifier,
	@character_id		uniqueidentifier,
	@character_name		nvarchar(16),
	@channel_type		int,
	@room_id			uniqueidentifier,
	@room_world			int,
	@room_number		int,
	@room_name			nvarchar(50)

as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)
declare @char_pvp_room_id	nvarchar(50)

set @char_auth_id		= @auth_id
set @char_character_id	= @character_id
set @char_pvp_room_id	= @room_id


-- Battle_Room_Log ??? ??
exec Local_CreatePvpRoomTable @createtime

 SET @updatesql ='insert into Pvp_Room_Log_'+ @year+'_'
	     +@month+'(log_type, auth_id, character_id, character_name, channel_type, room_id, room_world, room_number, room_name, date ) 
	      values (' 
			+ '''' +convert(nvarchar, @log_type) + '''' + ',' 
			+ '''' +@char_auth_id		+ '''' + ','  
			+ '''' +@char_character_id	+ '''' + ','  
			+ '''' +@character_name		+ '''' + ',' 
			+ '''' +convert(nvarchar, @channel_type	)+ '''' + ',' 
			+ '''' +@char_pvp_room_id	+ '''' + ',' 
			+ '''' +convert(nvarchar, @room_world	)+ '''' + ',' 
			+ '''' +convert(nvarchar, @room_number	)+ '''' + ',' 
			+ '''' +@room_name			+ '''' + ',' 
			+ '''' +convert(nvarchar, @createtime, 109)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_SetSkillLearn
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_SetSkillLearn]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_SetSkillLearn]
GO

CREATE PROCEDURE [dbo].[up_SetSkillLearn]
	 @log_type				int
,@character_id				uniqueidentifier
,@skill_table_id			int
,@skill_level				tinyint
,@character_class			int
,@character_level			tinyint
,@skillpoint_use			int
,@bcustid					nvarchar(16)
,@character_name			nvarchar(16)
	
as
set nocount on


declare @createtime datetime
set @createtime = getdate()

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

set xact_abort on
begin tran

declare @updatesql nvarchar(1500)

declare @char_auth_id		nvarchar(50)
declare @char_character_id	nvarchar(50)

-- Login_Log ??? ??
exec Local_CreateLearnSkillTable @createtime

set @char_character_id = @character_id


 SET @updatesql ='insert into LearnSkill_Log_'+ @year+'_'
	     +@month+'(date, log_type, character_id, character_name, skill_table_id, skill_level, character_Class, character_Level, skillpoint_use ) 
	      values (' 
	      + '''' +convert(nvarchar, @createtime, 109)+ '''' + ','
		  + '''' +convert(nvarchar, @log_type) + '''' + ',' 
	      + '''' +@char_character_id+ '''' + ',' 
	      + '''' +@character_name+ '''' + ',' 
		  + '''' +convert(nvarchar, @skill_table_id)+ '''' + ',' 
		  + '''' +convert(nvarchar, @skill_level)+ '''' + ',' 
		  + '''' +convert(nvarchar, @character_class)+ '''' + ',' 
		  + '''' +convert(nvarchar, @character_level)+ '''' + ',' 
	      + '''' +convert(nvarchar, @skillpoint_use)+ '''' + ')'   
EXEC(@updatesql)

if(@@error <> 0)
begin
	rollback
	return
end

commit
GO


-- ----------------------------
-- procedure structure for up_update_pet_level
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_pet_level]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_pet_level]
GO

CREATE PROCEDURE [dbo].[up_update_pet_level]
@chat uniqueidentifier,
@auid uniqueidentifier,
@aa int,
@nn int,
@cc int

AS
GO


-- ----------------------------
-- procedure structure for US_WEB_GetLastMonitorUser_Log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[US_WEB_GetLastMonitorUser_Log]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[US_WEB_GetLastMonitorUser_Log]
GO

CREATE PROCEDURE [dbo].[US_WEB_GetLastMonitorUser_Log]
as 
set nocount on

DECLARE @date AS DATETIME
DECLARE @query AS VARCHAR(MAX)
DECLARE @tableName AS VARCHAR(100)

SET @date = GETDATE()

SET @tableName = 'MonitorUser_Log_' + CAST(YEAR(@date) AS CHAR(4)) + '_' + CAST(MONTH(@date) AS VARCHAR(2))

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = @tableName))
BEGIN

SET @query = 'SELECT TOP 1 CU_total as onlines FROM ' + @tableName + ' ORDER BY date DESC'
EXEC(@query)

END
GO


-- ----------------------------
-- procedure structure for Local_CreateAuctionTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateAuctionTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateAuctionTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateAuctionTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Auction_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2500)
	set @br='CREATE TABLE Auction_Log_'+ @year+'_'+@month+
	'(
	[log_id]				[bigint]	IDENTITY(1,1)	NOT NULL,
	[date]					[datetime]					NOT NULL CONSTRAINT [DF_Auction_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	[log_type]				[int]						NOT NULL,
	[world_id]				[int]					NOT NULL,
	[auth_id]				[uniqueidentifier],
	[character_id]			[uniqueidentifier],
	[character_name]		[nvarchar]			(16)	NOT NULL,
	[item_guid]				[uniqueidentifier]			NOT NULL,
	[item_id]				[int]						NOT NULL,
	[item_header]			[int]						NOT NULL,
	[enchant_level]			[tinyint]					NOT NULL,
	[item_active]			[int]						NOT NULL,
	[socket_count]			[tinyint]					NOT NULL,
	[remain_recon]			[tinyint]					NOT NULL,
	[durability]			[int]						NOT NULL,
	[item_option1]			[int]						NOT NULL,
	[item_option2]			[int]						NOT NULL,
	[item_option3]			[int]						NOT NULL,
	[item_option_value1]    [int]						NOT NULL,
	[item_option_value2]    [int]						NOT NULL,
	[item_option_value3]    [int]						NOT NULL,
	[item_socket_option1]	[int]						NOT NULL,
	[item_socket_option2]	[int]						NOT NULL,
	[item_socket_option3]	[int]						NOT NULL,
	[item_socket_value1]    [int]						NOT NULL,
	[item_socket_value2]    [int]						NOT NULL,
	[item_socket_value3]    [int]						NOT NULL,
	[item_socket_color1]	[int]						NOT NULL,
	[item_socket_color2]	[int]						NOT NULL,
	[item_socket_color3]	[int]						NOT NULL,
	[item_count]			[int]						NOT NULL,
	[start_price]			[int]						NOT NULL,
	[before_price]			[int]						NOT NULL,
	[buy_price]				[int]						NOT NULL,
	[guarantee_price]		[int]						NOT NULL,
	[commission]			[int]						NOT NULL,
	[auction_period]		[int]						NOT NULL,
	[before_money]			[int]						NOT NULL,
	[after_money]			[int]						NOT NULL,
	[change_money]			[int]						NOT NULL,
	[target_name]			[nvarchar]			(16),
	[result]	            [int]						NOT NULL,

	)'
	exec(@br)
	-----

	set @br='ALTER TABLE [dbo].[Auction_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Auction_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Auction_Log_'+ @year+'_'+ @month+'] ON [dbo].[Auction_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'

	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Auction_Log_'+ @year+'_'+ @month+'] ON [dbo].[Auction_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Auction_Log_'+ @year+'_'+ @month+'] ON [dbo].[Auction_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateCashBuyTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateCashBuyTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateCashBuyTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateCashBuyTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Cash_Buy_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE Cash_Buy_Log_'+ @year+'_'+@month+
	'(
					[log_id] [int] IDENTITY(1,1) NOT NULL,
					[date] [datetime]NOT NULL CONSTRAINT [DF_Cash_Buy_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
					[log_type] [int] NOT NULL,
					[world_id] [int] NOT NULL,
					[auth_id] [uniqueidentifier] NOT NULL,
					[bcust_id] [nvarchar](24) COLLATE Korean_Wansung_CI_AS NOT NULL,
					[character_name] [nvarchar](16) COLLATE Korean_Wansung_CI_AS NOT NULL,
					[gift_recvname] [nvarchar](16) COLLATE Korean_Wansung_CI_AS NOT NULL,
					[item_guid] [uniqueidentifier] NOT NULL,
					[item_id] [int] NOT NULL,
					[item_count] [int] NOT NULL,	
					[addopt1] [int] NOT NULL,
					[addopt2] [int] NOT NULL,
					[addopt3] [int] NOT NULL
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Cash_Buy_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Cash_Buy_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Cash_Buy_Log_'+ @year+'_'+ @month+'] ON [dbo].[Cash_Buy_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Cash_Buy_Log_'+ @year+'_'+ @month+'] ON [dbo].[Cash_Buy_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateCharacterTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateCharacterTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateCharacterTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateCharacterTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Character_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Character_Log_'+ @year+'_'+@month+
	'(
	[log_id]				[int]					IDENTITY(1,1)	NOT NULL, 
	[log_type]				[int]					NOT NULL, 
	[world_id]				[int]					NOT NULL,
	[auth_id]				[uniqueidentifier]		NOT NULL,
	[channel_id]			[smallint]				NOT NULL,
	[bcust_id]				[nvarchar]	(24)		NOT NULL,
	[character_id]			[uniqueidentifier]		NOT NULL,
	[character_name]		[nvarchar]	(16)		NOT NULL,
	[character_class]		[int]					NOT NULL,
	[character_Job]			[tinyint]					NOT NULL,
	[character_Level]		[tinyint]					NOT NULL,
	[guildpoint]			[int]					NOT NULL,
	[character_count]		[int]					NOT NULL,
	[b_character_name]		[nvarchar]	(16)		NOT NULL,
	[b_Job]					[tinyint]					NOT NULL,
	[b_Level]				[tinyint]					NOT NULL,
	[date]					[datetime]				NOT NULL	CONSTRAINT [DF_Character_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Character_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Character_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_Character_Log_'+ @year+'_'+ @month+'] ON [dbo].[Character_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Character_Log_'+ @year+'_'+ @month+'] ON [dbo].[Character_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Character_Log_'+ @year+'_'+ @month+'] ON [dbo].[Character_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Character_Log_'+ @year+'_'+ @month+'] ON [dbo].[Character_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateChatTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateChatTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateChatTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateChatTable]
	@createtime		datetime
as
set nocount on

declare @year	varchar(50)
declare @month	varchar(50)
declare @day	varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))
set @day	= convert(varchar, datepart(dd,@createtime))

if OBJECT_ID( 'Chat_Log_'+ @year+'_'+@month+'_'+@day )  IS  NULL
begin 
	declare @br varchar(4000)
	set @br='CREATE TABLE Chat_Log_'+ @year+'_'+@month+'_'+@day+
	'(
	[log_id]				[int]					IDENTITY(1,1)	NOT NULL, 
	[log_type]				[int]						NOT NULL, 
	[world_id]				[int]					NOT NULL, 
	[auth_id]				[uniqueidentifier]			NOT NULL, 
	[channel_group]			[int]					NOT NULL, 
	[channel_num]			[int]						NOT NULL, 
	[bcust_id]				[nvarchar]			(24)	NOT NULL, 
	[character_id]			[uniqueidentifier]			NOT NULL, 
	[character_name]		[nvarchar]			(16)	NOT NULL, 
	[chat_target]			[nvarchar]			(16)	NOT NULL, 
	[chats]					[nvarchar]			(100)	NOT NULL, 
	[date]					[datetime]					NOT NULL	CONSTRAINT [DF_Character_Log_'+ @year+'_'+ @month+'_'+ @day+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] ON [dbo].[Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] ON [dbo].[Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Chat_name_Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] ON [dbo].[Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] ON [dbo].[Chat_Log_'+ @year+'_'+ @month+'_'+@day+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateConnectionUVTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateConnectionUVTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateConnectionUVTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateConnectionUVTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Connection_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Connection_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[date] [datetime] NOT NULL DEFAULT (getdate()),	
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](24) NOT NULL,
			[continue_visit_count] [int] NOT NULL DEFAULT (0),
			[pc_bang] [tinyint] NOT NULL,
			[ip] [nvarchar](24) NOT NULL,
	) '
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Connection_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Connection_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_bcust_id_Connection_Log_'+ @year+'_'+ @month+'] ON [dbo].[Connection_Log_'+ @year+'_'+ @month+'] 
	(
		[bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_tem_Log_'+ @year+'_'+ @month+'] ON [dbo].[Connection_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_auth_id_Connection_Log_'+ @year+'_'+ @month+'] ON [dbo].[Connection_Log_'+ @year+'_'+ @month+'] 
	(
		[auth_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Connection_Log_'+ @year+'_'+ @month+'] ON [dbo].[Connection_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Connection_Log_'+ @year+'_'+ @month+'] ON [dbo].[Connection_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)

end
GO


-- ----------------------------
-- procedure structure for Local_CreateDungeonClearTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateDungeonClearTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateDungeonClearTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateDungeonClearTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'DungeonClear_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE DungeonClear_Log_'+ @year+'_'+@month+
	'(
		[log_id] [int] IDENTITY(1,1) NOT NULL,
		[date] [datetime] NOT NULL CONSTRAINT [DF_DungeonClear_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
		[log_type] [int] NOT NULL,
		[instance_id] [uniqueidentifier] NOT NULL,
		[bcust_id] [varchar](24) COLLATE Korean_Wansung_CI_AS NOT NULL,
		[character_id] [uniqueidentifier] NOT NULL,
		[character_name] [nvarchar](16) COLLATE Korean_Wansung_CI_AS NOT NULL,
		[character_class] [int] NOT NULL,
		[character_level] [int] NOT NULL,
		[membercountclear] [tinyint] NOT NULL,
		[clearrank] [nvarchar](4) COLLATE Korean_Wansung_CI_AS NOT NULL,
		[stylishpoint] [smallint] NOT NULL,
		[hitcount] [smallint] NOT NULL,
		[chain] [smallint] NOT NULL,
		[killcount] [smallint] NOT NULL,
		[cleartime] [int] NOT NULL,
		[cardid] [int] NOT NULL,
		[cardrewardid] [int] NOT NULL,
		[cardrewardcount] [int] NOT NULL,
		[addexp] [int] NOT NULL,
		[death] [tinyint] NOT NULL,
		[rebirth] [smallint] NOT NULL,
		[replay] [tinyint] NOT NULL,
		[dungeonid] [int] NOT NULL,
		[difficulty] [int] NOT NULL,
		[playpoint] [int] NOT NULL,
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[DungeonClear_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_DungeonClear_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_class_DungeonClear_Log_'+ @year+'_'+ @month+'] ON [dbo].[DungeonClear_Log_'+ @year+'_'+ @month+'] 
	(
		[character_class] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_entry_date_DungeonClear_Log_'+ @year+'_'+ @month+'] ON [dbo].[DungeonClear_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_tem_Log_'+ @year+'_'+ @month+'] ON [dbo].[DungeonClear_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateDungeonTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateDungeonTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateDungeonTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateDungeonTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Dungeon_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE Dungeon_Log_'+ @year+'_'+@month+
	'(
		[log_id] [int] IDENTITY(1,1) NOT NULL,
		[date] [datetime] NOT NULL CONSTRAINT [DF_Dungeon_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
		[log_type] [int] NOT NULL,
		[instance_id] [uniqueidentifier] NOT NULL,
		[world_id] [int] NOT NULL,
		[dungeon_id] [int] NOT NULL ,
		[difficulty] [tinyint] NOT NULL,
		[membercountstart] [tinyint] NOT NULL,
		[death] [tinyint] NOT NULL ,
		[rebirth] [tinyint] NOT NULL,		
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Dungeon_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Dungeon_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Dungeon_Log_'+ @year+'_'+ @month+'] ON [dbo].[Dungeon_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_DungeonID_Dungeon_Log_'+ @year+'_'+ @month+'] ON [dbo].[Dungeon_Log_'+ @year+'_'+ @month+'] 
	(
		[dungeon_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_Dungeon_Log_'+ @year+'_'+ @month+'] ON [dbo].[Dungeon_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Dungeon_Log_'+ @year+'_'+ @month+'] ON [dbo].[Dungeon_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateEnchantItemTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateEnchantItemTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateEnchantItemTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateEnchantItemTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'EnchantItem_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE EnchantItem_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](50) NOT NULL,			
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](50) NOT NULL,
			[item_guid] [uniqueidentifier] NOT NULL,
			[item_kind] [int] NOT NULL,
			[enchant_level] [int] NOT NULL,			
			[flag] [int] NOT NULL,			
			[date] [datetime] NOT NULL DEFAULT (getdate())
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[EnchantItem_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_EnchantItem_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_EnchantItem_Log_'+ @year+'_'+ @month+'] ON [dbo].[EnchantItem_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_EnchantItem_Log_'+ @year+'_'+ @month+'] ON [dbo].[EnchantItem_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)			
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_EnchantItem_Log_'+ @year+'_'+ @month+'] ON [dbo].[EnchantItem_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateGMInquiryTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateGMInquiryTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateGMInquiryTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateGMInquiryTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'GMInquiry_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE GMInquiry_'+ @year+'_'+@month+
	'(
			[log_id]				[bigint]			IDENTITY(1,1)	NOT NULL, 

			[inquiry_id]			[uniqueidentifier]	NOT NULL,
			[auth_id]				[uniqueidentifier]	NOT NULL,
			[char_id]				[uniqueidentifier]	NOT NULL,
			[world_id]				[int]			NOT NULL,
			[type]					[tinyint]			NOT NULL,
			[character_name]		[nvarchar]	(50)	NOT NULL,

			[state]					[tinyint]			NOT NULL,
			[online]				[tinyint]			NOT NULL,

			[bcust_id]				[nvarchar]	(20)	NOT NULL,
			[gm_name]				[nvarchar]	(20)	NOT NULL DEFAULT(0),
			[memo]					[nvarchar]	(255)	NOT NULL,

			[date]					[datetime] NOT NULL CONSTRAINT [DF_GMInquiry_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[GMInquiry_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_GMInquiry_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_inquiry_id_GMInquiry_'+ @year+'_'+ @month+'] ON [dbo].[GMInquiry_'+ @year+'_'+ @month+'] 
	(
		[inquiry_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_auth_id_GMInquiry_'+ @year+'_'+ @month+'] ON [dbo].[GMInquiry_'+ @year+'_'+ @month+'] 
	(
		[auth_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_GMInquiry_'+ @year+'_'+ @month+'] ON [dbo].[GMInquiry_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_type_GMInquiry_'+ @year+'_'+ @month+'] ON [dbo].[GMInquiry_'+ @year+'_'+ @month+'] 
	(
		[type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_GMInquiry_'+ @year+'_'+ @month+'] ON [dbo].[GMInquiry_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
end
GO


-- ----------------------------
-- procedure structure for Local_CreateGuildTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateGuildTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateGuildTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateGuildTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'tbl_guild_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE tbl_guild_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[date] [datetime] NOT NULL CONSTRAINT [DF_tbl_guild_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
			[log_type] [smallint] NOT NULL,
		    [world_id] [int] NOT NULL,
			[guild_id] [uniqueidentifier] NOT NULL,			
			
			[guild_name]	[nvarchar](20)	NOT NULL,
			[guild_master]	[nvarchar](16)	NOT NULL,
			[guild_member_count] [int]	NOT NULL,
			[guild_level]	[int]	NOT NULL,
			[guild_exp]	[bigint]	NOT NULL,
			[guild_skill_count]	[smallint]	NOT NULL,
			[guild_target]	[nvarchar](16)	NOT NULL,
			[auth_grade]	[nvarchar](20)	NOT NULL,
			[guild_point]	[int]	NOT NULL,			
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[tbl_guild_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_tbl_guild_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_tbl_guild_Log_'+ @year+'_'+ @month+'] ON [dbo].[tbl_guild_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)

end
GO


-- ----------------------------
-- procedure structure for Local_CreateInquiryChattingTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateInquiryChattingTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateInquiryChattingTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateInquiryChattingTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'InquiryChatting_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE InquiryChatting_Log_'+ @year+'_'+@month+
	'(
		[world_id]			[int]			NOT NULL, 
		[log_id]			[int]				NOT NULL, 
		[keyboarder]		[nvarchar]	(16)	NOT NULL,
		[chat_number]		[int]		 		NOT NULL, 
		[dialog]			[nvarchar]	(255)	NOT NULL,
		[date]				[datetime]			NOT NULL	CONSTRAINT [DF_InquiryChatting_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_id_InquiryChatting_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryChatting_Log_'+ @year+'_'+ @month+'] 
	(
		[log_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_InquiryChatting_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryChatting_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_keyboarder_InquiryChatting_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryChatting_Log_'+ @year+'_'+ @month+'] 
	(
		[keyboarder] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_InquiryChatting_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryChatting_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateInquiryCompleteTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateInquiryCompleteTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateInquiryCompleteTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateInquiryCompleteTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'InquiryComplete_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE InquiryComplete_Log_'+ @year+'_'+@month+
	'(
		[log_id]				[int]						NOT NULL, 
		[log_type]				[int]						NOT NULL, 
		[world_id]				[int]					NOT NULL, 
		[end_status]			[tinyint]					NOT NULL, 
		[start_status]			[tinyint]					NOT NULL, 
		[target_bcustno]		[nvarchar]	(16)			NOT NULL,
		[target_character]		[nvarchar]	(16)			NOT NULL,
		[GM]					[nvarchar]	(16)			NOT NULL,
		[former_GM]				[nvarchar]	(16)			NOT NULL,
		[remain_number]			[tinyint]					NOT NULL, 
		[inquery_use]			[nvarchar]	(16)			NOT NULL,
		[group_processing]		[nvarchar]	(16)			NOT NULL,
		[post_time]				[datetime]					NOT NULL,	
		[start_time]			[datetime]					NOT NULL,
		[end_time]				[datetime]					NOT NULL	CONSTRAINT [DF_InquiryComplete_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[InquiryComplete_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_InquiryComplete_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_InquiryComplete_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryComplete_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_InquiryComplete_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryComplete_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_target_bcustno_InquiryComplete_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryComplete_Log_'+ @year+'_'+ @month+'] 
	(
		[target_bcustno] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	----
	set @br='CREATE NONCLUSTERED INDEX [IX_GM_InquiryComplete_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryComplete_Log_'+ @year+'_'+ @month+'] 
	(
		[GM] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_end_time_InquiryComplete_Log_'+ @year+'_'+ @month+'] ON [dbo].[InquiryComplete_Log_'+ @year+'_'+ @month+'] 
	(
		[end_time] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateItemMailTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateItemMailTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateItemMailTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateItemMailTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'ItemMail_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2500)
	set @br='CREATE TABLE ItemMail_Log_'+ @year+'_'+@month+
	'(
[log_id]				[bigint]	IDENTITY(1,1)	NOT NULL,
[date]					[datetime]					NOT NULL CONSTRAINT [DF_ItemMail_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
[log_type]				[int]						NOT NULL,
[world_id]				[int]						NOT NULL,
[auth_id]				[uniqueidentifier]			NOT NULL,
[character_id]			[uniqueidentifier]			NOT NULL,
[character_name]		[nvarchar]			(16)	NOT NULL,
[item_guid]				[uniqueidentifier]			NOT NULL,
[item_ID]				[int]						NOT NULL,
[item_header]			[int]						NOT NULL,
[enchant_level]			[int]						NOT NULL,
[item_active]			[int]						NOT NULL,
[socket_count]			[tinyint]					NOT NULL,
[item_recon]			[tinyint]					NOT NULL,
[durability]			[int]						NOT NULL,
[item_option1]			[int]						NOT NULL,
[item_option2]			[int]						NOT NULL,
[item_option3]			[int]						NOT NULL,
[item_option_value1]	[int]						NOT NULL,
[item_option_value2]	[int]						NOT NULL,
[item_option_value3]	[int]						NOT NULL,
[item_socket_option1]	[int]						NOT NULL,
[item_socket_option2]	[int]						NOT NULL,
[item_socket_option3]	[int]						NOT NULL,
[item_socket_value1]	[int]						NOT NULL,
[item_socket_value2]	[int]						NOT NULL,
[item_socket_value3]	[int]						NOT NULL,
[item_socket_color1]	[int]						NOT NULL,
[item_socket_color2]	[int]						NOT NULL,
[item_socket_color3]	[int]						NOT NULL,
[item_count]			[int]						NOT NULL,
[before_money]			[int]						NOT NULL,
[after_money]			[int]						NOT NULL,
[change_money]			[int]						NOT NULL,
[target_name]			[nvarchar]	(16)			NOT NULL,
[mail_type]				[int]						NOT NULL,
)'
	exec(@br)
	-----

	set @br='ALTER TABLE [dbo].[ItemMail_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_ItemMail_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_ItemMail_Log_'+ @year+'_'+ @month+'] ON [dbo].[ItemMail_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'

	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_ItemMail_Log_'+ @year+'_'+ @month+'] ON [dbo].[ItemMail_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateItemsTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateItemsTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateItemsTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateItemsTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Items_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(4000)
	set @br='CREATE TABLE Items_Log_'+ @year+'_'+@month+
	'(
[log_id]				[bigint]	IDENTITY(1,1)	NOT NULL,
[date]					[datetime]					NOT NULL CONSTRAINT [DF_Items_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
[log_type]				[int]						NOT NULL,
[world_id]				[int]						NOT NULL,
[auth_id]				[uniqueidentifier]			NOT NULL,
[character_id]			[uniqueidentifier]			NOT NULL,
[character_name]		[nvarchar]			(16)	NOT NULL,
[item_guid]				[uniqueidentifier]			NOT NULL,
[item_ID]				[int]						NOT NULL,
[item_header]			[int]						NOT NULL,
[enchant_level]			[int]						NOT NULL,
[item_active]			[int]						NOT NULL,
[socket_count]			[tinyint]					NOT NULL,
[item_recon]			[tinyint]					NOT NULL,
[durability]			[int]						NOT NULL,
[item_option1]			[int]						NOT NULL,
[item_option2]			[int]						NOT NULL,
[item_option3]			[int]						NOT NULL,
[item_option_value1]	[int]						NOT NULL,
[item_option_value2]	[int]						NOT NULL,
[item_option_value3]	[int]						NOT NULL,
[item_socket_option1]	[int]						NOT NULL,
[item_socket_option2]	[int]						NOT NULL,
[item_socket_option3]	[int]						NOT NULL,
[item_socket_value1]	[int]						NOT NULL,
[item_socket_value2]	[int]						NOT NULL,
[item_socket_value3]	[int]						NOT NULL,
[item_socket_color1]	[int]						NOT NULL,
[item_socket_color2]	[int]						NOT NULL,
[item_socket_color3]	[int]						NOT NULL,
[item_count]			[int]						NOT NULL,
[before_money]			[int]						NOT NULL,
[after_money]			[int]						NOT NULL,
[change_money]			[int]						NOT NULL,
[before_date]			[int]						NOT NULL,
[after_date]			[int]						NOT NULL,
[result]				[int]						NOT NULL,
)'
	exec(@br)
	-----

	set @br='ALTER TABLE [dbo].[Items_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Items_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Items_Log_'+ @year+'_'+ @month+'] ON [dbo].[Items_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'

	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Items_Log_'+ @year+'_'+ @month+'] ON [dbo].[Items_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	

	set @br='CREATE NONCLUSTERED INDEX [IX_date_Items_Log_'+ @year+'_'+ @month+'] ON [dbo].[Items_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateItemTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateItemTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateItemTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateItemTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Item_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Item_Log_'+ @year+'_'+@month+
	'(
			[log_id] [int] IDENTITY(1,1) NOT NULL,
			[date] [datetime] NOT NULL CONSTRAINT [DF_Item_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
			[log_type] [int] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](24) COLLATE Korean_Wansung_CI_AS NOT NULL,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](16) COLLATE Korean_Wansung_CI_AS NOT NULL,
			[item_guid] [uniqueidentifier] NOT NULL,
			[item_id] [int] NOT NULL,
			[item_header] [int] NOT NULL,
			[enchant_level] [tinyint] NOT NULL,
			[item_active] [int] NOT NULL,
			[socket_count] [tinyint] NOT NULL,
			[remain_recon] [tinyint] NOT NULL,
			[item_option1] [int] NOT NULL,
			[item_option2] [int] NOT NULL,
			[item_option3] [int] NOT NULL,
			[item_count] [int] NOT NULL,
			[target_itemid] [int] NOT NULL,
			[before_money] [int] NOT NULL,
			[after_money] [int] NOT NULL,
			[change_money] [int] NOT NULL,
			[result] [int] NOT NULL,
			[item_option_value1] [int] NOT NULL,
			[item_option_value2] [int] NOT NULL,
			[item_option_value3] [int] NOT NULL,				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Item_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Item_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
/*	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_bcust_id_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_id_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_item_guid_Item_Log_'+ @year+'_'+ @month+'] ON [dbo].[Item_Log_'+ @year+'_'+ @month+'] 
	(
		[item_guid] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
*/	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateItemTradeTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateItemTradeTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateItemTradeTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateItemTradeTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'ItemTrade_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(4000)
	set @br='CREATE TABLE ItemTrade_Log_'+ @year+'_'+@month+
	'(
	[log_id]				[int]					IDENTITY(1,1)	NOT NULL, 
	[date]					[datetime]				NOT NULL CONSTRAINT [DF_ItemTrade_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	[log_type]				[int]					NOT NULL,
	[world_id]				[int]					NOT NULL,
	[auth_id]				[uniqueidentifier]		NOT NULL,
	[bcust_id]				[nvarchar]	(24)		NOT NULL,
	[character_id]			[uniqueidentifier]		NOT NULL,
	[character_name]		[nvarchar]	(16)		NOT NULL,
	[other_auth_id]			[uniqueidentifier]		NOT NULL,
	[other_bcust_id]		[nvarchar]	(16)		NOT NULL,
	[other_character_id]	[uniqueidentifier]		NOT NULL,
	[other_character_name]	[nvarchar]	(16)		NOT NULL,
	[item_guid]				[uniqueidentifier]		NOT NULL,
	[item_ID]				[int]					NOT NULL,
	[item_header]			[int]					NOT NULL,
	[enchant_level]			[int]					NOT NULL,
	[item_active]			[int]					NOT NULL,
	[socket_count]			[tinyint]				NOT NULL,
	[item_recon]			[tinyint]				NOT NULL,
	[durability]			[int]					NOT NULL,
	[item_option1]			[int]					NOT NULL,
	[item_option2]			[int]					NOT NULL,
	[item_option3]			[int]					NOT NULL,
	[item_option_value1]	[int]					NOT NULL,
	[item_option_value2]	[int]					NOT NULL,
	[item_option_value3]	[int]					NOT NULL,
	[item_socket_option1]	[int]					NOT NULL,
	[item_socket_option2]	[int]					NOT NULL,
	[item_socket_option3]	[int]					NOT NULL,
	[item_socket_value1]	[int]					NOT NULL,
	[item_socket_value2]	[int]					NOT NULL,
	[item_socket_value3]	[int]					NOT NULL,
	[item_socket_color1]	[int]					NOT NULL,
	[item_socket_color2]	[int]					NOT NULL,
	[item_socket_color3]	[int]					NOT NULL,
	[before_money]			[int]					NOT NULL,
	[after_money]			[int]					NOT NULL,
	[change_money]			[int]					NOT NULL,
	[item_count]			[int]					NOT NULL,
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[ItemTrade_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_ItemTrade_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_ItemTrade_Log_'+ @year+'_'+ @month+'] ON [dbo].[ItemTrade_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_ItemTrade_Log_'+ @year+'_'+ @month+'] ON [dbo].[ItemTrade_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_ItemTrade_Log_'+ @year+'_'+ @month+'] ON [dbo].[ItemTrade_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_ItemTrade_Log_'+ @year+'_'+ @month+'] ON [dbo].[ItemTrade_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateLearnSkillTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateLearnSkillTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateLearnSkillTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateLearnSkillTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'LearnSkill_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE LearnSkill_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[date] [datetime] NOT NULL CONSTRAINT [DF_LearnSkill_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
			[log_type] [int] NOT NULL,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](16) NOT NULL,
			[skill_table_id] [int] NOT NULL,
			[skill_level]    [tinyint] NOT NULL,
			[character_Class] [int] NOT NULL,
			[character_Level] [tinyint] NOT NULL,
			[skillpoint_use] [int] NOT NULL,			
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[LearnSkill_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_LearnSkill_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_class_LearnSkill_Log_'+ @year+'_'+ @month+'] ON [dbo].[LearnSkill_Log_'+ @year+'_'+ @month+'] 
	(
		[character_Class] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_LearnSkill_Log_'+ @year+'_'+ @month+'] ON [dbo].[LearnSkill_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_level_LearnSkill_Log_'+ @year+'_'+ @month+'] ON [dbo].[LearnSkill_Log_'+ @year+'_'+ @month+'] 
	(
		[character_Level] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_LearnSkill_Log_'+ @year+'_'+ @month+'] ON [dbo].[LearnSkill_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateLevelUpTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateLevelUpTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateLevelUpTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateLevelUpTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'LevelUp_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE LevelUp_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](50) NOT NULL,			
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](50) NOT NULL,
			[character_class] [int] NOT NULL,
			[character_level] [int] NOT NULL,
			[record_date] [datetime] NOT NULL,
			[date] [datetime] NOT NULL CONSTRAINT [DF_LevelUp_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[LevelUp_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_LevelUp_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_LevelUp_Log_'+ @year+'_'+ @month+'] ON [dbo].[LevelUp_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_class_LevelUp_Log_'+ @year+'_'+ @month+'] ON [dbo].[LevelUp_Log_'+ @year+'_'+ @month+'] 
	(
		[character_class] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_LevelUp_Log_'+ @year+'_'+ @month+'] ON [dbo].[LevelUp_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_level_LevelUp_Log_'+ @year+'_'+ @month+'] ON [dbo].[LevelUp_Log_'+ @year+'_'+ @month+'] 
	(
		[character_level] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_LevelUp_Log_'+ @year+'_'+ @month+'] ON [dbo].[LevelUp_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateLoginLogTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateLoginLogTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateLoginLogTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateLoginLogTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Login_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Login_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](24) NOT NULL,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](50) NOT NULL,
			[ChannelID] [smallint] NOT NULL,
			[IP] [char](24) NOT NULL,

			[date] [datetime] NOT NULL DEFAULT (getdate()),
			inven_gold		[int] NOT NULL ,
			storage_gold	[int] NOT NULL ,
			character_level [smallint] NOT NULL ,
			character_exp	[bigint] NOT NULL ,
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Login_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Login_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_bcust_id_Login_Log_'+ @year+'_'+ @month+'] ON [dbo].[Login_Log_'+ @year+'_'+ @month+'] 
	(
		[bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_charid_Login_Log_'+ @year+'_'+ @month+'] ON [dbo].[Login_Log_'+ @year+'_'+ @month+'] 
	(
		[character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_charname_Login_Log_'+ @year+'_'+ @month+'] ON [dbo].[Login_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Login_Log_'+ @year+'_'+ @month+'] ON [dbo].[Login_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_Login_Log_'+ @year+'_'+ @month+'] ON [dbo].[Login_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)

end
GO


-- ----------------------------
-- procedure structure for Local_CreateLoginOutTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateLoginOutTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateLoginOutTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateLoginOutTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'LoginOut_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE LoginOut_Log_'+ @year+'_'+@month+
	'(
			[log_id]			[bigint] IDENTITY(1,1) NOT NULL, 
			[date]				[datetime] NOT NULL CONSTRAINT [DF_LoginOut_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
			[log_type]			[smallint] NOT NULL,
		 	   [world_id]			[int] NOT NULL,
			[auth_id]			[uniqueidentifier]	NOT NULL,
			[channel_group]		[tinyint]	NOT NULL,
			[channel_num]		[int]	NOT NULL,
			[bcust_id]			[nvarchar](16)	NOT NULL,
			[character_id]		[uniqueidentifier]	NOT NULL,
			[character_name]	[nvarchar](16)	NOT NULL,
			[inven_gold]		[int]	NOT NULL,
			[storage_gold]		[int]	NOT NULL,
			[character_level]	[tinyint]	NOT NULL,
			[character_exp]	    [int]	NOT NULL,
			[targetmap]			[int]	NOT NULL,
			[playpoint]			[int]	NOT NULL,
			[skillpoint]		[int]	NOT NULL,
			[guildpoint]		[int]	NOT NULL,
			[coin]				[int]	NOT NULL,					
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[LoginOut_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_LoginOut_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	
	set @br='CREATE NONCLUSTERED INDEX [IX_date_LoginOut_Log_'+ @year+'_'+ @month+'] ON [dbo].[LoginOut_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)

end
GO


-- ----------------------------
-- procedure structure for Local_CreateLogoutLogTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateLogoutLogTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateLogoutLogTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateLogoutLogTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Logout_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Logout_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](50) NOT NULL,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](50) NOT NULL,
			[ChannelID] [smallint] NOT NULL,
			[IP] [char](16) NOT NULL,

			[date] [datetime] NOT NULL DEFAULT (getdate()),
			inven_gold		[int] NOT NULL ,
			storage_gold	[int] NOT NULL ,
			character_level [smallint] NOT NULL ,
			character_exp	[bigint] NOT NULL ,		
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Logout_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Logout_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_bcust_id_Logout_Log_'+ @year+'_'+ @month+'] ON [dbo].[Logout_Log_'+ @year+'_'+ @month+'] 
	(
		[bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_charid_Logout_Log_'+ @year+'_'+ @month+'] ON [dbo].[Logout_Log_'+ @year+'_'+ @month+'] 
	(
		[character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_charname_Logout_Log_'+ @year+'_'+ @month+'] ON [dbo].[Logout_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_Logout_Log_'+ @year+'_'+ @month+'] ON [dbo].[Logout_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Logout_Log_'+ @year+'_'+ @month+'] ON [dbo].[Logout_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateMailTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateMailTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateMailTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateMailTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Mail_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE Mail_Log_'+ @year+'_'+@month+
	'(
			[log_id]         [bigint] IDENTITY(1,1) NOT NULL, 
			[date]           [datetime] NOT NULL CONSTRAINT [DF_Mail_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
			[log_type]       [smallint] NOT NULL,
		    [world_id]       [int] NOT NULL,			
			[auth_id]	     [uniqueidentifier]	NULL,
			[channel_group]	 [tinyint]	NULL,
			[channel_num]	 [int]	NULL,
			[mail_id]	     [uniqueidentifier]	NULL,
			[bcust_id]	     [nvarchar](16)	NULL,
			[character_id]	 [uniqueidentifier]	NULL,
			[character_name] [nvarchar](16)	NULL,
			[receiver_name]	 [nvarchar](16)	NULL,
			[msg]	         [nvarchar](50)	NULL,
			[return_day]	 [int]	NULL,
			[req_gold]	     [int]	NULL,
		
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Mail_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Mail_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Mail_Log_'+ @year+'_'+ @month+'] ON [dbo].[Mail_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)

end
GO


-- ----------------------------
-- procedure structure for Local_CreateMCUTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateMCUTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateMCUTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateMCUTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'MCU_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE MCU_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[user_num] [int] NOT NULL DEFAULT (0),
			[date] [datetime] NOT NULL DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[MCU_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_MCU_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_MCU_Log_'+ @year+'_'+ @month+'] ON [dbo].[MCU_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_MCU_Log_'+ @year+'_'+ @month+'] ON [dbo].[MCU_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_tem_Log_'+ @year+'_'+ @month+'] ON [dbo].[MCU_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreateMoneyTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateMoneyTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateMoneyTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateMoneyTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Money_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Money_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](50) NOT NULL,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](50) NOT NULL,

			[other_auth_id] [uniqueidentifier] NULL,
			[other_bcust_id] [nvarchar](50) NULL,
			[other_character_id] [uniqueidentifier] NULL,
			[other_character_name] [nvarchar](50) NULL,

			[before_money] [int] NOT NULL,
			[after_money] [int] NOT NULL,
			[change_money] [int] NOT NULL,

			[entry_date] [datetime] NOT NULL CONSTRAINT [DF_Money_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Money_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Money_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_entry_date_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[entry_date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_bcust_id_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_id_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_other_auth_id_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[other_auth_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_other_bcust_id_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[other_bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_other_character_id_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[other_character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)		
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_other_character_name_Money_Log_'+ @year+'_'+ @month+'] ON [dbo].[Money_Log_'+ @year+'_'+ @month+'] 
	(
		[other_character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateMonitorCommandTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateMonitorCommandTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateMonitorCommandTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateMonitorCommandTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'MonitorCommand_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE MonitorCommand_Log_'+ @year+'_'+@month+
	'(
		[log_id]				[int]					IDENTITY(1,1)	NOT NULL,
		[log_type]				[int]					NOT NULL,
		[world_ID]				[int]					NOT NULL,
		[channel_ID]			[int]					NOT NULL,
		[executer_ID]			[nvarchar]	(16)		NOT NULL,
		[command]				[int]					NOT NULL,
		[target]				[int]					NOT NULL,
		[date]					[datetime]				NOT NULL	CONSTRAINT [DF_MonitorCommand_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[MonitorCommand_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_MonitorCommand_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_MonitorCommand_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorCommand_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_MonitorCommand_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorCommand_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_MonitorCommand_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorCommand_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateMonitorNoticeTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateMonitorNoticeTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateMonitorNoticeTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateMonitorNoticeTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'MonitorNotice_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE MonitorNotice_Log_'+ @year+'_'+@month+
	'(
	[log_id]		[int]				IDENTITY(1,1)	NOT NULL, 
	[log_type]		[int]								NOT NULL, 
	[world_id]		[int]							NOT NULL, 
	[target]		[tinyint]							NOT NULL, 
	[notice_type]	[tinyint]							NOT NULL, 
	[notice_cycle]	[tinyint]							NOT NULL, 
	[notice]		[nvarchar]	(255)					NOT NULL, 
	[gm_ID]			[nvarchar]	(16)					NOT NULL, 
	[date]			[datetime]							NOT NULL	CONSTRAINT [DF_MonitorNotice_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[MonitorNotice_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_MonitorNotice_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_MonitorNotice_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorNotice_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_MonitorNotice_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorNotice_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_gm_ID_MonitorNotice_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorNotice_Log_'+ @year+'_'+ @month+'] 
	(
		[gm_ID] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_MonitorNotice_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorNotice_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateMonitorUserTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateMonitorUserTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateMonitorUserTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateMonitorUserTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'MonitorUser_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE MonitorUser_Log_'+ @year+'_'+@month+
	'(


	[log_id]				[int]					IDENTITY(1,1)	NOT NULL, 
	[log_type]				[int]					NOT NULL, 
	[world_id]				[int]					NOT NULL,
	[CU_gate]				[int]					NOT NULL,
	[CU_lobby]				[int]					NOT NULL,
	[CU_PVP]				[int]					NOT NULL,
	[CU_dungeon]			[int]					NOT NULL,
	[CU_total]				[int]					NOT NULL,
	[date]					[datetime]				NOT NULL	CONSTRAINT [DF_MonitorUser_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
	)'

	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[MonitorUser_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_MonitorUser_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_MonitorUser_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorUser_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_MonitorUser_Log_'+ @year+'_'+ @month+'] ON [dbo].[MonitorUser_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreatePacketOverloadLogTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreatePacketOverloadLogTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreatePacketOverloadLogTable]
GO

CREATE PROCEDURE [dbo].[Local_CreatePacketOverloadLogTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'PacketOverload_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE PacketOverload_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[func_name] [char](100) NOT NULL,
			[time] [int] NOT NULL DEFAULT (0),
			[date] [datetime] NOT NULL DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[PacketOverload_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_PacketOverload_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_PacketOverload_Log_'+ @year+'_'+ @month+'] ON [dbo].[PacketOverload_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO


-- ----------------------------
-- procedure structure for Local_CreatePTTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreatePTTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreatePTTable]
GO

CREATE PROCEDURE [dbo].[Local_CreatePTTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'PT_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE PT_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[log_type] [smallint] NOT NULL,
			[world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[bcust_id] [nvarchar](50) NOT NULL,
			[ChannelID] [smallint] NOT NULL,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](50) NOT NULL,
			[character_class] [int] NOT NULL,
			[character_level] [int] NOT NULL,
			[p_start_date] [datetime] NOT NULL,
			[p_end_date] [datetime] NOT NULL,			
			[date] [datetime] NOT NULL CONSTRAINT [DF_PT_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[PT_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_PT_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_world_id_PT_Log_'+ @year+'_'+ @month+'] ON [dbo].[PT_Log_'+ @year+'_'+ @month+'] 
	(
		[world_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_class_PT_Log_'+ @year+'_'+ @month+'] ON [dbo].[PT_Log_'+ @year+'_'+ @month+'] 
	(
		[character_class] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)	
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_entry_date_PT_Log_'+ @year+'_'+ @month+'] ON [dbo].[PT_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_logtype_PT_Log_'+ @year+'_'+ @month+'] ON [dbo].[PT_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreatePvpBattleTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreatePvpBattleTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreatePvpBattleTable]
GO

CREATE PROCEDURE [dbo].[Local_CreatePvpBattleTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Pvp_Battle_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Pvp_Battle_Log_'+ @year+'_'+@month+
	'(
			[log_id]				[bigint]			IDENTITY(1,1)	NOT NULL, 
			[log_type]				[smallint]			NOT NULL,

			[bcust_id]				[nvarchar]	(24)	NOT NULL,
			[character_id]			[uniqueidentifier]	NOT NULL,
			[character_name]		[nvarchar]	(16)	NOT NULL,
			[character_class]		[int]			NOT NULL,
			[character_level]		[int]				NOT NULL,

			[channel_type]			[int]				NOT NULL,

			[room_id]				[uniqueidentifier]	NOT NULL,
			[room_world]			[int]			NOT NULL,
			[room_type]				[int]				NOT NULL,

			[red_leader_id]			[uniqueidentifier],
			[red_leader_name]		[nvarchar]	(16),
			[red_name1]				[nvarchar]	(16),
			[red_name2]				[nvarchar]	(16),
			[red_name3]				[nvarchar]	(16),
			[red_name4]				[nvarchar]	(16),
			[red_kill_count]		[smallint],
			[red_total_damage]		[int],

			[blue_leader_id]		[uniqueidentifier],
			[blue_leader_name]		[nvarchar]	(16),
			[blue_name1]			[nvarchar]	(16),
			[blue_name2]			[nvarchar]	(16),
			[blue_name3]			[nvarchar]	(16),
			[blue_name4]			[nvarchar]	(16),
			[blue_kill_count]		[smallint],
			[blue_total_damage]		[int],

			[user_start_count]		[smallint]			NOT NULL,
			[user_end_count]		[smallint]			NOT NULL,

			[win_character_name]	[nvarchar]	(16)	NOT NULL,
			[win_team]				[smallint]			NOT NULL,

			[clear_time]			[int]				NOT NULL,

			[date] [datetime] NOT NULL CONSTRAINT [DF_Pvp_Battle_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Pvp_Battle_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Pvp_Battle_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_channel_type_Pvp_Battle_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Battle_Log_'+ @year+'_'+ @month+'] 
	(
		[channel_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_room_world_Pvp_Battle_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Battle_Log_'+ @year+'_'+ @month+'] 
	(
		[room_world] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)

	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_room_id_Pvp_Battle_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Battle_Log_'+ @year+'_'+ @month+'] 
	(
		[room_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_room_type_Pvp_Battle_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Battle_Log_'+ @year+'_'+ @month+'] 
	(
		[room_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Pvp_Battle_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Battle_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreatePvpDeathTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreatePvpDeathTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreatePvpDeathTable]
GO

CREATE PROCEDURE [dbo].[Local_CreatePvpDeathTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Pvp_Death_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Pvp_Death_Log_'+ @year+'_'+@month+
	'(
			[log_id]				[bigint]			IDENTITY(1,1)	NOT NULL, 
			[log_type]				[smallint]			NOT NULL,

			[room_id]				[uniqueidentifier]	NOT NULL,

			[character_id]			[uniqueidentifier]	NOT NULL,
			[character_name]		[nvarchar]	(16)	NOT NULL,
			[character_class]		[int]			NOT NULL,
			[character_job]			[tinyint]			NOT NULL,
			[character_level]		[int]				NOT NULL,


			[kill_id]			[uniqueidentifier]	NOT NULL,
			[kill_name]			[nvarchar]	(16)	NOT NULL,
			[kill_class]		[int]			NOT NULL,
			[kill_job]			[tinyint]			NOT NULL,
			[kill_level]		[int]				NOT NULL,

			[date] [datetime] NOT NULL CONSTRAINT [DF_Pvp_Death_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)

	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_room_id_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[room_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_id_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_class_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[character_class] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_job_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[character_job] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_character_level_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[character_level] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
		-----
	set @br='CREATE NONCLUSTERED INDEX [IX_kill_id_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[kill_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_kill_name_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[kill_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_kill_class_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[kill_class] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_kill_job_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[kill_job] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_kill_level_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[kill_level] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Pvp_Death_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Death_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)


end
GO


-- ----------------------------
-- procedure structure for Local_CreatePvpResultTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreatePvpResultTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreatePvpResultTable]
GO

CREATE PROCEDURE [dbo].[Local_CreatePvpResultTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Pvp_Result_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Pvp_Result_Log_'+ @year+'_'+@month+
	'(
			[log_id]			[bigint]			IDENTITY(1,1)	NOT NULL, 
			[log_type]			[smallint]			NOT NULL,
			[auth_id]			[uniqueidentifier]	NOT NULL,
			[bcust_id]			[nvarchar]	(24)	NOT NULL,
			[character_id]		[uniqueidentifier]	NOT NULL,
			[character_name]	[nvarchar]	(16)	NOT NULL,
			[character_class]	[int]			NOT NULL,
			[character_level]	[int]				NOT NULL,
			[channel_type]		[int]				NOT NULL,
			[room_id]			[uniqueidentifier]	NOT NULL,
			[room_world]		[int]			NOT NULL,
			[room_type]			[int]				NOT NULL,
			[PZoneID]			[int]				NOT NULL,
			[pvp_team]			[smallint]			NOT NULL,
			[pvp_score]			[int]				NOT NULL,
			[pvp_point]			[int]				NOT NULL,
			[pvp_grade]			[int]				NOT NULL,
			[pvp_totalscore]	[int]				NOT NULL,
			[pvp_totalpoint]	[int]				NOT NULL,
			[pvp_rank]			[int]				NOT NULL,
			[pvp_kill]			[int]				NOT NULL,
			[pvp_die]			[int]				NOT NULL,
			[pvp_damage]		[int]				NOT NULL,
			[pvp_cleartime]		[int]				NOT NULL,
			[date] [datetime] NOT NULL CONSTRAINT [DF_Pvp_Result_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Pvp_Result_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Pvp_Result_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_Pvp_Result_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Result_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_bcust_id_Pvp_Result_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Result_Log_'+ @year+'_'+ @month+'] 
	(
		[bcust_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Pvp_Result_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Result_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_room_world_Pvp_Result_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Result_Log_'+ @year+'_'+ @month+'] 
	(
		[room_world] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Pvp_Result_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Result_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreatePvpRoomTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreatePvpRoomTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreatePvpRoomTable]
GO

CREATE PROCEDURE [dbo].[Local_CreatePvpRoomTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Pvp_Room_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(1500)
	set @br='CREATE TABLE Pvp_Room_Log_'+ @year+'_'+@month+
	'(
			[log_id]			[bigint]			IDENTITY(1,1)	NOT NULL, 
			[log_type]			[smallint]			NOT NULL,
			[auth_id]			[uniqueidentifier]	NOT NULL,
			[character_id]		[uniqueidentifier]	NOT NULL,
			[character_name]	[nvarchar](16)		NOT NULL,
			[channel_type]		[int]				NOT NULL,
			[room_id]			[uniqueidentifier]	NOT NULL,
			[room_world]		[int]			NOT NULL,
			[room_number]		[int]				NOT NULL,
			[room_name]			[nvarchar](50)		NOT NULL,
			[date] [datetime] NOT NULL CONSTRAINT [DF_Pvp_Room_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),				
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Pvp_Room_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_log_type_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[log_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_room_world_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[room_world] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_auth_id_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[auth_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Channel_type_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[Channel_type] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Room_id_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[Room_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Room_number_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[Room_number] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Room_name_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[Room_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Character_id_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[Character_id] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_Character_name_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[Character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Pvp_Room_Log_'+ @year+'_'+ @month+'] ON [dbo].[Pvp_Room_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	
end
GO


-- ----------------------------
-- procedure structure for Local_CreateQuestTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Local_CreateQuestTable]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[Local_CreateQuestTable]
GO

CREATE PROCEDURE [dbo].[Local_CreateQuestTable]
	@createtime		datetime
as
set nocount on

declare @year varchar(50)
declare @month varchar(50)

set @year	= convert(varchar, datepart(yy,@createtime))
set @month	= convert(varchar, datepart(mm,@createtime))

if OBJECT_ID( 'Quest_Log_'+ @year+'_'+@month )  IS  NULL
begin 
	declare @br varchar(2000)
	set @br='CREATE TABLE Quest_Log_'+ @year+'_'+@month+
	'(
			[log_id] [bigint] IDENTITY(1,1) NOT NULL, 
			[date] [datetime] NOT NULL CONSTRAINT [DF_Quest_Log_'+ @year+'_'+ @month+'_entry_date]  DEFAULT (getdate()),
			[log_type] [smallint] NOT NULL,
		    [world_id] [int] NOT NULL,
			[auth_id] [uniqueidentifier] NOT NULL,
			[channel_id] [smallint] NOT NULL,
			[bcust_id] [nvarchar](24) ,
			[character_id] [uniqueidentifier] NOT NULL,
			[character_name] [nvarchar](16) NOT NULL,
			[character_class] [int] NOT NULL,
			[character_job] [tinyint] NOT NULL,
			[character_level] [tinyint] NOT NULL,
			[quest_id] [int] NOT NULL,
			[quest_type] [int] NOT NULL,
			[quest_exp] [int] NOT NULL,			
	)'
	exec(@br)
	-----
	set @br='ALTER TABLE [dbo].[Quest_Log_'+ @year+'_'+ @month+'] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_id_Quest_Log_'+ @year+'_'+ @month+'] PRIMARY KEY  CLUSTERED 
	(
		[log_id] ASC
	)  ON [PRIMARY]' 
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_character_name_Quest_Log_'+ @year+'_'+ @month+'] ON [dbo].[Quest_Log_'+ @year+'_'+ @month+'] 
	(
		[character_name] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
	-----
	set @br='CREATE NONCLUSTERED INDEX [IX_date_Quest_Log_'+ @year+'_'+ @month+'] ON [dbo].[Quest_Log_'+ @year+'_'+ @month+'] 
	(
		[date] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]'
	exec(@br)
end
GO

