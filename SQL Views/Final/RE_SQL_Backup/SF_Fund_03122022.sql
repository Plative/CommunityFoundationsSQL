USE [PlativeDB]
GO

/****** Object:  View [dbo].[SF_Fund]    Script Date: 3/12/2022 6:08:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[SF_Fund] AS
SELECT 
	F.FundSystemID as FundSystemID__c,
	F.FundID as Fund_ID__c,
	F.Name as Name,
	F.[Category] as Fund_Category__c,
	F.Type as Fund_Type__c,
	F.[Family] as Fund_Family__c,
	F.Annotation as Annotation__c,
	F.DisplayAnnotation as DisplayAnnotation__c,
	F.IsActive as Active__c,
	F.StartDate as Fund_Opened_Date__c,
	F.EndDate as EndDate__c,
    C.Id as Philanthropy_Lead_Contact__c,
	Con.Id as Philanthropy_Support_Contact__c,
	F.FundAnonymousForGrants as FundAnonymousForGrants__c,
	F.AdvisorsAnonymousForGrants as AdvisorsAnonymousForGrants__c,
	F.[CustomGrantAgreement] as CustomGrantAgreement__c,
	F.[CustomGrantAwardLetter] as CustomGrantAwardLetter__c,
	F.CustomGrantAwardLetterLanguage as CustomGrantAwardLetterLanguage__c,
	F.NoteGrantProcessing as NoteGrantProcessing__c,
	F.[SuppressGiftAmountsForNonStaff] as SuppressGiftAmountsForNonStaff__c,
	F.[NoteGiftProcessing] as NoteGiftProcessing__c,
	F.[NoteGiftLetterProcessing] as NoteGiftLetterProcessing__c,
	F.[FundStatementType] as FundStatementType__c,
	F.[FundStatementHeldAfterDate] as FundStatementHeldAfterDate__c,
	F.IsSpecialHandling as IsSpecialHandling__c,
	F.[IsIndividuallyManagedFund] as IMF_Fund__c,
	F.[IsBlackLabel] as IsBlackLabel__c,
	F.[BlackLabelSuite] as BlackLabelSuite__c,
	F.[SupportTier] as SupportTier__c,
	F.[FundSalesPlan] as FundSalesPlan__c,
	F.[WillGiveTo] as Focus_Area__c,
	F.[WillNotGiveTo] as WillNotGiveTo__c,
    F.[PrimaryOrganizationConstituentSystemID] as Account__c
	--A.Account_Id__c as Account__c
   --con.ConstituentSystemID
FROM [SVCF].[api].[Fund] F
left join SF_Account A ON A.[constituentID__c] =  F.[PrimaryOrganizationConstituentSystemID] 
Left Join SF_Contact C ON C.ConstituentSystemID__c = F.PhilanthropyManagerLeadConstituentSystemID
Left Join SF_Contact Con ON Con.ConstituentSystemID__c = F.PhilanthropyManagerSupportConstituentSystemID
--INNER JOIN [SVCF].api.Constituent con ON SUBSTRING (F.PrimaryOrganizationConstituentSystemID, 3,len(F.PrimaryOrganizationConstituentSystemID)) = con.ConstituentSystemID
--WHERE SUBSTRING (F.PrimaryOrganizationConstituentSystemID, ,3) = 'O-';
--where F. IS NOT NULL
--f.PrimaryOrganizationConstituentSystemID<>''--F.FundID = '1013'
GO


