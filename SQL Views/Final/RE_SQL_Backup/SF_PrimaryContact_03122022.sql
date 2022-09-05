USE [PlativeDB]
GO

/****** Object:  View [dbo].[SF_PrimaryContact]    Script Date: 3/12/2022 6:08:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[SF_PrimaryContact] as 

select

	con.ConstituentSystemID as ConstituentSystemID__c,
	con.ConstituentID  as ConstituentID__c,
	con.LastName as LastName,
	con.FirstName as FirstName,
	con.MiddleName as MiddleName,
	con.Nickname as Nickname__c,
	con.MaidenName as MaidenName__c,
	con.Title1 as Salutation,
	con.Suffix1 as Suffix,
	con.MaritalStatus as MaritalStatus__c,
	con.Gender as Gender__c,
	(case 
		when len(con.BirthDateFuzzy) =8 then (substring(con.BirthDateFuzzy ,1,4)+'-'+substring(con.BirthDateFuzzy ,5,2)+'-'+substring(con.BirthDateFuzzy ,7,2))
		else Null
		end) as BirthDate,
	--con.BirthDateFuzzy as Birthdate,
	con.IsDeceased as npsp__Deceased__c,
	(case 
		when len(con.DeceasedDateFuzzy) =8 then (substring(con.DeceasedDateFuzzy ,1,4)+'-'+substring(con.DeceasedDateFuzzy ,5,2)+'-'+substring(con.DeceasedDateFuzzy ,7,2))
		else Null
		end) as DeceasedDate__c,
	--cast(DeceasedDateFuzzy as date)as DeceasedDate__c,
	con.IsActive as IsActive__c,
	con.IsStaff as IsStaff__c,
	[PlativeDB].[dbo].[fn_GoodEmailorBlank]((con.EMailPreferred+'.invalid')) as Email,
	(case 
	when con.DoNotShareEMailPreferred is null then 'false'
	else con.DoNotShareEMailPreferred
	end ) as DoNotShareEmailPreferred__c,
	con.CellPhone as MobilePhone,
	(case 
	when con.DoNotShareCellPhone is null then '0'
	else con.DoNotShareCellPhone
	end)as DoNotShareCellPhone__c,
	con.HomePhone as Phone,
	(case 
	when con.DoNotShareHomePhone is null then '0'
	else con.DoNotShareHomePhone 
	end)
	 as DoNotShareHomePhone__c,
	con.WebsitePersonal as Website__c,
	[PlativeDB].[dbo].[fn_GoodEmailorBlank](con.EMailBusiness) as npe01__WorkEmail__c,
	(case 
	when con.DoNotShareEMailBusiness is null then 'false'
	else con.DoNotShareEMailBusiness
	end)as DoNotShareEmailBusiness__c,
	 con.DirectBusinessPhone as npe01__WorkPhone__c,
	(case 
	when con.DoNotShareDirectBusinessPhone is null then '0'
	else con.DoNotShareDirectBusinessPhone
	 end)as DoNotShareDirectBusinessPhone__c,
	con.MainBusinessPhone as OtherPhone,
	(case 
	when con.DoNotShareMainBusinessPhone is null then '0'
	else  con.DoNotShareMainBusinessPhone 
	end)as DoNotShareMainBusinessPhone__c,
	con.WebsiteBusiness as WebsiteBusiness__c,
	con.AnonymousForGifts as AnonymousForGifts__c,
	con.ReportTypeForGifts as ReportTypeForGifts__c,
	con.ProfessionalAdvisorRating as ProfessionalAdvisorRating__c,
	con.ProfessionalAdvisorType as Professional_Advisor_Type__c,
	con.PrimaryBusinessPosition as Title

from [SVCF].api.Constituent_20210615 con
join [SVCF].api.Household  H on H.HouseholdSystemID  = con.ConstituentSystemID








GO


