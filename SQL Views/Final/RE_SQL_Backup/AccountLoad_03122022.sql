USE [PlativeDB]
GO
ALTER view [dbo].[SF_AccountLoad] as 
select 
 (select distinct id from SF_RecordType where SobjectType='Account' and DeveloperName='Organization')as RecordTypeID, 
		ConstituentSystemID as ConstituentSystemID__c,
		ConstituentID as ConstituentID__c,
		OrganizationName as Name,
		DoingBusinessAs as DoingBusinessAs__c,
		([PlativeDB].[dbo].[fn_Fix_Invalid_XML_Chars](MissionStatement) )as MissionStatement__c,
		FiscalYearEnd as FiscalYearEnd__c,
		TaxID as EIN__c,
		TaxIDAlternate as TaxIDAlternate__c,
		TaxIDGroupExempt as TaxIDGroupExempt__c,
		OrganizationExempt990Type as OrganizationExempt990Type__c,
		PrimaryNTEE as NTEE_Code__c,
		IsActive as IsActive__c,
		[PlativeDB].[dbo].[fn_GoodEmailorBlank](EMailPreferred )as Email__c,
		--DoNotShareEMailPreferred as DoNotShareEmailPreferred__c,
		(case 
	when DoNotShareEMailPreferred is null then 'false'
	else DoNotShareEMailPreferred
	end ) as DoNotShareEmailPreferred__c,
		--CellPhone as MobilePhone,
		--DoNotShareCellPhone as DoNotShareCellPhone__c,
		(case 
	when DoNotShareCellPhone is null then '0'
	else DoNotShareCellPhone
	end)as DoNotShareCellPhone__c,
		HomePhone as Phone,
	--	DoNotShareHomePhone as DoNotShareHomePhone__c,
		(case 
	when DoNotShareHomePhone is null then '0'
	else DoNotShareHomePhone 
	end) as DoNotShareHomePhone__c,
		WebsitePersonal as Website,
		--AnonymousForGifts as AnonymousForGifts__c,
		ReportTypeForGifts as ReportTypeForGifts__c,
		Abbreviation as Abbreviation__c,
		Acronym as Acronym__c,
		FoundationType as FoundationType__c,
		PublicSupportTest as PublicSupportTest__c,
		IntermediaryName as IntermediaryName__c,
		IntermediaryTaxID as IntermediaryTaxID__c,
		IntermediaryEstablishedDate as IntermediaryEstablishedDate__c,
		VetEntityType as VetEntityType__c,
		---VetEntityEquivalencyDeterminationRenewAfterDate as VetEntityEDRenewAfterDate__c,
		--VetEntityEquivalencyDeterminationRequired as VetEntityEDRequired__c,
		--VetEntityExpenditureResponsibilityRequired as VetEntityExpenditureResponsibilityRequired,
		(case 
	when VetEntityExpenditureResponsibilityRequired is null then 'false'
	else VetEntityExpenditureResponsibilityRequired
	end ) as VetEntityExpenditureResponsibilityRequir__c,
		VetEntityIntlDueDiligenceType as VetEntityIntlDueDiligenceType__c,
		VetEntityIntlHasMasterGrantAgreement as VetEntityIntlHasMasterGrantAgreement__c,
		VetEntityIntlMasterGrantAgreementDate as VetEntityIntlMasterGrantAgreementDate__c,
		(case 
	when GranteeIsRegisteredForAchViaUnionBank is null then 'false'
	else GranteeIsRegisteredForAchViaUnionBank
	end ) as GranteeIsRegisteredForAchViaUnionBank__c,
		--GranteeIsRegisteredForAchViaUnionBank as GranteeIsRegisteredForAchViaUnionBank__c,
		GranteeRegisteredForAchViaUnionBankDate as GranteeRegisteredForAchViaUnionBankDate__c,
		GranteeValidRecipientStartDate as GranteeValidRecipientStartDate__c,
		GranteeValidRecipientEndDate as GranteeValidRecipientEndDate__c,
		(case 
	when GranteeIsValidPayee is null then 'false'
	else GranteeIsValidPayee
	end ) as GranteeIsValidPayee__c
		--GranteeIsValidPayee as GranteeIsValidPayee__c
		--IsOrganization
		from SVCF.api.Constituent_20210615
--	where IsOrganization = 'true' and ConstituentID= 'O-22514'
where IsOrganization ='True'

GO


