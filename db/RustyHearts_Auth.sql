/*
 Navicat Premium Data Transfer

 Source Server         : RH VM
 Source Server Type    : SQL Server
 Source Server Version : 16001105
 Source Host           : 192.168.100.3:1433
 Source Catalog        : RustyHearts_Auth
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001105
 File Encoding         : 65001

 Date: 12/12/2023 01:48:09
*/


-- ----------------------------
-- Table structure for AgentAccount
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[AgentAccount]') AND type IN ('U'))
	DROP TABLE [dbo].[AgentAccount]
GO

CREATE TABLE [dbo].[AgentAccount] (
  [Account] nvarchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [Password] nvarchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [Permission] int DEFAULT 0 NOT NULL
)
GO

ALTER TABLE [dbo].[AgentAccount] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of AgentAccount
-- ----------------------------
INSERT INTO [dbo].[AgentAccount] ([Account], [Password], [Permission]) VALUES (N'admin', N'21232f297a57a5a743894a0e4a801fc3', N'10')
GO


-- ----------------------------
-- Table structure for AuthTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[AuthTable]') AND type IN ('U'))
	DROP TABLE [dbo].[AuthTable]
GO

CREATE TABLE [dbo].[AuthTable] (
  [WindyCode] nvarchar(50) COLLATE Chinese_PRC_CI_AS DEFAULT '00-00-00-00-00-00' NOT NULL,
  [world_id] smallint  NULL,
  [AuthID] uniqueidentifier  NOT NULL,
  [Tcount] int  NOT NULL,
  [online] char(1) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [CTime] datetime  NOT NULL,
  [BTime] datetime  NOT NULL,
  [LTime] datetime  NOT NULL,
  [IP] varchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [LCount] bigint  NOT NULL,
  [ServerIP] varchar(16) COLLATE Chinese_PRC_CI_AS  NULL,
  [ServerType] char(1) COLLATE Chinese_PRC_CI_AS  NULL,
  [HostID] int  NULL,
  [DBCIndex] smallint DEFAULT -1 NOT NULL,
  [InquiryCount] tinyint DEFAULT 0 NOT NULL,
  [event_inquiry] tinyint DEFAULT 0 NOT NULL,
  [CashMileage] int DEFAULT 0 NOT NULL,
  [channelling] int DEFAULT 1 NOT NULL,
  [pc_room_point] int  NOT NULL,
  [externcash] int DEFAULT 0 NOT NULL,
  [mac_addr] char(18) COLLATE Chinese_PRC_CI_AS DEFAULT '00-00-00-00-00-00' NOT NULL,
  [mac_addr02] char(18) COLLATE Chinese_PRC_CI_AS DEFAULT '00-00-00-00-00-00' NOT NULL,
  [mac_addr03] char(18) COLLATE Chinese_PRC_CI_AS DEFAULT '00-00-00-00-00-00' NOT NULL,
  [second_pass] varchar(32) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL
)
GO

ALTER TABLE [dbo].[AuthTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of AuthTable
-- ----------------------------
INSERT INTO [dbo].[AuthTable] ([WindyCode], [world_id], [AuthID], [Tcount], [online], [CTime], [BTime], [LTime], [IP], [LCount], [ServerIP], [ServerType], [HostID], [DBCIndex], [InquiryCount], [event_inquiry], [CashMileage], [channelling], [pc_room_point], [externcash], [mac_addr], [mac_addr02], [mac_addr03], [second_pass]) VALUES (N'ragezone', N'0', N'43375723-4816-4FFF-98B1-1E80EC25BA50', N'0', N'0', N'2023-05-27 19:12:19.897', N'2023-12-11 19:08:30.783', N'2023-12-11 18:32:48.483', N'192.168.100.2', N'557', N'192.168.100.3', N'L', N'33', N'0', N'5', N'1', N'42472', N'1', N'0', N'0', N'00-00-00-00-00-00 ', N'00-00-00-00-00-00 ', N'00-00-00-00-00-00 ', N'')
GO


-- ----------------------------
-- Table structure for BlackListTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackListTable]') AND type IN ('U'))
	DROP TABLE [dbo].[BlackListTable]
GO

CREATE TABLE [dbo].[BlackListTable] (
  [IP] nvarchar(15) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [State] bigint DEFAULT 0 NOT NULL,
  [Cause] nvarchar(50) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [GmID] nvarchar(15) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [Type] smallint DEFAULT 0 NOT NULL,
  [Use] tinyint DEFAULT 0 NOT NULL
)
GO

ALTER TABLE [dbo].[BlackListTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of BlackListTable
-- ----------------------------

-- ----------------------------
-- Table structure for ChannelOption
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ChannelOption]') AND type IN ('U'))
	DROP TABLE [dbo].[ChannelOption]
GO

CREATE TABLE [dbo].[ChannelOption] (
  [ID] int  IDENTITY(1,1) NOT NULL,
  [Code] int  NOT NULL,
  [CH_Group] tinyint  NOT NULL,
  [CH_Type] tinyint  NOT NULL,
  [MinLevel] tinyint  NOT NULL,
  [MaxLevel] tinyint  NOT NULL,
  [CH_NUM] int  NOT NULL,
  [WorldID] int  NOT NULL
)
GO

ALTER TABLE [dbo].[ChannelOption] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ChannelOption
-- ----------------------------
SET IDENTITY_INSERT [dbo].[ChannelOption] ON
GO

SET IDENTITY_INSERT [dbo].[ChannelOption] OFF
GO


-- ----------------------------
-- Table structure for ChannelSeed
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ChannelSeed]') AND type IN ('U'))
	DROP TABLE [dbo].[ChannelSeed]
GO

CREATE TABLE [dbo].[ChannelSeed] (
  [ID] int  IDENTITY(1,1) NOT NULL,
  [CH_Group] tinyint DEFAULT 1 NOT NULL,
  [CH_Type] tinyint DEFAULT 1 NOT NULL,
  [MinLevel] tinyint DEFAULT 1 NOT NULL,
  [MaxLevel] tinyint DEFAULT 1 NOT NULL,
  [Current_Num] int DEFAULT 1 NOT NULL,
  [WorldID] int DEFAULT 1 NOT NULL,
  [Last_Seed] tinyint DEFAULT 0 NOT NULL
)
GO

ALTER TABLE [dbo].[ChannelSeed] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ChannelSeed
-- ----------------------------
SET IDENTITY_INSERT [dbo].[ChannelSeed] ON
GO

INSERT INTO [dbo].[ChannelSeed] ([ID], [CH_Group], [CH_Type], [MinLevel], [MaxLevel], [Current_Num], [WorldID], [Last_Seed]) VALUES (N'12', N'1', N'1', N'1', N'100', N'1', N'10101', N'0')
GO

SET IDENTITY_INSERT [dbo].[ChannelSeed] OFF
GO


-- ----------------------------
-- Table structure for GlobalVariableTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GlobalVariableTable]') AND type IN ('U'))
	DROP TABLE [dbo].[GlobalVariableTable]
GO

CREATE TABLE [dbo].[GlobalVariableTable] (
  [VarName] varchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [Value] bigint  NOT NULL
)
GO

ALTER TABLE [dbo].[GlobalVariableTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of GlobalVariableTable
-- ----------------------------
INSERT INTO [dbo].[GlobalVariableTable] ([VarName], [Value]) VALUES (N'LastAuthID', N'11520')
GO

INSERT INTO [dbo].[GlobalVariableTable] ([VarName], [Value]) VALUES (N'LastGMID', N'1')
GO


-- ----------------------------
-- Table structure for GMInfoTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GMInfoTable]') AND type IN ('U'))
	DROP TABLE [dbo].[GMInfoTable]
GO

CREATE TABLE [dbo].[GMInfoTable] (
  [gm_id] int  NOT NULL,
  [name] nvarchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [pass] nvarchar(16) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [permission] int  NOT NULL,
  [logout_time] datetime  NOT NULL
)
GO

ALTER TABLE [dbo].[GMInfoTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of GMInfoTable
-- ----------------------------

-- ----------------------------
-- Table structure for InquiryTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[InquiryTable]') AND type IN ('U'))
	DROP TABLE [dbo].[InquiryTable]
GO

CREATE TABLE [dbo].[InquiryTable] (
  [inquiry_id] bigint  IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
  [auth_id] uniqueidentifier  NOT NULL,
  [character_id] uniqueidentifier  NOT NULL,
  [type] tinyint DEFAULT 0 NOT NULL,
  [character_name] nvarchar(16) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [bcust_id] nvarchar(50) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [count] tinyint DEFAULT 0 NOT NULL,
  [memo] nvarchar(255) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [compulsion] tinyint DEFAULT 0 NOT NULL,
  [date] datetime  NOT NULL
)
GO

ALTER TABLE [dbo].[InquiryTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of InquiryTable
-- ----------------------------
SET IDENTITY_INSERT [dbo].[InquiryTable] ON
GO

SET IDENTITY_INSERT [dbo].[InquiryTable] OFF
GO


-- ----------------------------
-- Table structure for PCRoom
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[PCRoom]') AND type IN ('U'))
	DROP TABLE [dbo].[PCRoom]
GO

CREATE TABLE [dbo].[PCRoom] (
  [szIP] varchar(15) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [szName] nvarchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [Premium] int  NOT NULL,
  [expireDate] datetime  NOT NULL,
  [Use] tinyint DEFAULT 0 NOT NULL
)
GO

ALTER TABLE [dbo].[PCRoom] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of PCRoom
-- ----------------------------

-- ----------------------------
-- Table structure for RealTimeEventTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[RealTimeEventTable]') AND type IN ('U'))
	DROP TABLE [dbo].[RealTimeEventTable]
GO

CREATE TABLE [dbo].[RealTimeEventTable] (
  [id] int DEFAULT 0 NOT NULL,
  [value] int DEFAULT 0 NOT NULL,
  [information] varchar(128) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL
)
GO

ALTER TABLE [dbo].[RealTimeEventTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of RealTimeEventTable
-- ----------------------------
INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'1', N'1', N'Fatigue Recovery')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'2', N'2', N'Resurrection Scroll Charge (5 pieces)')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'3', N'2', N'Fortune')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'4', N'2', N'Daily Mail Attachment')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'5', N'8', N'Monster Hunting Experience Increase')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'6', N'8', N'Monster Hunting Experience Increase')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'7', N'9', N'Real-time Monster Hunting Experience Increase 1.5x')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'8', N'9', N'Real-time Monster Hunting Experience Increase 2x')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'9', N'9', N'Real-time Monster Hunting Experience Increase 2.5x')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'10', N'9', N'Real-time Monster Hunting Experience Increase 3x')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'11', N'9', N'Real-time Monster Hunting Experience Increase 5x')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'12', N'9', N'Monster Item Drop 2x')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'13', N'9', N'NewYear_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'14', N'9', N'ValentineDay_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'15', N'9', N'WhiteDay_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'16', N'9', N'Event_poison04')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'17', N'9', N'Family_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'18', N'9', N'Event_poison06')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'19', N'9', N'Summer_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'20', N'9', N'Event_poison08')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'21', N'9', N'Halloween_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'22', N'9', N'Thanks_Event_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'23', N'9', N'Event_poison11')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'24', N'9', N'X-mas_poison')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'25', N'2', N'PVP Ladder Reset')
GO

INSERT INTO [dbo].[RealTimeEventTable] ([id], [value], [information]) VALUES (N'26', N'2', N'Daily Party Challenge Quest Reset')
GO


-- ----------------------------
-- Table structure for ServerFile
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerFile]') AND type IN ('U'))
	DROP TABLE [dbo].[ServerFile]
GO

CREATE TABLE [dbo].[ServerFile] (
  [type] tinyint DEFAULT 0 NOT NULL,
  [filename] nchar(64) COLLATE Chinese_PRC_CI_AS  NOT NULL
)
GO

ALTER TABLE [dbo].[ServerFile] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ServerFile
-- ----------------------------
INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'1', N'GameServer_Release_USA_x64.exe                                  ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'2', N'DungeonServer_Release_USA_x64.exe                               ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'3', N'PVPServer_Release_USA_x64.exe                                   ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'5', N'GuildServer_Release_USA_x64.exe                                 ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'6', N'MessageServer_Release_x64.exe                                   ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'7', N'GMServer_Release_x64.exe                                        ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'8', N'GameGatewayServer_Release_x64.exe                               ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'9', N'ManagerServer_Release_USA_x64.exe                               ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'10', N'AuctionServer_Release_USA_x64.exe                               ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'11', N'MatchServer_Release_USA_x64.exe                                 ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'12', N'DBCServer_Release_x64.exe                                       ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'13', N'Agent_Release_x64.exe                                           ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'17', N'DBCServer_LOG_Release_x64.exe                                   ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'21', N'AgentManager_Release_x64.exe                                    ')
GO

INSERT INTO [dbo].[ServerFile] ([type], [filename]) VALUES (N'24', N'PatchServer_Release_x64.exe                                     ')
GO


-- ----------------------------
-- Table structure for ServerOption
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerOption]') AND type IN ('U'))
	DROP TABLE [dbo].[ServerOption]
GO

CREATE TABLE [dbo].[ServerOption] (
  [World] int DEFAULT 0 NOT NULL,
  [AgentCode] int DEFAULT 0 NOT NULL,
  [Code] int DEFAULT 0 NOT NULL,
  [Type] int DEFAULT 0 NOT NULL,
  [PrivateAddress] nvarchar(256) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [PrivatePort] int DEFAULT 0 NOT NULL,
  [PublicAddress] nvarchar(256) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [PublicPort] int DEFAULT 0 NOT NULL,
  [UdpPort] int DEFAULT 0 NOT NULL,
  [UdpCount] int DEFAULT 0 NOT NULL,
  [SessionCount] int DEFAULT 1 NOT NULL,
  [TypeMemo] varchar(16) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [Useable] nchar(1) COLLATE Chinese_PRC_CI_AS  NOT NULL
)
GO

ALTER TABLE [dbo].[ServerOption] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ServerOption
-- ----------------------------
INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'1', N'12', N'127.0.0.1', N'51055', N'', N'0', N'0', N'0', N'1', N'DBC', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'2', N'17', N'127.0.0.1', N'51056', N'', N'0', N'0', N'0', N'1', N'DBC_LOG', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'61', N'6', N'127.0.0.1', N'51052', N'', N'0', N'0', N'0', N'1', N'MSG', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'71', N'7', N'127.0.0.1', N'51002', N'192.168.100.3', N'50002', N'0', N'0', N'1', N'GM', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'81', N'8', N'127.0.0.1', N'50008', N'192.168.100.3', N'50001', N'0', N'0', N'1', N'GATE', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'91', N'9', N'127.0.0.1', N'51051', N'', N'0', N'0', N'0', N'1', N'MANAGER', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'101', N'10', N'127.0.0.1', N'51053', N'', N'0', N'0', N'0', N'1', N'Auction', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'111', N'11', N'127.0.0.1', N'51054', N'', N'0', N'0', N'0', N'1', N'Match', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'800', N'13', N'127.0.0.1', N'51060', N'', N'0', N'0', N'0', N'1', N'Agent', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'900', N'21', N'127.0.0.1', N'51091', N'192.168.100.3', N'50091', N'0', N'0', N'1', N'AgentManager', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'2001', N'2', N'127.0.0.1', N'0', N'192.168.100.3', N'50016', N'0', N'0', N'1', N'DUNGEON', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'3003', N'3', N'127.0.0.1', N'51004', N'192.168.100.3', N'50004', N'52000', N'50', N'1', N'Pvp', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'5001', N'5', N'127.0.0.1', N'51003', N'192.168.100.3', N'50003', N'0', N'0', N'1', N'Guild', N'Y')
GO

INSERT INTO [dbo].[ServerOption] ([World], [AgentCode], [Code], [Type], [PrivateAddress], [PrivatePort], [PublicAddress], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Useable]) VALUES (N'10101', N'800', N'21001', N'1', N'127.0.0.1', N'51006', N'192.168.100.3', N'50006', N'0', N'0', N'1', N'Lobby', N'Y')
GO


-- ----------------------------
-- Table structure for ServerOptionDNS
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ServerOptionDNS]') AND type IN ('U'))
	DROP TABLE [dbo].[ServerOptionDNS]
GO

CREATE TABLE [dbo].[ServerOptionDNS] (
  [World] int DEFAULT 0 NOT NULL,
  [AgentCode] int DEFAULT 0 NOT NULL,
  [Code] int DEFAULT 0 NOT NULL,
  [Type] int DEFAULT 0 NOT NULL,
  [PrivateDNS] nvarchar(256) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [PrivatePort] int DEFAULT 0 NOT NULL,
  [PublicDNS] nvarchar(256) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [PublicPort] int DEFAULT 0 NOT NULL,
  [UdpPort] int DEFAULT 0 NOT NULL,
  [UdpCount] int DEFAULT 0 NOT NULL,
  [SessionCount] int DEFAULT 1 NOT NULL,
  [TypeMemo] varchar(16) COLLATE Chinese_PRC_CI_AS DEFAULT '' NOT NULL,
  [Use] nchar(1) COLLATE Chinese_PRC_CI_AS  NOT NULL
)
GO

ALTER TABLE [dbo].[ServerOptionDNS] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ServerOptionDNS
-- ----------------------------
INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'1', N'12', N'gamedbc.private', N'51055', N'', N'0', N'0', N'0', N'1', N'DBC', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'2', N'17', N'logdbc.private', N'51056', N'', N'0', N'0', N'0', N'1', N'DBC_LOG', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'61', N'6', N'msg.private', N'51052', N'', N'0', N'0', N'0', N'1', N'MSG', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'71', N'7', N'gm.private', N'51002', N'gm.public', N'50002', N'0', N'0', N'1', N'GM', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'81', N'8', N'gate.private', N'50008', N'gate.public', N'50001', N'0', N'0', N'1', N'GATE', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'91', N'9', N'manager.private', N'51051', N'', N'0', N'0', N'0', N'1', N'MANAGER', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'101', N'10', N'auction.private', N'51053', N'', N'0', N'0', N'0', N'1', N'Auction', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'111', N'11', N'match.private', N'51054', N'', N'0', N'0', N'0', N'1', N'Match', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'800', N'13', N'agent.private', N'51060', N'', N'0', N'0', N'0', N'1', N'Agent', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'900', N'21', N'agentmanager.private', N'51091', N'agentmanager.public', N'50091', N'0', N'0', N'1', N'AgentManager', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'2001', N'2', N'dungeon.private', N'0', N'dungeon.public', N'50016', N'0', N'0', N'1', N'DUNGEON', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'3003', N'3', N'pvp.private', N'0', N'pvp.public', N'50004', N'52000', N'50', N'1', N'Pvp', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'5001', N'5', N'guild.private', N'51003', N'guild.public', N'50003', N'0', N'0', N'1', N'Guild', N'Y')
GO

INSERT INTO [dbo].[ServerOptionDNS] ([World], [AgentCode], [Code], [Type], [PrivateDNS], [PrivatePort], [PublicDNS], [PublicPort], [UdpPort], [UdpCount], [SessionCount], [TypeMemo], [Use]) VALUES (N'10101', N'800', N'21001', N'1', N'lobby.private', N'51006', N'lobby.public', N'50006', N'0', N'0', N'1', N'Lobby', N'Y')
GO


-- ----------------------------
-- Table structure for WorldServer
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[WorldServer]') AND type IN ('U'))
	DROP TABLE [dbo].[WorldServer]
GO

CREATE TABLE [dbo].[WorldServer] (
  [World] int  NOT NULL,
  [Name] nvarchar(50) COLLATE Chinese_PRC_CI_AS  NOT NULL,
  [UseAble] nchar(1) COLLATE Chinese_PRC_CI_AS  NOT NULL
)
GO

ALTER TABLE [dbo].[WorldServer] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of WorldServer
-- ----------------------------
INSERT INTO [dbo].[WorldServer] ([World], [Name], [UseAble]) VALUES (N'10101', N'Dev', N'Y')
GO


-- ----------------------------
-- procedure structure for up_gm_login
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_gm_login]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_gm_login]
GO

CREATE PROCEDURE [dbo].[up_gm_login]
	@account nvarchar(16),
	@pass    nvarchar(16)
as 
set nocount on

	set transaction isolation level read uncommitted

	select gm_id, [name], permission from GMInfoTable where [name] = @account and [pass] = @pass

return @@error
GO


-- ----------------------------
-- procedure structure for up_init_auth
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_init_auth]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_init_auth]
GO

CREATE PROCEDURE [dbo].[up_init_auth]

as 
set nocount on

INSERT INTO [dbo].[GlobalVariableTable] ([VarName] ,[Value]) VALUES ('LastAuthID' ,1)
INSERT INTO [dbo].[GlobalVariableTable] ([VarName] ,[Value]) VALUES ('LastGMID' ,1)

INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 1	,'GameServer_Release_CHN_x64.exe'      )
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 2	,'DungeonServer_Release_CHN_x64.exe'   )
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 3	,'PVPServer_Release_CHN_x64.exe'       )                                   
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 5	,'GuildServer_Release_CHN_x64.exe'     )                                 
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 6	,'MessageServer_Release_x64.exe'       )                                   
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 7	,'GMServer_Release_x64.exe'            )                                        
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 8	,'GameGatewayServer_Release_x64.exe'   )                               
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 9	,'ManagerServer_Release_CHN_x64.exe'   )                               
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 10	,'AuctionServer_Release_CHN_x64.exe'   )                               
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 11	,'MatchServer_Release_CHN_x64.exe'     )                                 
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 12	,'DBCServer_Release_x64.exe'           )                                       
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 13	,'Agent_Release_x64.exe'               )                                           
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 17	,'DBCServer_Release_x64.exe'           )                                       
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 18	,'DBCServer_Release_x64.exe'           )                                       
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 19	,'DBCServer_Release_x64.exe'           )                                       
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 21	,'AgentManager_Release_x64.exe'        )                                    
INSERT INTO [dbo].[ServerFile] ([type] ,[filename]) VALUES ( 24	,'PatchServer_Release_x64.exe'         )
GO


-- ----------------------------
-- procedure structure for up_init_auth_link
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_init_auth_link]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_init_auth_link]
GO

CREATE PROCEDURE [dbo].[up_init_auth_link]
@db_src 	  nvarchar(32),
@db_account   nvarchar(32),
@db_pass 	  nvarchar(32)
as 
set nocount on

--링크드 서버 설정

--서버등록
EXEC sp_addlinkedserver  
       @server='RustyHeartsLinkAuth',  -- 링크드서버이름, 기본값없음
       @srvproduct = '', -- OLEDB 데이터원본제품이름, 기본값NULL

       @provider = 'SQLOLEDB', -- 공급자고유식별자

       @datasrc = @db_src, -- 데이터원본이름      
       @provstr='',   -- OLEDB 공급자연결문자열, 기본값NULL
       @catalog='RustyHearts_Auth'   -- 공급자연결카다로그, 데이터베이스이름

--서버등록확인
SELECT * FROM master.dbo.sysservers

--연결계정등록
EXEC sp_addlinkedsrvlogin 
       @rmtsrvname  = 'RustyHeartsLinkAuth',  -- 링크드서버이름, 기본값없음
       @useself     = 'false',  -- 로그인이름사용유무, 기본값true
       @locallogin  = NULL,  -- 로컬서버로그인여부, 기본값NULL
       @rmtuser     = @db_account,  -- 사용자이름
       @rmtpassword = @db_pass  -- 사용자암호
       
EXEC SP_SERVEROPTION [RustyHeartsLinkAuth], 'RPC OUT'    , 'TRUE'
GO


-- ----------------------------
-- procedure structure for up_init_log_link
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_init_log_link]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_init_log_link]
GO

CREATE PROCEDURE [dbo].[up_init_log_link]
@db_src 	  nvarchar(32),
@db_account   nvarchar(32),
@db_pass 	  nvarchar(32)
as 
set nocount on

--링크드 서버 설정

--서버등록
EXEC sp_addlinkedserver  
       @server='RustyHearts_LogDB',  -- 링크드서버이름, 기본값없음
       @srvproduct = '', -- OLEDB 데이터원본제품이름, 기본값NULL

       @provider = 'SQLOLEDB', -- 공급자고유식별자

       @datasrc = @db_src, -- 데이터원본이름      
       @provstr='',   -- OLEDB 공급자연결문자열, 기본값NULL
       @catalog='RustyHearts_Log'   -- 공급자연결카다로그, 데이터베이스이름

--서버등록확인
SELECT * FROM master.dbo.sysservers

--연결계정등록
EXEC sp_addlinkedsrvlogin 
       @rmtsrvname  = 'RustyHearts_LogDB',  -- 링크드서버이름, 기본값없음
       @useself     = 'false',  -- 로그인이름사용유무, 기본값true
       @locallogin  = NULL,  -- 로컬서버로그인여부, 기본값NULL
       @rmtuser     = @db_account,  -- 사용자이름
       @rmtpassword = @db_pass  -- 사용자암호
       
EXEC SP_SERVEROPTION [RustyHearts_LogDB], 'RPC OUT'    , 'TRUE'


return @@error
GO


-- ----------------------------
-- procedure structure for up_insert_agentaccount
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_agentaccount]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_agentaccount]
GO

CREATE PROCEDURE [dbo].[up_insert_agentaccount]
@Account		nvarchar(16),
@Password		nvarchar(16)

as
BEGIN
set nocount on
	BEGIN TRAN

	if NOT EXISTS (select Account from dbo.AgentAccount with (nolock) where [Account] = @Account)
	begin
		insert into dbo.AgentAccount ( [Account], [Password] ) values
			( @Account, @Password );
	end

	if(@@error <> 0 )
	BEGIN
		 ROLLBACK TRAN
		 return
	END
		
	COMMIT TRAN
END
GO


-- ----------------------------
-- procedure structure for up_insert_agentaccount_by_query
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_agentaccount_by_query]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_agentaccount_by_query]
GO

CREATE PROCEDURE [dbo].[up_insert_agentaccount_by_query]
@ID			nvarchar(16),
@PASSWORD	char(16),
@PERMISSION	int

as
set nocount on

if NOT EXISTS (select @ID from dbo.AgentAccount with (nolock) where [Account] = @ID)
begin
	declare	@PASSWORD_LENGTH	int
	declare	@PASSWORD_MD5		nvarchar(32)

	set		@PASSWORD_LENGTH	= len(@PASSWORD)
	set		@PASSWORD_MD5		= SUBSTRING(master.dbo.fn_varbintohexstr( HashBytes('MD5', SUBSTRING(@PASSWORD, 1, @PASSWORD_LENGTH))), 3, 32)

	insert into dbo.AgentAccount( [Account], [Password], [Permission] ) values( @ID, @PASSWORD_MD5, @PERMISSION )
end
GO


-- ----------------------------
-- procedure structure for up_insert_blacklist
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_blacklist]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_blacklist]
GO

CREATE PROCEDURE [dbo].[up_insert_blacklist]
@IP		nvarchar(15),
@State	int,
@Cause	nvarchar(50),
@GmID	nvarchar(15)


as
set nocount on
begin tran
	if NOT EXISTS (select IP from dbo.BlackListTable with (nolock) where [IP] = @IP)
	begin
		insert into dbo.BlackListTable ( [IP], [State], [Cause], [GmID] ) values
			( @IP, @State, @Cause, @GmID );
	end
if(@@error <> 0 )
	begin
	     rollback
	     return

	end
	
	commit
GO


-- ----------------------------
-- procedure structure for up_insert_channel_auto_count
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_channel_auto_count]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_channel_auto_count]
GO

CREATE PROCEDURE [dbo].[up_insert_channel_auto_count]
		@StartCode		int,
		@World			int,
		@count			int

as
set nocount on

declare	@n int
set		@n = 0


while @n < @count
begin   
   EXEC	[dbo].[up_insert_channelbyAuto]
		@StartCode,
		@World

    set @StartCode	= @StartCode + 1
    set @n			= @n+1
   
end
GO


-- ----------------------------
-- procedure structure for up_insert_channelbyAuto
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_channelbyAuto]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_channelbyAuto]
GO

CREATE PROCEDURE [dbo].[up_insert_channelbyAuto]
		@Code		int,
		@World		int

as 
set nocount on

declare @i int      
declare @last int            
declare @current int
declare @minid int
declare @maxid int
set @i = 1                      
set @last = 0
set @current = 1
set @minid = 1
set @maxid = 1

select @last = ID from ChannelSeed where Last_Seed = 1 and WorldID = @World   
select @maxid = MAX(ID) from ChannelSeed where WorldID = @World     
select @minid = MIN(ID) from ChannelSeed where WorldID = @World 

if @last = 0
   begin
	 set @last = @minid
   end
else
   begin
	 set @last = @last+1
   end 

while @i <= 3               
begin   

   if @last > @maxid 
      begin
	     set @last = @minid
      end	
   
    insert into ChannelOption( Code, CH_Group, CH_Type, MinLevel, MaxLevel, CH_NUM, WorldID )
    select @Code, CH_Group, CH_Type, MinLevel, MaxLevel, Current_Num, @World from ChannelSeed where ID = @last
   
    select @current = Current_Num from ChannelSeed where ID = @last
    update ChannelSeed set Current_Num = @current+1 where ID = @last
    update ChannelSeed set Last_Seed = 0 where WorldID = @World
    update ChannelSeed set Last_Seed = 1 where ID = @last

    set @last = @last+1
    set @i = @i+1
   
end
GO


-- ----------------------------
-- procedure structure for up_insert_inquiry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_inquiry]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_inquiry]
GO

CREATE PROCEDURE [dbo].[up_insert_inquiry]
	@auth_id				uniqueidentifier,
	@character_id			uniqueidentifier,
	@type					tinyint,
	@character_name			nvarchar(16),
	@bcust_id				nvarchar(50),
	@count					tinyint,
	@memo					nvarchar(255),
	@compulsion				tinyint,
	@registertime			datetime

as
set nocount on

	 if NOT EXISTS (select @character_id from [dbo].[InquiryTable] with (READUNCOMMITTED) where [character_id] = @character_id)
		begin
			insert into InquiryTable
			values
			(
				@auth_id,
				@character_id,
				@type,
				@character_name,
				@bcust_id,
				@count,
				@memo,
				@compulsion,
				@registertime
			);
		end
return @@error
GO


-- ----------------------------
-- procedure structure for up_insert_inquiry_by_gm
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_inquiry_by_gm]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_inquiry_by_gm]
GO

CREATE PROCEDURE [dbo].[up_insert_inquiry_by_gm]
	@type					tinyint,
	@character_name			nvarchar(16),
	@memo					nvarchar(255),
	@compulsion				tinyint
as
set nocount on

declare	@auth_id				uniqueidentifier
declare	@character_id			uniqueidentifier
declare	@bcust_id				nvarchar(50)
declare @count					tinyint

set	@bcust_id = '' 

select @auth_id = [AuthID], @character_id = [character_id], @bcust_id = RTRIM(bcust_id) from [dbo].[CharacterTable] with (READUNCOMMITTED) where [Name] = @character_name
select @count = [InquiryCount] from [RustyHearts_Auth].[dbo].[AuthTable] with (READUNCOMMITTED) where [AuthID]	= @auth_id

set xact_abort on

if NOT EXISTS ( select @character_id from [dbo].[InquiryTable] with (READUNCOMMITTED) where [character_id] = @character_id )
begin
	insert into InquiryTable
	values
	(
		@auth_id,
		@character_id,
		@type,
		@character_name,
		@bcust_id,
		@count,
		@memo,
		@compulsion,
		GETDATE()
	);
end

select * from [dbo].[InquiryTable] with (READUNCOMMITTED) where character_id = @character_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_insert_log_auth_succeed
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_insert_log_auth_succeed]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_insert_log_auth_succeed]
GO

CREATE PROCEDURE [dbo].[up_insert_log_auth_succeed]
	@AuthID [uniqueidentifier],
	@server smallint,
	@real_ip varchar(16)
as begin	

set nocount on

	-------------------------------------------------------
	-- 접속 유저 로그 DB로 보내기
	declare @bcust_id nvarchar(50)
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
--		select @bcust_id=WindyCode from [RustyHeartsLinkAuth].[RustyHearts_Auth].[dbo].[AuthTable] where AuthID = @AuthID

		exec dbo.sp_executesql @sql, N'@bcust_id nvarchar(50) output', @bcust_id output
		select @bcust_id

		exec RustyHearts_LogDB.RustyHearts_Log.dbo.up_SetConnectionUV 4, @server, @AuthID, @bcust_id, 
				@character_id, @char_name, 0, @real_ip, 0, 0, 0, 0
	end
	-------------------------------------------------------

end
GO


-- ----------------------------
-- procedure structure for up_lock2
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_lock2]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_lock2]
GO

CREATE PROCEDURE [dbo].[up_lock2] 
@spid1 int = NULL,      /* server process id to check for locks */ 
@spid2 int = NULL       /* other process id to check for locks */ 
as

set nocount on
/*
** Show the locks for both parameters.
*/ 
declare @objid int,
   @dbid int,
   @string Nvarchar(255)

CREATE TABLE #locktable
   (
   spid       smallint
   ,loginname nvarchar(20)
   ,hostname  nvarchar(30)
   ,dbid      int
   ,dbname    nvarchar(20)
   ,objId     int
   ,ObjName   nvarchar(128)
   ,IndId     int
   ,Type      nvarchar(4)
   ,Resource  nvarchar(16)
   ,Mode      nvarchar(8)
   ,Status    nvarchar(5)
   )
   
if @spid1 is not NULL
begin
   INSERT #locktable
      (
      spid
      ,loginname
      ,hostname
      ,dbid
      ,dbname
      ,objId
      ,ObjName
      ,IndId
      ,Type
      ,Resource
      ,Mode
      ,Status
      )
   select convert (smallint, l.req_spid) 
      --,coalesce(substring (user_name(req_spid), 1, 20),'')
      ,coalesce(substring (s.loginame, 1, 20),'')
      ,coalesce(substring (s.hostname, 1, 30),'')
      ,l.rsc_dbid
      ,substring (db_name(l.rsc_dbid), 1, 20)
      ,l.rsc_objid
      ,''
      ,l.rsc_indid
      ,substring (v.name, 1, 4)
      ,substring (l.rsc_text, 1, 16)
      ,substring (u.name, 1, 8)
      ,substring (x.name, 1, 5)
   from master.dbo.syslockinfo l,
      master.dbo.spt_values v,
      master.dbo.spt_values x,
      master.dbo.spt_values u,
      master.dbo.sysprocesses s
   where l.rsc_type = v.number
   and   v.type = 'LR'
   and   l.req_status = x.number
   and   x.type = 'LS'
   and   l.req_mode + 1 = u.number
   and   u.type = 'L'
   and   req_spid in (@spid1, @spid2)
   and   req_spid = s.spid
end
/*
** No parameters, so show all the locks.
*/ 
else
begin
   INSERT #locktable
      (
      spid
      ,loginname
      ,hostname
      ,dbid
      ,dbname
      ,objId
      ,ObjName
      ,IndId
      ,Type
      ,Resource
      ,Mode
      ,Status
      )
   select convert (smallint, l.req_spid) 
      --,coalesce(substring (user_name(req_spid), 1, 20),'')
      ,coalesce(substring (s.loginame, 1, 20),'')
      ,coalesce(substring (s.hostname, 1, 30),'')
      ,l.rsc_dbid
      ,substring (db_name(l.rsc_dbid), 1, 20)
      ,l.rsc_objid
      ,''
      ,l.rsc_indid
      ,substring (v.name, 1, 4)
      ,substring (l.rsc_text, 1, 16)
      ,substring (u.name, 1, 8)
      ,substring (x.name, 1, 5)
   from master.dbo.syslockinfo l,
      master.dbo.spt_values v,
      master.dbo.spt_values x,
      master.dbo.spt_values u,
      master.dbo.sysprocesses s
   where l.rsc_type = v.number
   and   v.type = 'LR'
   and   l.req_status = x.number
   and   x.type = 'LS'
   and   l.req_mode + 1 = u.number
   and   u.type = 'L'
   and   req_spid = s.spid
   order by spID
END
DECLARE lock_cursor CURSOR
FOR SELECT dbid, ObjId FROM #locktable WHERE Type ='TAB'

OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @dbid, @ObjId 
WHILE @@FETCH_STATUS = 0
   BEGIN 
   SELECT @string = 
      'USE ' + db_name(@dbid) + char(13)  
      + 'UPDATE #locktable SET ObjName =  object_name(' 
      + convert(varchar(32),@objId) + ') WHERE dbid = ' + convert(varchar(32),@dbId) 
      + ' AND objid = ' + convert(varchar(32),@objId) 
   
   EXECUTE (@string) 
   FETCH NEXT FROM lock_cursor INTO @dbid, @ObjId    
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
 

SELECT * FROM #locktable
return (0) 
-- END up_lock2
GO


-- ----------------------------
-- procedure structure for up_read_agentmanager
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_agentmanager]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_agentmanager]
GO

CREATE PROCEDURE [dbo].[up_read_agentmanager]
@code int

as
set	nocount	on

begin
	select	*	FROM [dbo].[ServerOption] with (nolock) where code = @code
end
GO


-- ----------------------------
-- procedure structure for up_read_all_serveroption
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_all_serveroption]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_all_serveroption]
GO

CREATE PROCEDURE [dbo].[up_read_all_serveroption]

as
set	nocount	on

select * FROM [dbo].[ServerOption] with (READUNCOMMITTED) WHERE Useable = 'Y'

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_all_serveroption_dns
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_all_serveroption_dns]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_all_serveroption_dns]
GO

CREATE PROCEDURE [dbo].[up_read_all_serveroption_dns]

as
set	nocount	on

select	*	FROM [dbo].[ServerOptionDNS] with (nolock) where [Use] = 'Y'

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_auth_agent
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_auth_agent]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_auth_agent]
GO

CREATE PROCEDURE [dbo].[up_read_auth_agent]

as
set	nocount	on	

set transaction isolation level read uncommitted

select	
		[Account],
		[Password],
		[permission]
FROM [dbo].[AgentAccount]

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_auth_blacklist
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_auth_blacklist]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_auth_blacklist]
GO

CREATE PROCEDURE [dbo].[up_read_auth_blacklist] 

AS
SET NOCOUNT ON

set transaction isolation level read uncommitted

	SELECT
	IP,
	Type
	FROM dbo.BlackListTable where [Use] > 0
return @@error
GO


-- ----------------------------
-- procedure structure for up_read_auth_pcroom
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_auth_pcroom]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_auth_pcroom]
GO

CREATE PROCEDURE [dbo].[up_read_auth_pcroom] 

AS
SET NOCOUNT ON

set transaction isolation level read uncommitted

	SELECT
	szIP
	,szName
	,Premium
	,expireDate
	FROM dbo.PCRoom where [Use] > 0
return @@error
GO


-- ----------------------------
-- procedure structure for up_read_channelinfo
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_channelinfo]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_channelinfo]
GO

CREATE PROCEDURE [dbo].[up_read_channelinfo]
	@Code int,
	@World int

as 
set nocount on

set transaction isolation level read uncommitted

	select	
	CH_Group,
	CH_Type,
	MinLevel,
	MaxLevel,
	CH_NUM	
	from dbo.ChannelOption
	where Code = @Code AND WorldID = @World

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_inquiry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_inquiry]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_inquiry]
GO

CREATE PROCEDURE [dbo].[up_read_inquiry]

as
set nocount on
 set transaction isolation level read uncommitted

select * from dbo.InquiryTable

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_inquiry_character
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_inquiry_character]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_inquiry_character]
GO

CREATE PROCEDURE [dbo].[up_read_inquiry_character]
	@character_id	[uniqueidentifier]

as
set nocount on
 set transaction isolation level read uncommitted

select * from dbo.InquiryTable with (nolock) where [character_id] = @character_id;

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_pc_room_point
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_pc_room_point]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_pc_room_point]
GO

CREATE PROCEDURE [dbo].[up_read_pc_room_point]
	@AuthID uniqueidentifier
as
set nocount on

set transaction isolation level read uncommitted

select [pc_room_point] from AuthTable where AuthID = @AuthID

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_realtimeevent
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_realtimeevent]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_realtimeevent]
GO

CREATE PROCEDURE [dbo].[up_read_realtimeevent]

as
set	nocount	on

set transaction isolation level read uncommitted

select	*	FROM [dbo].[RealTimeEventTable]

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_serverfile
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_serverfile]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_serverfile]
GO

CREATE PROCEDURE [dbo].[up_read_serverfile]

as
set	nocount	on	

set transaction isolation level read uncommitted

select	*	FROM [dbo].[ServerFile]

return @@error
GO


-- ----------------------------
-- procedure structure for up_read_world_server
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_read_world_server]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_read_world_server]
GO

CREATE PROCEDURE [dbo].[up_read_world_server]

as
set	nocount	on	select	*	FROM [dbo].[WorldServer] with (nolock) where UseAble = 'Y'

return @@error
GO


-- ----------------------------
-- procedure structure for up_save_first_character
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_first_character]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_first_character]
GO

CREATE PROCEDURE [dbo].[up_save_first_character]
	@auth_id uniqueidentifier
as 
set nocount on

	update AuthTable set [CTime] = GETDATE() from AuthTable where AuthID = @auth_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_save_ip
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_ip]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_ip]
GO

CREATE PROCEDURE [dbo].[up_save_ip]
	@auth_id uniqueidentifier,
	@real_ip varchar(16),
	@server_ip varchar(16),
	@host_id int,
	@DBCIndex smallint
as 
set nocount on

	update AuthTable set [online]='1',[IP] = @real_ip, [ServerIP] = @server_ip, [ServerType]='G', [HostID]=@host_id, [DBCIndex]=@DBCIndex from AuthTable where AuthID = @auth_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_save_logout
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_logout]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_logout]
GO

CREATE PROCEDURE [dbo].[up_save_logout]
	@auth_id uniqueidentifier

as begin
set nocount on

	declare @last_time datetime
	select @last_time = BTime from AuthTable where AuthID = @auth_id

	update AuthTable set world_id=0, [online] = '0', [BTime] = GETDATE(), [LTime] = @last_time from AuthTable where AuthID = @auth_id

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
	@server smallint,
	@channelID int,
	@name nvarchar(16),
	@real_ip varchar(16),
	@inven_gold		 int,	
	@storage_gold	 int,	
	@character_level int,	
	@character_exp	 bigint,
	@log_type 	    smallint,
	@bcust_id nvarchar(50)

as begin
set nocount on

	begin
	exec [RustyHearts_LogDB].[RustyHearts_Log].[dbo].up_LogOut			@log_type, 
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
-- procedure structure for up_save_pc_room_point
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_pc_room_point]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_pc_room_point]
GO

CREATE PROCEDURE [dbo].[up_save_pc_room_point]
	@AuthID uniqueidentifier,
	@PCRoomPoint int
as
set nocount on

update AuthTable Set [pc_room_point] = @PCRoomPoint where AuthID = @AuthID

return @@error
GO


-- ----------------------------
-- procedure structure for up_save_server_info
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_save_server_info]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_save_server_info]
GO

CREATE PROCEDURE [dbo].[up_save_server_info]
	@auth_id uniqueidentifier,
	@real_ip varchar(16),
	@server_ip varchar(16),
	@host_id int,
	@ServerType char(2),
	@ServerID int
as 
set nocount on

	update AuthTable set [online]='1',[world_id]=@ServerID, [IP] = @real_ip, [ServerIP] = @server_ip, [ServerType]=@ServerType, [HostID]=@host_id from AuthTable where AuthID = @auth_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_server_down_log_out
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_server_down_log_out]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_server_down_log_out]
GO

CREATE PROCEDURE [dbo].[up_server_down_log_out]
	@host_id int,
	@ServerID int
as 
set nocount on

	update AuthTable set [online]='0',[ServerType]='0', [HostID]=0 from AuthTable where [HostID] = @host_id and [world_id] = @ServerID

return @@error
GO


-- ----------------------------
-- procedure structure for up_set_second_pass
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_set_second_pass]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_set_second_pass]
GO

CREATE PROCEDURE [dbo].[up_set_second_pass]
@auth_id uniqueidentifier,
@second_pass varchar(32)
as
set nocount on
GO


-- ----------------------------
-- procedure structure for up_update_agentaccount_md5
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_agentaccount_md5]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_agentaccount_md5]
GO

CREATE PROCEDURE [dbo].[up_update_agentaccount_md5]

as
set nocount on
begin

UPDATE AgentAccount
	SET Password = SUBSTRING(master.dbo.fn_varbintohexstr( HashBytes('MD5', Password)), 3, 32)

end
GO


-- ----------------------------
-- procedure structure for up_update_cash_mileage
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_cash_mileage]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_cash_mileage]
GO

CREATE PROCEDURE [dbo].[up_update_cash_mileage]
	@auth_id				uniqueidentifier,
	@mileage				int
as
set nocount on

	UPDATE [dbo].[AuthTable] SET [CashMileage] = @mileage WHERE [AuthID] = @auth_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_update_event_inquiry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_event_inquiry]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_event_inquiry]
GO

CREATE PROCEDURE [dbo].[up_update_event_inquiry]
@auth_id [uniqueidentifier],
@inquiry tinyint
	as
begin

	set nocount on
	
	update AuthTable set event_inquiry = @inquiry where AuthID = @auth_id

end
GO


-- ----------------------------
-- procedure structure for up_update_inquiry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_inquiry]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_inquiry]
GO

CREATE PROCEDURE [dbo].[up_update_inquiry]
	@character_id			uniqueidentifier,
	@type					tinyint,
	@memo					nvarchar(255) 
as
set nocount on

UPDATE [dbo].[InquiryTable]	SET
	[type]			= @type,
	[memo]			= @memo						WHERE	[character_id] = @character_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_update_inquiry_count
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_inquiry_count]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_inquiry_count]
GO

CREATE PROCEDURE [dbo].[up_update_inquiry_count]
	@auth_id				uniqueidentifier,
	@count					tinyint
as
set nocount on


--UPDATE [RustyHeartsLinkAuth].[RustyHearts_Auth].[dbo].[AuthTable] SET [InquiryCount] = @count WHERE [AuthID] = @auth_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_update_inquiry_type
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_update_inquiry_type]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_update_inquiry_type]
GO

CREATE PROCEDURE [dbo].[up_update_inquiry_type]
	@character_id			uniqueidentifier,
	@type					tinyint
as
set nocount on

begin tran

UPDATE [dbo].[InquiryTable]	SET	[type]			= @type	WHERE [character_id] = @character_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_add_inquiry_count
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_add_inquiry_count]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_add_inquiry_count]
GO

CREATE PROCEDURE [dbo].[up_add_inquiry_count]
	@auth_id				uniqueidentifier

as 
set nocount on

	declare	@inquiry_count tinyint;
	select @inquiry_count = [InquiryCount] from [AuthTable] with (READUNCOMMITTED) where [AuthID] = @auth_id;
	UPDATE [AuthTable] SET [InquiryCount] = @inquiry_count + 1 WHERE [AuthID] = @auth_id;

return @@error
GO


-- ----------------------------
-- procedure structure for up_ado_data_mapping
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_ado_data_mapping]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_ado_data_mapping]
GO

CREATE PROCEDURE [dbo].[up_ado_data_mapping]
	@bcust_id		nvarchar(50),
	@UUID			uniqueidentifier,
	@OnLine			tinyint,
	@ServerID		smallint,
	@ChannelID		int,
	@CharExp		bigint,
	@CharName		nvarchar(16),
	@IP				nchar(16),
	@fValue			float,
	@btValue		tinyint,
	@bGift			bit,
	@dDouble		datetime,
	@CharClass		int

as
BEGIN
	set nocount on

--	create table TTMapping (
--	@bcust_id		nvarchar(50),
--	UUID			uniqueidentifier,
--	OnLine			tinyint,
--	ServerID		smallint,
--	ChannelID		int,
--	CharExp			bigint,
--	CharName		nvarchar(16),
--	IP				nchar(16),
--	fValue			float,
--	btValue			tinyint,
--	bGift			bit,
--	dDouble			datetime,
--	CharClass		int
--	)

	INSERT INTO dbo.TTMapping (

	windy_code,
	UUID	,
	OnLine	,
	ServerID,	
	ChannelID,	
	CharExp	,	
	CharName,	
	IP		,	
	fValue	,	
	btValue	,	
	bGift	,	
	dDouble	,	
	CharClass 

	)	
--
	VALUES ( 
	@bcust_id	,
	@UUID		,
	@OnLine		,
	@ServerID	,
	@ChannelID	,
	@CharExp	,
	@CharName	,
	@IP			,
	@fValue		,
	@btValue	,
	@bGift		,
	@dDouble	,
	@CharClass	
--
	)

	select * from dbo.TTMapping

	
END
GO


-- ----------------------------
-- procedure structure for up_auth_agentaccount
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_auth_agentaccount]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_auth_agentaccount]
GO

CREATE PROCEDURE [dbo].[up_auth_agentaccount]
	@Account		nvarchar(16),
	@Password		nvarchar(32)
as
BEGIN
	set nocount on
	set transaction isolation level read uncommitted
	
	select permission from dbo.AgentAccount where [Account] = @Account and [Password] = @Password

	return @@error
END
GO


-- ----------------------------
-- procedure structure for up_change_world
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_change_world]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_change_world]
GO

CREATE PROCEDURE [dbo].[up_change_world]
	@old_world_id				int,
	@new_world_id				int

as
set nocount on
		begin
			UPDATE [dbo].[AuthTable]	SET       [world_id] = @new_world_id where [world_id] = @old_world_id
		end
return @@error
GO


-- ----------------------------
-- procedure structure for up_delete_inquiry
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_delete_inquiry]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_delete_inquiry]
GO

CREATE PROCEDURE [dbo].[up_delete_inquiry]
	@character_id			uniqueidentifier
as
set nocount on

delete from [dbo].[InquiryTable]	where [character_id] = @character_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_get_auth_id
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_get_auth_id]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_get_auth_id]
GO

CREATE PROCEDURE [dbo].[up_get_auth_id]
	@bcust_id nvarchar(50),
	@UUID uniqueidentifier,
	@channelling int,
	@mac_addr char(17),
	@mac_addr02 char(17),
	@mac_addr03 char(17)
as
set nocount on

	declare @login_count bigint
	set @login_count  = -1

	if exists (select AuthID from AuthTable with (nolock) where WindyCode = @bcust_id)	
	begin

		select @login_count = [LCount] from AuthTable with (nolock) where WindyCode = @bcust_id
		select AuthID, online, DBCIndex, InquiryCount, CashMileage, [pc_room_point] from AuthTable with (nolock) where WindyCode = @bcust_id
		--Online Login Count
		update AuthTable set [online] = '1', [LCount] = @login_count+1, ServerType = 'G', ServerIP=0, HostID=0, mac_addr=@mac_addr, mac_addr02=@mac_addr02, mac_addr03=@mac_addr03 from AuthTable where WindyCode = @bcust_id
		return;
	end	


	declare @LastAuthID bigint;
	select @LastAuthID = [Value] from GlobalVariableTable with (nolock) where VarName = 'LastAuthID'
	update GlobalVariableTable set [Value] = @LastAuthID+1 where VarName = 'LastAuthID'

	insert into AuthTable
	values( @bcust_id, 0, @UUID, @LastAuthID, '1', GetDate(), GetDate(), GetDate(), 0, 1, 0, 'G', 0, -1, 5, 0, 0, @channelling, 0, 0, @mac_addr, @mac_addr02, @mac_addr03, '' )

	select AuthID, online, DBCIndex, InquiryCount, CashMileage, [pc_room_point] from AuthTable with (nolock) where WindyCode = @bcust_id



return @@error
GO


-- ----------------------------
-- procedure structure for up_get_pcroominfo
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_get_pcroominfo]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_get_pcroominfo]
GO

CREATE PROCEDURE [dbo].[up_get_pcroominfo]
(
	@szIP		nvarchar(24)
)
as
begin
set nocount on

	--declare @sql nvarchar(1000)
	--set @sql= 'select * from openquery(PcRoom, '
	--	  + '''select Level from tbCustomerIP 
	--		where IP = '''''
	--	  + @szIP + ''''' '')'
	--exec(@sql)
	--select InquiryCount as [Level] from AuthTable where IP = @szIP
	select 0 as [Level]
	
end
GO


-- ----------------------------
-- procedure structure for up_get_second_pass
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_get_second_pass]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_get_second_pass]
GO

CREATE PROCEDURE [dbo].[up_get_second_pass]
	@bcust_id nvarchar(50)
as
set nocount on

	if exists (select AuthID from AuthTable with (nolock) where WindyCode = @bcust_id)	
	begin
		select second_pass from AuthTable with (nolock) where WindyCode = @bcust_id
		return;
	end	

	select '';

return @@error
GO


-- ----------------------------
-- procedure structure for up_gm_add
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_gm_add]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_gm_add]
GO

CREATE PROCEDURE [dbo].[up_gm_add]
	@account nvarchar(16),
	@pass    nvarchar(16)
as 
set nocount on

	declare @LastGMID bigint;
	select @LastGMID = [Value] from GlobalVariableTable with (nolock) where VarName = 'LastGMID'
	update GlobalVariableTable set [Value] = @LastGMID+1 where VarName = 'LastGMID'

	insert into GMInfoTable values ( @LastGMID, @account , @pass, 100, GETDATE() )

return @@error
GO


-- ----------------------------
-- procedure structure for up_gm_change_pass
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_gm_change_pass]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_gm_change_pass]
GO

CREATE PROCEDURE [dbo].[up_gm_change_pass]
	@gm_id   int,
	@pass    nvarchar(16)
as 
set nocount on

	UPDATE [dbo].[GMInfoTable] SET [pass] = @pass WHERE [gm_id] = @gm_id

return @@error
GO


-- ----------------------------
-- procedure structure for up_gm_del
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[up_gm_del]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[up_gm_del]
GO

CREATE PROCEDURE [dbo].[up_gm_del]
	@account nvarchar(16)
as 
set nocount on

	DELETE FROM [dbo].[GMInfoTable] WHERE name = @account

return @@error
GO


-- ----------------------------
-- Primary Key structure for table AgentAccount
-- ----------------------------
ALTER TABLE [dbo].[AgentAccount] ADD CONSTRAINT [PK_AgentAccount] PRIMARY KEY CLUSTERED ([Account])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table AuthTable
-- ----------------------------
ALTER TABLE [dbo].[AuthTable] ADD CONSTRAINT [PK__AuthTable__7E6CC920] PRIMARY KEY CLUSTERED ([WindyCode])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table BlackListTable
-- ----------------------------
ALTER TABLE [dbo].[BlackListTable] ADD CONSTRAINT [PK_BlackListTable] PRIMARY KEY CLUSTERED ([IP])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for ChannelOption
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[ChannelOption]', RESEED, 103)
GO


-- ----------------------------
-- Auto increment value for ChannelSeed
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[ChannelSeed]', RESEED, 12)
GO


-- ----------------------------
-- Primary Key structure for table ChannelSeed
-- ----------------------------
ALTER TABLE [dbo].[ChannelSeed] ADD CONSTRAINT [PK__ChannelS__3214EC274EB8B219] PRIMARY KEY CLUSTERED ([ID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table GlobalVariableTable
-- ----------------------------
ALTER TABLE [dbo].[GlobalVariableTable] ADD CONSTRAINT [PK__GlobalVa__0974A529CE853417] PRIMARY KEY CLUSTERED ([VarName])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Uniques structure for table GMInfoTable
-- ----------------------------
ALTER TABLE [dbo].[GMInfoTable] ADD CONSTRAINT [UQ__GMInfoTa__72E12F1B00AF7602] UNIQUE NONCLUSTERED ([name] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

ALTER TABLE [dbo].[GMInfoTable] ADD CONSTRAINT [UQ__GMInfoTa__72E12F1B097FF3BC] UNIQUE NONCLUSTERED ([name] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table GMInfoTable
-- ----------------------------
ALTER TABLE [dbo].[GMInfoTable] ADD CONSTRAINT [PK__GMInfoTa__49B921C169C4AF97] PRIMARY KEY CLUSTERED ([gm_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for InquiryTable
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[InquiryTable]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table InquiryTable
-- ----------------------------
ALTER TABLE [dbo].[InquiryTable] ADD CONSTRAINT [PK_InquiryTable] PRIMARY KEY CLUSTERED ([inquiry_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table ServerFile
-- ----------------------------
ALTER TABLE [dbo].[ServerFile] ADD CONSTRAINT [PK__ServerFi__E3F85249E772E171] PRIMARY KEY CLUSTERED ([type])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table ServerOption
-- ----------------------------
ALTER TABLE [dbo].[ServerOption] ADD CONSTRAINT [PK__ServerOp__A25C5AA6F3718EFF] PRIMARY KEY CLUSTERED ([Code])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table ServerOptionDNS
-- ----------------------------
ALTER TABLE [dbo].[ServerOptionDNS] ADD CONSTRAINT [PK_ServerOption] PRIMARY KEY CLUSTERED ([Code])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

