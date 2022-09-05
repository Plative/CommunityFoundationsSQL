USE [PlativeDB]
GO

/****** Object:  View [dbo].[SF_Household_Account_Update]    Script Date: 3/12/2022 6:08:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




Create view [dbo].[SF_Household_Account_Update] as 
select 
 
		ConstituentSystemID as ConstituentSystemID__c,
		ConstituentID as ConstituentID__c,
		C.AccountId as ID
		from SVCF.api.Constituent_20210615 Con
--	where IsOrganization = 'true' and ConstituentID= 'O-22514'
inner join PlativeDB.[dbo].SF_Contact C on C.ConstituentSystemID__c = Con.ConstituentSystemID
--where Con.IsOrganization ='False'
inner join [SVCF].api.Household  H on H.HouseholdSystemID  = con.ConstituentSystemID

 

GO


