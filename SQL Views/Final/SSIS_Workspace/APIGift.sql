USE [SVCF]
GO

/****** Object:  View [api].[Gift]    Script Date: 3/15/2022 9:11:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










ALTER view [api].[Gift]
as
/*
 *  View: api.Gift
 *
 *  Version: 20210615.1
 *
 *  Description: TODO
 *
 *	Note1: See api.Opportunity and api.Payment for use with Salesforce. RE
 *  incorporates stock sales into the dbo.GIFT table allowing for only a single
 *  sale for each stock/proprety gift. Salesforce allows multiple sales via
 *  the childe object Payment under the Opportunity object.
 *
 *  Note2: RE utilizes the primary gifts table, dbo.GIFTS, for both gifts and
 *  adjustments. This view excludes adjustments including only "net" gifts.
 *  Additional detail about adjustments in case this view requires alteration:
 *
 *  1. RE updates the original gift to match the result of the most recent
 *     adjustment.
 *  2. Adjustments appear in the dbo.GIFT table. Can exclude by checking for ID
 *     exists in dbo.GiftAdjustment.AdjustmentID. It also appears the column
 *     dbo.GIFT.TYPE equals 28 for adjustments and only for adjustments. Not
 *     100% confident so filter via dbo.GiftAdjustment.AdjustmentID instead.
 *  3. Adjustments store their previous values in dbo.GiftHistoryFields. The ID
 *     column is both the primary key for that table and a foreign key to
 *     dbo.GIFT.ID.
 *  4. Adjustmsnts AND original gift store previous splits in
 *     dbo.GiftPreviousSplit. Not sure why original stores previous split.
 *  5. Though not relevant to SVCF, the table dbo.GiftPreviousSolicitor likely
 *     behaves the same as dbo.GiftPreivousSplit. Did not investigate fully.
 *
 *  2021-09-14
 *  Logan J Travis  
 *  ltravis@siliconvalleycf.org
 */
/*
 *  Common table expressions
 */
/* Map RE gift type IDs (dbo.GIFT.TYPE) to external gift type names.

   Note1: Can get RE gift type IDs and names by configuring a report with all
   gift types included in filter. Table dbo.REPORTPARAMETERVALUES should then
   include one row per gift type where ReportParameterNamesID = your report
   system ID and PropertyID = 256 for the gift types filter. See example:

	   select ValueNumber
		, [Text]
		from dbo.REPORTPARAMETERVALUES
		where ReportParameterNamesID = 945	--ljt-test-210914
			and PropertyID = 256			--Gift Types filter
		;

	Note2: Adjustments and gifts deleted after posting to finance system do not
	appear using the trick above as they are never included in reports. Pretty
	sure they are IDs 28 and 32 respectively.
*/
with giftTypeMap as (
	select *
	from (
		values
			(1, 'Cash', 'Cash', null)
			, (2, 'Pay-Cash', 'Cash', null)
			, (3, 'MG Pay-Cash', 'Cash', null)
			, (8, 'Pledge', 'Pledge', null)
			, (9, 'Stock/Property', 'Stock/Property', cast(0 as bit))
			, (10, 'Stock/Property (Sold)', 'Stock/Property', cast(1 as bit))
			, (11, 'Pay-Stock/Property', 'Stock/Property', cast(0 as bit))
			, (12, 'MG Pay-Stock/Property', 'Stock/Property', cast(0 as bit))
			, (13, 'Pay-Stock/Property (Sold)', 'Stock/Property', cast(1 as bit))
			, (14, 'MG Pay-Stock/Property (Sold)', 'Stock/Property', cast(1 as bit))
			, (15, 'Gift-in-Kind', 'Gift-in-Kind', null)
			, (16, 'Pay-Gift-in-Kind', 'Gift-in-Kind', null)
			, (17, 'MG Pay-Gift-in-Kind', 'Gift-in-Kind', null)
			, (18, 'Other', 'Other', null)
			, (19, 'Pay-Other', 'Other', null)
			, (20, 'MG Pay-Other', 'Other', null)
			, (21, 'Write Off', 'Write Off', null)
			, (22, 'MG Write Off', 'Write Off', null)
			, (27, 'MG Pledge', 'Pledge', null)
			, (28, 'Adjustment', 'Adjustment', null)
			, (30, 'Recurring Gift', 'Recurring Gift', null)
			, (31, 'Recurring Gift Pay-Cash', 'Cash', null)
			, (32, 'Deleted after posting to finance system', 'Deleted', null)
			, (34, 'Planned Gift', 'Planned Gift', null)
		) as t (GiftTypeID, reGiftTypeName, extGiftTypeName, stockPropSold)
)


/*
 *  Main query
 */
select
	/*
	 * Common columns
	 */
	g.ID as GiftSystemID
	, g.UserGiftId as GiftID	

	/* Translate RE's single constituent design to account vs. contact
	
	   Note1: I initially tried to include the household as the
	   AccountConstituentSystemID by joining to api.Constituent. That degraded
	   performance to an unusable level. Assume contact's current household
	   when AccountConstituentSystemID is null.
	   
	   Note2: AccountConstituentSystemID = -1 indidcates an interfund transfer
	   in from another fund. Use to be created placeholder account. */
	, case
		when r.CONSTITUENT_ID like replicate('[0-9]', 4) + '-F'
			then -1
		when r.KEY_INDICATOR = 'O'
			then r.ID
		else null
	end as AccountConstituentSystemID
	, case when r.KEY_INDICATOR = 'I'
			then r.ID
		else null
	end as ContactConstituentSystemID
	
	, case
		when r.CONSTITUENT_ID like replicate('[0-9]', 4) + '-F'
			then 'Interfund Transfer'
		else giftTypeMap.extGiftTypeName
	end as GiftType
	, gSubType.LONGDESCRIPTION as GiftSubType								   --Keep for reference; too many Other type gifts to parse
	, null as Stage
	, g.Amount as GiftAmount

	/* Ignore b/c only recording USD */
	--, g.CURRENCY_COUNTRY
	--, g.CURRENCY_AMOUNT
	--, g.CURRENCY_EXCHANGE_RATE

	, g.DTE as GiftDate
	, g.POST_DATE as GiftPostDate
	, case g.POST_STATUS
		when 1 then 'Posted'
		when 2 then 'Not Yet Posted'
		when 3 then 'Do Not Post'
	end as GiftPostStatus
	, g.REF as GiftReference
	, g.BATCH_NUMBER as BatchNumber
	, gLetterCode.LONGDESCRIPTION as AcknowledgementLetterCode
	, case g.ACKNOWLEDGE_FLAG
		when 1 then 'Acknowledged'
		when 2 then 'Not Yet Acknowledged'
		when 3 then 'Do Not Acknowledge'
	end as AcknowledgementStatus
	, g.AcknowledgeDate as AcknowledgementDateFuzzy
	, letterSigner.LONGDESCRIPTION as LetterSigner								--select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1051 
	, case ackCombine.BOOLEAN
		when -1 then cast(1 as bit)
		else cast(0 as bit)
	end as AcknowledgeAsCombined
	, case g.[ANONYMOUS]
		when -1 then cast(1 as bit)
		else cast(0 as bit)
	end as IsAnonymous
	, case estGift.BOOLEAN
		when -1 then cast(1 as bit)
		else cast(0 as bit)
	end as IsEstablishingGiftToFund
	, case newDonor.BOOLEAN
		when -1 then cast(1 as bit)
		else cast(0 as bit)
	end as IsFirstGiftFromNewDonor
	, pmtIssuer.LONGDESCRIPTION as PaymentIssuer							   --select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1085
	, case gDetAttr.TABLEENTRIESID
		when 3292 then cast(1 as bit)										   --Grant Award with Payment
		when 3328 then cast(1 as bit)										   --Grant
		else cast(0 as bit)
	end as IsGrant

	/* Cash exclusive columnns */
	, case g.PAYMENT_TYPE
		when 1 then 'Cash'
		when 2 then 'Personal Check'
		when 3 then 'Business Check'
		when 4 then 'Credit Card'
		when 5 then 'Direct Debit'
		when 8 then 'Other'
	end as PaymentMethod
	, g.CHECK_NUMBER as PaymentNumber
	, g.CHECK_DATE as PaymentDate

	/* Stock/Property exclusive columns */
	, g.Issuer as AssetName
	, coalesce(
		symbolMF.[TEXT]
		, g.IssuerSymbol
	) as AssetSymbol

	/* We apparently do not use the standard field for number of units. I found
	   only one gift with ID 62031 that had a value in the standard field but
	   not in our attribute */
	--, g.IssuerNumUnits as AssetNumberOfUnits

	/* I encounterd a few errors trying to convert number of units, high, and lo
	   values so kept as text */
	, rtrim(
		ltrim(
			replace(
				replace(
					symbolCount.[TEXT]
					, '$'
					, ''
				)
				, ','
				, ''
			)
		)
	) as AssetNumberOfUnits
	, rtrim(
		ltrim(
			replace(
				replace(
					symbolHi.[TEXT]
					, '$'
					, ''
				)
				, ','
				, ''
			)
		)
	) as AssetHighValue
	, rtrim(
		ltrim(
			replace(
				replace(
					symbolLo.[TEXT]
					, '$'
					, ''
				)
				, ','
				, ''
			)
		)
	) as AssetLowValue
	, g.IssuerMedianPrice as AssetMeanValue									   --Yes, I know the table column says median. We use it to store mean according to the Gifts team
	, brokerage.LONGDESCRIPTION as Brokerage								   --select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1046
	, eightyTwoReq.LONGDESCRIPTION as EightyTwoEightyTwoRequired			   --select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1146
	, eightyTwoFiled.LONGDESCRIPTION as EightyTwoEightyTwoFilingComplete	   --select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1144
	, stockPropDet.LONGDESCRIPTION as StockPropertyDetail					   --select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1070
	, giftTypeMap.stockPropSold as StockPropertyWasSold

	/* SOLD Stock/Property exclusive columns */
	, g.STOCK_SALE_VALUE as SaleAmount
	, g.BROKER_FEE as SaleFeeAmount
	, g.STOCK_SALE_DATE as SaleDate
	, g.SALE_OF_STOCK_POST_DATE as SalePostDate
	, case g.SALE_OF_STOCK_POST_STATUS
		when 1 then 'Posted'
		when 2 then 'Not Yet Posted'
		when 3 then 'Do Not Post'
	end as SalePostStatus
	, g.STOCK_SALE_COMMENT as SaleReference

	/* Event exclusive columns */
	, null as FairMarketValue												   --We do not currently store the FMV
	, fmvDetail.[DESCRIPTION] as FairMarketValueDetail						   --select LONGDESCRIPTION from dbo.TABLEENTRIES where CODETABLESID = 1084

	/* Pledge exclusive columns
	
	   EXCLUDED because we set every pledge to Active (GIFT_STATUS = 1) */
	--, null as PledgeStatus
	--, null as PledgeStatusDate
from dbo.GIFT as g

	/* Join gift constituent */
	join dbo.RECORDS as r on g.CONSTIT_ID = r.ID

	/* Join gift type and subtype */
	left outer join giftTypeMap on g.[TYPE] = giftTypeMap.GiftTypeID
	left outer join dbo.TABLEENTRIES as gSubType
		on g.GiftSubType = gSubType.TABLEENTRIESID

	/* Join acknowledgement letter code */
	left outer join dbo.TABLEENTRIES as gLetterCode
		on g.LETTER_CODE = gLetterCode.TABLEENTRIESID

	/* Join letter signer */
	left outer join dbo.GiftAttributes as letterSignerAttr on (
		g.ID = letterSignerAttr.PARENTID
		and letterSignerAttr.ATTRIBUTETYPESID = 2197						   --Letter Signer
	)
	left outer join dbo.TABLEENTRIES as letterSigner
		on letterSignerAttr.TABLEENTRIESID = letterSigner.TABLEENTRIESID

	/* Join acknowledge as combined */
	left outer join dbo.GiftAttributes as ackCombine on (
		g.ID = ackCombine.PARENTID
		and ackCombine.ATTRIBUTETYPESID = 144								   --Acknowledge as Combined
	)

	/* Join establishing gift */
	left outer join dbo.GiftAttributes as estGift on (
		g.ID = estGift.PARENTID
		and estGift.ATTRIBUTETYPESID = 2251									   --Establishing Gift to a Fund
	)

	/* Join new donor */
	left outer join dbo.GiftAttributes as newDonor on (
		g.ID = newDonor.PARENTID
		and newDonor.ATTRIBUTETYPESID = 2249								   --New Donor
	)

	/* Join payment issuer */
	left outer join dbo.GiftAttributes as pmtIssuerAttr on (
		g.ID = pmtIssuerAttr.PARENTID
		and pmtIssuerAttr.ATTRIBUTETYPESID = 2287							   --Payment Issuer
	)
	left outer join dbo.TABLEENTRIES as pmtIssuer
		on pmtIssuerAttr.TABLEENTRIESID = pmtIssuer.TABLEENTRIESID

	/* Join gift detail; NOTE: Only care when TABLEENTRIESID in (3292, 3328)
	   to mark gift IsGrant = true */
	left outer join dbo.GiftAttributes as gDetAttr on (
		g.ID = gDetAttr.PARENTID
		and gDetAttr.ATTRIBUTETYPESID = 2288								   --Gift Detail
	)

	/* Join mutual fund symbol */
	left outer join dbo.GiftAttributes as symbolMF on (
		g.ID = symbolMF.PARENTID
		and symbolMF.ATTRIBUTETYPESID = 2227								   --Mutual Fund Symbol
	)

	/* Join shares number of */
	left outer join dbo.GiftAttributes as symbolCount on (
		g.ID = symbolCount.PARENTID
		and symbolCount.ATTRIBUTETYPESID = 2184								   --Shares number of
	)

	/* Join shares high */
	left outer join dbo.GiftAttributes as symbolHi on (
		g.ID = symbolHi.PARENTID
		and symbolHi.ATTRIBUTETYPESID = 2183								   --Shares High
	)

	/* Join shares low */
	left outer join dbo.GiftAttributes as symbolLo on (
		g.ID = symbolLo.PARENTID
		and symbolLo.ATTRIBUTETYPESID = 2182								   --Shares Low
	)

	/* Join brokerage firm */
	left outer join dbo.GiftAttributes as brokerageAttr on (
		g.ID = brokerageAttr.PARENTID
		and brokerageAttr.ATTRIBUTETYPESID = 2187							   --Brokerage Firm
	)
	left outer join dbo.TABLEENTRIES as brokerage
		on brokerageAttr.TABLEENTRIESID = brokerage.TABLEENTRIESID

	/* Join stock/property detail */
	left outer join dbo.GiftAttributes as stockPropDetAttr on (
		g.ID = stockPropDetAttr.PARENTID
		and stockPropDetAttr.ATTRIBUTETYPESID = 2250						   --Stock/Property Detail
	)
	left outer join dbo.TABLEENTRIES as stockPropDet
		on stockPropDetAttr.TABLEENTRIESID = stockPropDet.TABLEENTRIESID

	/* Join 8282 required */
	left outer join dbo.GiftAttributes as eightyTwoReqAttr on (
		g.ID = eightyTwoReqAttr.PARENTID
		and eightyTwoReqAttr.ATTRIBUTETYPESID = 2457						   --8282 Required
	)
	left outer join dbo.TABLEENTRIES as eightyTwoReq
		on eightyTwoReqAttr.TABLEENTRIESID = eightyTwoReq.TABLEENTRIESID

	/* Join 8282 filing completed */
	left outer join dbo.GiftAttributes as eightyTwoFiledAttr on (
		g.ID = eightyTwoFiledAttr.PARENTID
		and eightyTwoFiledAttr.ATTRIBUTETYPESID = 2456						   --8282 Filing Completed
	)
	left outer join dbo.TABLEENTRIES as eightyTwoFiled
		on eightyTwoFiledAttr.TABLEENTRIESID = eightyTwoFiled.TABLEENTRIESID

	/*	Join mixed gift detail	*/
	outer apply (
		select stuff(
			(
				select ';' + [label].LONGDESCRIPTION
				from dbo.GiftAttributes as attr
					join dbo.TABLEENTRIES as [label]
						on attr.TABLEENTRIESID = [label].TABLEENTRIESID
				where attr.PARENTID = g.ID
					and attr.ATTRIBUTETYPESID = 2286						   --Mixed Gift Detail
				order by [label].LONGDESCRIPTION
				for xml path(N'')
			)
			, 1
			, 1
			, ''
		) as [DESCRIPTION]
	) as fmvDetail
where g.[TYPE] not in (
		21																	   --Write-Off --> handle via separate Pledge Fulfillment object
		, 22																   --MG Write-Off  --> handle via separate Pledge Fulfillment object
		, 28																   --Adjustment
		, 30																   --Recurring Gift
		, 32																   --Deletion after posting
		, 34																   --Planned Gift --> all marked Do Not Post; CGA and CRT handled separately
	)
;
GO


