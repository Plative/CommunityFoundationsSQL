USE [PlativeDB]
GO

/****** Object:  View [dbo].[SF_Address]    Script Date: 3/12/2022 6:06:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[SF_Address] as
SELECT 
	A.Account_Id__c as npsp__Household_Account__c,
	ad.AddressSystemID as AddressSystemID__C,
	ad.Type as npsp__Address_Type__c,
	ad.IsPreferred as npsp__Default_Address__c,
	ad.City as npsp__MailingCity__c,
	ad.Country as npsp__MailingCountry__c,
	ad.PostalCode as npsp__MailingPostalCode__c,
	ad.StateProvince as npsp__MailingState__c,
	ad.AddressLines as npsp__MailingStreet__c
FROM [SVCF].[api].[Address] ad
--JOIN [SVCF].api.Constituent con ON ad.ConstituentSystemID = con.ConstituentSystemID
Inner Join [PlativeDB].[dbo].[SF_Account] A ON ad.ConstituentSystemID = A.ConstituentSystemID__c


GO


