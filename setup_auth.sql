USE [RustyHearts_Auth]
GO

UPDATE ServerOption
SET PublicAddress = "<SERVER_PUBLIC_IP>"
WHERE PublicAddress = "192.168.1.100";
GO
