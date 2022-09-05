USE [PlativeDB]
GO

/****** Object:  View [dbo].[SF_FundRole]    Script Date: 3/12/2022 6:08:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[SF_FundRole] AS
SELECT
    FR.[FundRoleSystemID] as ExternalId__c,
	FR.[FundSystemID] as Fund__c,
	FR.[ConstituentSystemID] as Contact__c,
	FR.[Role] as Role__c,
	FR.[RelationshipsToFund] as RelationshipsToFund__c,
	FR.[IsFormer] as Active__c,
	FR.[FromDateFuzzy] as Start_Date__c,
	FR.[ToDateFuzzy] as End_Date__c,
	FR.[IsCombined] as IsCombined__c,
	FR.[StatementDeliveryMethod] as StatementDeliveryMethod__c,
	FR.[AcknowledgeInGrantAwardLetter] as Grant_Acknowledgement__c,
	FR.[AcknowledgementNameInGrantAwardLetter] as Grant_Recognition_Name__c,
	FR.[Notes] as Description__c
FROM [SVCF].[api].[FundRole] FR	 
GO


