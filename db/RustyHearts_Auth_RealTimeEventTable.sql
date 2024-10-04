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

