/*
 Navicat Premium Data Transfer

 Source Server         : RH VM
 Source Server Type    : SQL Server
 Source Server Version : 16001105
 Source Host           : 192.168.100.202:1433
 Source Catalog        : GMRustyHearts
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001105
 File Encoding         : 65001

 Date: 12/12/2023 01:43:52
*/

-- ----------------------------
-- Table structure for Admin_Sys_Param
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Admin_Sys_Param]') AND type IN ('U'))
  DROP TABLE [dbo].[Admin_Sys_Param]
GO

CREATE TABLE [dbo].[Admin_Sys_Param] (
  [seq] int  IDENTITY(1,1) NOT NULL,
  [param_name] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [param_value] nvarchar(255) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [remark1] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [remark2] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [read_yn] int  NULL,
  [regdate] datetime  NOT NULL
)
GO

ALTER TABLE [dbo].[Admin_Sys_Param] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Admin_Sys_Param
-- ----------------------------
SET IDENTITY_INSERT [dbo].[Admin_Sys_Param] ON
GO

SET IDENTITY_INSERT [dbo].[Admin_Sys_Param] OFF
GO


-- ----------------------------
-- Table structure for AdminRoles
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[AdminRoles]') AND type IN ('U'))
	DROP TABLE [dbo].[AdminRoles]
GO

CREATE TABLE [dbo].[AdminRoles] (
  [Idx] int  IDENTITY(1,1) NOT NULL,
  [AdminID] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [AdminPW] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [AdminRoles] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [RegDate] datetime DEFAULT getdate() NOT NULL,
  [RegName] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NULL,
  [AdminYN] nchar(2) COLLATE Korean_Wansung_CI_AS DEFAULT N'N' NULL,
  [accessControlYN] nvarchar(2) COLLATE Korean_Wansung_CI_AS DEFAULT 'N' NULL,
  [ip_1] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL,
  [ip_2] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL,
  [ip_3] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL
)
GO

ALTER TABLE [dbo].[AdminRoles] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of AdminRoles
-- ----------------------------
SET IDENTITY_INSERT [dbo].[AdminRoles] ON
GO

INSERT INTO [dbo].[AdminRoles] ([Idx], [AdminID], [AdminPW], [AdminRoles], [RegDate], [RegName], [AdminYN], [accessControlYN], [ip_1], [ip_2], [ip_3]) VALUES (N'16', N'admin', N'admin', N'1', N'2022-06-24 07:27:34.730', N'admin', N' Y', N'N', N'', N'', N'')
GO

SET IDENTITY_INSERT [dbo].[AdminRoles] OFF
GO


-- ----------------------------
-- Table structure for GMAudit
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GMAudit]') AND type IN ('U'))
	DROP TABLE [dbo].[GMAudit]
GO

CREATE TABLE [dbo].[GMAudit] (
  [audit_id] uniqueidentifier DEFAULT newid() NOT NULL,
  [AdminID] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [world_index] int  NOT NULL,
  [bcust_id] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT N'None' NULL,
  [character_id] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NULL,
  [char_name] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NULL,
  [Type] nvarchar(100) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [Modify] nvarchar(1500) COLLATE Korean_Wansung_CI_AS  NULL,
  [Memo] nvarchar(200) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [date] datetime DEFAULT getdate() NOT NULL
)
GO

ALTER TABLE [dbo].[GMAudit] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of GMAudit
-- ----------------------------

-- ----------------------------
-- Table structure for GMInfoTable
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GMInfoTable]') AND type IN ('U'))
	DROP TABLE [dbo].[GMInfoTable]
GO

CREATE TABLE [dbo].[GMInfoTable] (
  [gm_id] int  NOT NULL,
  [name] nvarchar(16) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [pass] nvarchar(16) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [permission] int  NOT NULL,
  [logout_time] datetime  NOT NULL
)
GO

ALTER TABLE [dbo].[GMInfoTable] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of GMInfoTable
-- ----------------------------
INSERT INTO [dbo].[GMInfoTable] ([gm_id], [name], [pass], [permission], [logout_time]) VALUES (N'1', N'admin', N'admin', N'1', N'2022-03-02 22:20:41.000')
GO


-- ----------------------------
-- Table structure for GMLoginLog
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[GMLoginLog]') AND type IN ('U'))
	DROP TABLE [dbo].[GMLoginLog]
GO

CREATE TABLE [dbo].[GMLoginLog] (
  [Idx] bigint  IDENTITY(1,1) NOT NULL,
  [AdminID] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [RegName] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NULL,
  [accessIP] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NULL,
  [successYN] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NULL,
  [LogDate] datetime DEFAULT getdate() NOT NULL,
  [type] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT ' ' NOT NULL
)
GO

ALTER TABLE [dbo].[GMLoginLog] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of GMLoginLog
-- ----------------------------
SET IDENTITY_INSERT [dbo].[GMLoginLog] ON
GO

SET IDENTITY_INSERT [dbo].[GMLoginLog] OFF
GO


-- ----------------------------
-- Table structure for POPUP
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[POPUP]') AND type IN ('U'))
	DROP TABLE [dbo].[POPUP]
GO

CREATE TABLE [dbo].[POPUP] (
  [idx] int  IDENTITY(1,1) NOT NULL,
  [title] nvarchar(255) COLLATE Korean_Wansung_CI_AS  NULL,
  [width] int  NULL,
  [height] int  NULL,
  [v_width] int  NULL,
  [v_height] int  NULL,
  [memo] text COLLATE Korean_Wansung_CI_AS  NULL,
  [apply] nchar(2) COLLATE Korean_Wansung_CI_AS  NULL,
  [wdate] datetime  NULL
)
GO

ALTER TABLE [dbo].[POPUP] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of POPUP
-- ----------------------------
SET IDENTITY_INSERT [dbo].[POPUP] ON
GO

SET IDENTITY_INSERT [dbo].[POPUP] OFF
GO


-- ----------------------------
-- Table structure for WorldList
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[WorldList]') AND type IN ('U'))
	DROP TABLE [dbo].[WorldList]
GO

CREATE TABLE [dbo].[WorldList] (
  [world_id] tinyint  NOT NULL,
  [world_name] nvarchar(50) COLLATE Korean_Wansung_CI_AS  NOT NULL,
  [db_id] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL,
  [db_pw] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL,
  [db_catalog] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL,
  [db_ip] nvarchar(50) COLLATE Korean_Wansung_CI_AS DEFAULT '' NULL
)
GO

ALTER TABLE [dbo].[WorldList] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of WorldList
-- ----------------------------
INSERT INTO [dbo].[WorldList] ([world_id], [world_name], [db_id], [db_pw], [db_catalog], [db_ip]) VALUES (N'1', N'Ragezone', N'sa', N'RustyHearts', N'RustyHearts_Auth', N'127.0.0.1')
GO


-- ----------------------------
-- Table structure for X_6217
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[X_6217]') AND type IN ('U'))
	DROP TABLE [dbo].[X_6217]
GO

CREATE TABLE [dbo].[X_6217] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [ResultTxt] nvarchar(4000) COLLATE Korean_Wansung_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[X_6217] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of X_6217
-- ----------------------------
SET IDENTITY_INSERT [dbo].[X_6217] ON
GO

SET IDENTITY_INSERT [dbo].[X_6217] OFF
GO


-- ----------------------------
-- procedure structure for CreateCalendar
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateCalendar]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[CreateCalendar]
GO

CREATE PROCEDURE [dbo].[CreateCalendar] 
/************************************************************************************************************
 Purpose: 
 Given a start date and an end date, create a calendar of dates that easily traverses months and years.  Is
 capable of generating up to 179 years worth of calendar by month in any given run. 
 Usage Notes: 
 1.  End date parameter is optional... if not provided, the start date will be used to return that one month.
 2.  Of the two input paramters, the lowest (earliest) date will be used as the start date regardless of the
     order provided. 
 3.  Returns a single result set containing all dates. 
 4.  Does NOT use a Cursor, While Loop, Temp Table, or Table variable so that even really picky DBA's won't
     reject the code. 
 5.  Because only set-based code was used, returns 10 years worth of calendar in about 230 milliseconds. 
     A full year takes a scant 76 milliseconds and a single month takes 63 milliseconds. A hundred-year 
     calendar takes only 6.3 seconds. 
 6.  The start date does NOT need to be the first of the month and the end date does NOT need to be the last
     day of the month.  The internal calculations will "auto-magically" include the whole month for both the 
     start and end dates as well as all months in between. 
 Revision History: 
 Rev 00 - 08/13/2007 - Jeff Moden - Initial creation and unit test. 
************************************************************************************************************/
--===== Declare the input parameters 
        @pStartDate DATETIME,              --Any date (can include time) in the desired start month 
        @pEndDate   DATETIME = @pStartDate --Any date (can include time) in the desired end month 
     AS 
--===== Create the correct environment 
    SET NOCOUNT ON --Suppress the auto-display of rowcounts to prevent false echos on GUI's 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --Same as putting WITH (NOLOCK) on tables in query 
--===== Create the base date that all the calculations rely on (is a Monday) 
DECLARE @BaseDate DATETIME 
    SET @BaseDate = '1753-01-01' 
--===== Make sure the inputs are in the correct order (start date must always be the earliest date)
     IF @pEndDate < @pStartDate 
  BEGIN 
        DECLARE @Swap DATETIME 
         SELECT @Swap       = @pStartDate, 
                @pStartDate = @pEndDate, 
                @pEndDate   = @Swap 
    END     
--===== Modify the start to start on the first of the same month and the end date to end on the last day 
     -- of the same month. 
    SET @pStartDate = DATEADD(mm,DATEDIFF(mm,@BaseDate,@pStartDate),@BaseDate) 
    SET @pEndDate   = DATEADD(mm,DATEDIFF(mm,@BaseDate,@pEndDate)+1,@BaseDate)-1 

--===== Create the calendar without loops, cursors, or temp tables 
 SELECT MAX(DATENAME(yy,d.TheDate)) AS [Year], 
        MAX(LEFT(DATENAME(mm,d.TheDate),3))AS [Month], 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '월요일'    THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Mon, 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '화요일'   THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Tue, 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '수요일' THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Wed, 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '목요일'  THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Thu, 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '금요일'    THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Fri, 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '토요일'  THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Sat, 
        MAX(CASE WHEN DATENAME(dw,d.TheDate) = '일요일'    THEN DATENAME(dd,d.TheDate) ELSE '' END) AS Sun 
   FROM (--==== Derived table "d" finds all dates for the given range of dates up to 65535 days apart 
         SELECT YEAR(@pStartDate+n.Number)                    AS TheYear, 
                MONTH(@pStartDate+n.Number)                   AS TheMonth, 
                DATEDIFF(dd,@BaseDate,@pStartDate+n.Number)/7 AS TheWeek, 
                @pStartDate+n.Number                          AS TheDate 
           FROM (--==== Derived table "n" creates numbers from 0 to 65535 (about 179 years worth of days) 
                 SELECT t1.Number*256+t2.Number AS Number 
                   FROM Master.dbo.spt_Values t1, 
                        Master.dbo.spt_Values t2 
                  WHERE t1.Type = 'P' 
                    AND t2.Type = 'P' 
                )n 
          WHERE @pStartDate+n.Number <= @pEndDate 
        )d 
  GROUP BY d.TheYear,d.TheMonth,d.TheWeek 
  ORDER BY d.TheYear,d.TheMonth,d.TheWeek
GO


-- ----------------------------
-- Auto increment value for Admin_Sys_Param
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[Admin_Sys_Param]', RESEED, 1)
GO


-- ----------------------------
-- Primary Key structure for table Admin_Sys_Param
-- ----------------------------
ALTER TABLE [dbo].[Admin_Sys_Param] ADD CONSTRAINT [PK_Admin_Sys_Param] PRIMARY KEY CLUSTERED ([seq])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for AdminRoles
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[AdminRoles]', RESEED, 16)
GO


-- ----------------------------
-- Uniques structure for table GMInfoTable
-- ----------------------------
ALTER TABLE [dbo].[GMInfoTable] ADD CONSTRAINT [UQ__GMInfoTa__72E12F1B09DE7BCC] UNIQUE NONCLUSTERED ([name] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table GMInfoTable
-- ----------------------------
ALTER TABLE [dbo].[GMInfoTable] ADD CONSTRAINT [PK__GMInfoTa__49B921C107020F21] PRIMARY KEY CLUSTERED ([gm_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for GMLoginLog
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[GMLoginLog]', RESEED, 1)
GO


-- ----------------------------
-- Auto increment value for POPUP
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[POPUP]', RESEED, 6)
GO


-- ----------------------------
-- Primary Key structure for table WorldList
-- ----------------------------
ALTER TABLE [dbo].[WorldList] ADD CONSTRAINT [PK_WorldList] PRIMARY KEY CLUSTERED ([world_id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for X_6217
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[X_6217]', RESEED, 1)
GO

