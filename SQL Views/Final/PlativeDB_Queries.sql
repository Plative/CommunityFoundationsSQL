USE [PlativeDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DateToSFDateFormat]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[fn_DateToSFDateFormat](@Inputdate datetime )
RETURNS nVARCHAR(50)
as 
Begin
	RETURN CONVERT(NVARCHAR,@Inputdate,126)+'Z'
end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_Fix_Invalid_XML_Chars]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Function [dbo].[fn_Fix_Invalid_XML_Chars](@strText NVARCHAR(max))
RETURNS NVARCHAR(max)
AS
BEGIN

	set @strText = REPLACE(CAST(@strText as varchar(max)) COLLATE SQL_Latin1_General_CP1_CI_AS, CHAR(0),'')
	set @strText = replace(@strText,CHAR(0x0),'')
	set @strText = replace(@strText,CHAR(0x1),'')
	set @strText = replace(@strText,CHAR(0x2),'')
	set @strText = replace(@strText,CHAR(0x3),'')
	set @strText = replace(@strText,CHAR(0x4),'')
	set @strText = replace(@strText,CHAR(0x5),'')
	set @strText = replace(@strText,CHAR(0x6),'')
	set @strText = replace(@strText,CHAR(0x7),'')
	set @strText = replace(@strText,CHAR(0x8),'')
	set @strText = replace(@strText,CHAR(0x9),'')


	set @strText = replace(@strText,CHAR(0x10),'')
	set @strText = replace(@strText,CHAR(0x11),'')
	set @strText = replace(@strText,CHAR(0x12),'')
	set @strText = replace(@strText,CHAR(0x13),'')
	set @strText = replace(@strText,CHAR(0x14),'')
	set @strText = replace(@strText,CHAR(0x15),'')
	set @strText = replace(@strText,CHAR(0x16),'')
	set @strText = replace(@strText,CHAR(0x17),'')
	set @strText = replace(@strText,CHAR(0x18),'')
	set @strText = replace(@strText,CHAR(0x19),'')

	set @strText = replace(@strText,CHAR(0xa),'')
	set @strText = replace(@strText,CHAR(0xb),'')
	set @strText = replace(@strText,CHAR(0xc),'')
	set @strText = replace(@strText,CHAR(0xd),Char(10))
	set @strText = replace(@strText,CHAR(0xe),'')
	set @strText = replace(@strText,CHAR(0xf),'')

	set @strText = replace(@strText,CHAR(0x1a),'''')
	set @strText = replace(@strText,CHAR(0x1b),'')
	set @strText = replace(@strText,CHAR(0x1c),'')
	set @strText = replace(@strText,CHAR(0x1d),'')
	set @strText = replace(@strText,CHAR(0x1e),'')
	set @strText = replace(@strText,CHAR(0x1f),'')

	set @strText = replace(@strText,CHAR(0x7f),'')
	
    RETURN @strText
END




GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetNamePart]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[fn_GetNamePart](@FullName NVarchar(3000),@Namepart Char(1))
returns Nvarchar(1000)   
-- @Namepart : F=First,M=Middle,L=Last
begin
	Declare @FirstName Varchar(1000)
	Declare @MiddleName Varchar(1000)
	Declare @LastName Varchar(1000)
	Declare @Return Varchar(1000)

	select @FullName=rtrim(ltrim(coalesce(@FullName,'')))+' '
	SELECT @FirstName= SUBSTRING(@FullName, 1, CHARINDEX(' ', @FullName) - 1) 
	
	select @FullName=' '+rtrim(ltrim(@FullName))
	SELECT @LastName=  REVERSE(SUBSTRING(REVERSE(@FullName), 1, CHARINDEX(' ', REVERSE(@FullName)) - 1)) 
	SELECT @MiddleName=replace(replace(@FullName,@FirstName,''),@LastName,'')

	SELECT @Return = case when @Namepart = 'F' then @FirstName
				when @Namepart = 'M' then @MiddleName
				when @Namepart = 'L' then @LastName
			else Null end

	SELECT @Return = rtrim(ltrim(@Return))
	SELECT @Return = case when @Return='' then null else @Return end
	
	Return @Return 
end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_GoodEmailorBlank]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GoodEmailorBlank]    Script Date: 02/25/2015 16:07:35 ******/
CREATE function [dbo].[fn_GoodEmailorBlank](@EmailAddress varchar(1000))
returns varchar(1000)   
begin
	declare @return varchar(1000)
	declare @email varchar(1000)
	set @email = rtrim(ltrim(@EmailAddress))

	--- Do some basic Cleanup
	select  @email =replace(replace(replace(replace(replace(@email,'`',''''),'[',''),']',''),'’',''''),'>','') 
	select  @email =replace(@email,'mailto:','')
	select  @email =replace(@email,'/','')
	select  @email =replace(@email,'\','')
	select  @email =replace(@email,')','')
	select  @email =replace(@email,' ','')
	select  @email =  @email Collate SQL_Latin1_General_CP1253_CI_AI  --- Convert Diacritics 
	
	-- cannot end or start with apostrophe, but they are ok inside of a name: e.g. O'Connor
	select  @email = CASE WHEN @email like '%''' or @email like '''%'  then  replace(@email,'''','') else  @email end 
	------
	select  @email = 
		CASE WHEN 
				 @email LIKE '%_@_%_._%' 
				 AND @email NOT LIKE '%.'
				 AND @email NOT LIKE '%?%'
				 AND @email NOT LIKE '%..%'
				 and @email NOT LIKE '%@%@%'
				 and @email NOT LIKE '%@%[_]%' ----- This is a Salesforce defect, Domains can have Underscores
		THEN @email
		ELSE '' 
		END
	
	---- Valiate there is no spaces or invaliud Chars in the Emnail Address
	select  @return = 
	CASE WHEN 
			 @email LIKE '% %' or @email LIKE '%,%'  or @email LIKE '%;%' 
	THEN	''
	ELSE @email 
	END
	
	return  @return
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 12/9/2016 12:26:52 PM ******/
/* Sample Code
		Select split.data
		from	tbl t
		cross apply	dbo.[fn_Split](t.f1, ',') as split
*/

Create FUNCTION [dbo].[fn_Split]
(
	@RowData nvarchar(max),
	@SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
	Id int identity(1,1),
	Data nvarchar(max)
) 
AS  
BEGIN 
	Declare @Cnt int
	Set @Cnt = 1

	While (Charindex(@SplitOn,@RowData)>0)
	Begin
		Insert Into @RtnValue (data)
		Select 
			Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))

		Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
		Set @Cnt = @Cnt + 1
	End
	
	Insert Into @RtnValue (data)
	Select Data = ltrim(rtrim(@RowData))

	Return
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnParseFMName]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- Function fnParseFMName
create  FUNCTION [dbo].[fnParseFMName] 
               (@FullName VARCHAR(128)) 
RETURNS VARCHAR(128)
AS
BEGIN 
    DECLARE  @FirstName  VARCHAR(128), 
             @MiddleName VARCHAR(128), 
             @LastName   VARCHAR(128), 
             @WORK       VARCHAR(128) 

	declare @s2 varchar(256), @l int, @p int

	set @s2 = ''
	set @l = len(@FullName)
	set @p = 1
	while @p <= @l 
	begin
		declare @c int
		set @c = ascii(substring(@FullName, @p, 1))
		if @c = 32 or @c between 48 and 57 or @c between 65 and 90 or @c between 97 and 122
			set @s2 = @s2 + char(@c)
		set @p = @p + 1
    end

    SET @FullName = RTRIM(LTRIM(REPLACE(@s2,'.','. '))) 
    -- REPLACE DOUBLE SPACE WITH A SINGLE SPACE - ELIMINATE EXTRA SPACES 
    -- make sure the following line copies the single and double spaces correcly 
    WHILE CHARINDEX('  ',@FullName) > 0 
      SET @FullName = REPLACE(@FullName,'  ',' ') 

    WHILE CHARINDEX('.',@FullName) > 0 
      SET @FullName = REPLACE(@FullName,'.','') 

    SET @WORK = RTRIM(LEFT(@FullName,CHARINDEX(' ',@FullName))) 

    IF RIGHT(@WORK,1) = ',' 
      SET @LastName = LEFT(@WORK,LEN(@WORK) - 1) 

    IF LEN(@LastName) > 0 
      SET @FullName = LTRIM(RIGHT(@FullName,LEN(@FullName) - LEN(@WORK))) 

    WHILE CHARINDEX(',',@FullName) > 0 
      SET @FullName = REPLACE(@FullName,',','') 

    IF @LastName IS NULL and CHARINDEX(' ',@FullName) > 0
      BEGIN 
        SET @LastName=LTRIM(RIGHT(@FullName,CHARINDEX(' ',
                                REVERSE(@FullName)+' '))) 
        SET @FullName=RTRIM(LEFT(@FullName,LEN(@FullName) - LEN(@LastName))) 
      END 

    SET @FirstName = RTRIM(LEFT(@FullName,CHARINDEX(' ',@FullName + ' '))) 
    SET @FullName = LTRIM(RIGHT(@FullName,LEN(@FullName) - LEN(@FirstName))) 
    SET @MiddleName = @FullName 
    RETURN (rtrim(isnull(@FirstName, '') + ' ' + isnull(@MiddleName,'')))
  END
GO
/****** Object:  UserDefinedFunction [dbo].[fnParseLName]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- Function fnParseLName
create  FUNCTION [dbo].[fnParseLName] 
               (@FullName VARCHAR(128)) 
RETURNS VARCHAR(128)
AS
BEGIN 
    DECLARE  @FirstName  VARCHAR(128), 
             @MiddleName VARCHAR(128), 
             @LastName   VARCHAR(128), 
             @WORK       VARCHAR(128)
			 
	declare @s2 varchar(256), @l int, @p int
	set @s2 = ''
	set @l = len(@FullName)
	set @p = 1
	while @p <= @l 
	begin
		declare @c int
		set @c = ascii(substring(@FullName, @p, 1))
		if @c = 32 or @c between 48 and 57 or @c between 65 and 90 or @c between 97 and 122
			set @s2 = @s2 + char(@c)
		set @p = @p + 1
    end			  

    SET @FullName = RTRIM(LTRIM(REPLACE(@s2,'.','. '))) 
    -- REPLACE DOUBLE SPACE WITH A SINGLE SPACE - ELIMINATE EXTRA SPACES 
    -- make sure the following line copies the single and double spaces correcly 
    WHILE CHARINDEX('  ',@FullName) > 0 
      SET @FullName = REPLACE(@FullName,'  ',' ') 

    WHILE CHARINDEX('.',@FullName) > 0 
      SET @FullName = REPLACE(@FullName,'.','') 

    SET @WORK = RTRIM(LEFT(@FullName,CHARINDEX(' ',@FullName))) 

    IF RIGHT(@WORK,1) = ',' 
      SET @LastName = LEFT(@WORK,LEN(@WORK) - 1) 

    IF LEN(@LastName) > 0 
      SET @FullName = LTRIM(RIGHT(@FullName,LEN(@FullName) - LEN(@WORK))) 

    WHILE CHARINDEX(',',@FullName) > 0 
      SET @FullName = REPLACE(@FullName,',','') 

    IF @LastName IS NULL and CHARINDEX(' ',@FullName) > 0 
      BEGIN 
        SET @LastName=LTRIM(RIGHT(@FullName,CHARINDEX(' ',
                                REVERSE(@FullName)+' '))) 
        SET @FullName=RTRIM(LEFT(@FullName,LEN(@FullName) - LEN(@LastName))) 
      END 

    SET @FirstName = RTRIM(LEFT(@FullName,CHARINDEX(' ',@FullName + ' '))) 
    SET @FullName = LTRIM(RIGHT(@FullName,LEN(@FullName) - LEN(@FirstName))) 
    SET @MiddleName = @FullName 

    RETURN @LastName
  END
GO
/****** Object:  Table [dbo].[GiftToLoad]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftToLoad](
	[GiftSystemID] [int] NOT NULL,
	[GiftID] [varchar](50) NULL,
	[AccountConstituentSystemID] [int] NULL,
	[ContactConstituentSystemID] [int] NULL,
	[GiftType] [varchar](18) NULL,
	[GiftSubType] [varchar](100) NULL,
	[Stage] [int] NULL,
	[GiftAmount] [numeric](20, 4) NOT NULL,
	[GiftDate] [datetime] NOT NULL,
	[GiftPostDate] [datetime] NULL,
	[GiftPostStatus] [varchar](14) NULL,
	[GiftReference] [varchar](255) NULL,
	[BatchNumber] [varchar](50) NULL,
	[AcknowledgementLetterCode] [varchar](100) NULL,
	[AcknowledgementStatus] [varchar](20) NULL,
	[AcknowledgementDateFuzzy] [varchar](8) NULL,
	[LetterSigner] [varchar](100) NULL,
	[AcknowledgeAsCombined] [bit] NULL,
	[IsAnonymous] [bit] NULL,
	[IsEstablishingGiftToFund] [bit] NULL,
	[IsFirstGiftFromNewDonor] [bit] NULL,
	[PaymentIssuer] [varchar](100) NULL,
	[IsGrant] [bit] NULL,
	[PaymentMethod] [varchar](14) NULL,
	[PaymentNumber] [varchar](20) NULL,
	[PaymentDate] [varchar](8) NULL,
	[AssetName] [varchar](50) NULL,
	[AssetSymbol] [varchar](255) NULL,
	[AssetNumberOfUnits] [varchar](8000) NULL,
	[AssetHighValue] [varchar](8000) NULL,
	[AssetLowValue] [varchar](8000) NULL,
	[AssetMeanValue] [numeric](30, 6) NOT NULL,
	[Brokerage] [varchar](100) NULL,
	[EightyTwoEightyTwoRequired] [varchar](100) NULL,
	[EightyTwoEightyTwoFilingComplete] [varchar](100) NULL,
	[StockPropertyDetail] [varchar](100) NULL,
	[StockPropertyWasSold] [bit] NULL,
	[SaleAmount] [numeric](30, 6) NOT NULL,
	[SaleFeeAmount] [numeric](30, 6) NOT NULL,
	[SaleDate] [datetime] NULL,
	[SalePostDate] [datetime] NULL,
	[SalePostStatus] [varchar](14) NULL,
	[SaleReference] [text] NULL,
	[FairMarketValue] [int] NULL,
	[FairMarketValueDetail] [nvarchar](max) NULL,
	[GiftDetail] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SF_All_Accounts]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_All_Accounts](
	[Abbreviation__c] [nvarchar](255) NULL,
	[Account_Id__c] [nvarchar](1300) NULL,
	[Account_Image_URL__c] [nvarchar](255) NULL,
	[Account_Name__c] [nvarchar](1300) NULL,
	[Account_URL__c] [nvarchar](1300) NULL,
	[AccountNumber] [nvarchar](40) NULL,
	[AccountSource] [nvarchar](4000) NULL,
	[Acronym__c] [nvarchar](80) NULL,
	[Address_Verified__c] [float] NULL,
	[Alias__c] [nvarchar](20) NULL,
	[AnnualRevenue] [float] NULL,
	[Approved_Recipient_Account__c] [bit] NULL,
	[Assets__c] [float] NULL,
	[Bank_Name__c] [nvarchar](100) NULL,
	[BillingCity] [nvarchar](40) NULL,
	[BillingCountry] [nvarchar](80) NULL,
	[BillingGeocodeAccuracy] [nvarchar](4000) NULL,
	[BillingLatitude] [float] NULL,
	[BillingLongitude] [float] NULL,
	[BillingPostalCode] [nvarchar](20) NULL,
	[BillingState] [nvarchar](80) NULL,
	[BillingStreet] [nvarchar](255) NULL,
	[ChannelProgramLevelName] [nvarchar](255) NULL,
	[ChannelProgramName] [nvarchar](255) NULL,
	[Charitable_goals_questions_and_concerns__c] [nvarchar](max) NULL,
	[City__c] [nvarchar](1300) NULL,
	[ConstituentID__c] [nvarchar](255) NULL,
	[ConstituentSystemID__c] [nvarchar](255) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Deductibility_Status_Description__c] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DoingBusinessAs__c] [nvarchar](255) NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[DS360oi__Active__c] [nvarchar](4000) NULL,
	[DS360oi__Background_Batch_Flag__c] [bit] NULL,
	[DS360oi__CustomerPriority__c] [nvarchar](4000) NULL,
	[DS360oi__DS_update__c] [nvarchar](255) NULL,
	[DS360oi__DS_update_date__c] [datetime] NULL,
	[DS360oi__Middle_Initial_Name__c] [nvarchar](10) NULL,
	[DS360oi__NumberofLocations__c] [float] NULL,
	[DS360oi__SLA__c] [nvarchar](4000) NULL,
	[DS360oi__SLAExpirationDate__c] [date] NULL,
	[DS360oi__SLASerialNumber__c] [nvarchar](10) NULL,
	[DS360oi__UpsellOpportunity__c] [nvarchar](4000) NULL,
	[EIN__c] [nvarchar](18) NULL,
	[Email__c] [nvarchar](255) NULL,
	[Email_Address__c] [nvarchar](80) NULL,
	[Favourite__c] [nvarchar](1300) NULL,
	[Fax] [nvarchar](40) NULL,
	[Field_of_Interest__c] [nvarchar](max) NULL,
	[FiscalYearEnd__c] [nvarchar](100) NULL,
	[Foundation_Status_Code__c] [nvarchar](10) NULL,
	[FoundationType__c] [nvarchar](255) NULL,
	[Grant_Recommendation_Form_URL__c] [nvarchar](1300) NULL,
	[GranteeIsRegisteredForAchViaUnionBank__c] [bit] NULL,
	[GranteeIsValidPayee__c] [bit] NULL,
	[GranteeRegisteredForAchViaUnionBankDate__c] [date] NULL,
	[GranteeValidRecipientEndDate__c] [date] NULL,
	[GranteeValidRecipientStartDate__c] [date] NULL,
	[Gross_Receipts__c] [float] NULL,
	[GuideStar_Address__c] [nvarchar](255) NULL,
	[GuideStar_Location__c] [nvarchar](255) NULL,
	[GuideStar_Organization_Name__c] [nvarchar](255) NULL,
	[GuideStar_Sync_Date__c] [datetime] NULL,
	[GuideStar_Sync_Error__c] [nvarchar](255) NULL,
	[GuideStar_URL__c] [nvarchar](255) NULL,
	[HeartIcon__c] [nvarchar](1300) NULL,
	[Households_Under_this_LDE__c] [float] NULL,
	[Id] [nvarchar](18) NULL,
	[Image__c] [nvarchar](max) NULL,
	[Industry] [nvarchar](4000) NULL,
	[Interest_Cause_Areas__c] [nvarchar](max) NULL,
	[IntermediaryEstablishedDate__c] [date] NULL,
	[IntermediaryName__c] [nvarchar](255) NULL,
	[IntermediaryTaxID__c] [nvarchar](80) NULL,
	[IRS_Subsection__c] [nvarchar](255) NULL,
	[IsActive__c] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[isFavorite__c] [bit] NULL,
	[IsPartner] [bit] NULL,
	[Jigsaw] [nvarchar](20) NULL,
	[JigsawCompanyId] [nvarchar](20) NULL,
	[LastActivityDate] [date] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[Level__c] [nvarchar](18) NULL,
	[MasterRecordId] [nvarchar](18) NULL,
	[MissionStatement__c] [nvarchar](max) NULL,
	[Most_Recent_IRS_BMF__c] [nvarchar](50) NULL,
	[Most_Recent_IRS_Publication_78__c] [nvarchar](50) NULL,
	[Most_Recent_Verified_Date__c] [date] NULL,
	[Name] [nvarchar](255) NULL,
	[NCES_School_Id__c] [nvarchar](50) NULL,
	[NCES_Search__c] [nvarchar](1300) NULL,
	[NCES_Search_By__c] [nvarchar](4000) NULL,
	[NCES_Sync_Date__c] [datetime] NULL,
	[NCES_Valid_Through__c] [date] NULL,
	[NCES_Verified_Date__c] [date] NULL,
	[NetSuite_Id__c] [nvarchar](20) NULL,
	[NetSuite_Sync_Date__c] [datetime] NULL,
	[NetSuite_Sync_Error__c] [nvarchar](255) NULL,
	[npe01__One2OneContact__c] [nvarchar](18) NULL,
	[npe01__SYSTEM_AccountType__c] [nvarchar](100) NULL,
	[npe01__SYSTEMIsIndividual__c] [bit] NULL,
	[npo02__AverageAmount__c] [float] NULL,
	[npo02__Best_Gift_Year__c] [nvarchar](4) NULL,
	[npo02__Best_Gift_Year_Total__c] [float] NULL,
	[npo02__FirstCloseDate__c] [date] NULL,
	[npo02__Formal_Greeting__c] [nvarchar](255) NULL,
	[npo02__HouseholdPhone__c] [nvarchar](40) NULL,
	[npo02__Informal_Greeting__c] [nvarchar](255) NULL,
	[npo02__LargestAmount__c] [float] NULL,
	[npo02__LastCloseDate__c] [date] NULL,
	[npo02__LastMembershipAmount__c] [float] NULL,
	[npo02__LastMembershipDate__c] [date] NULL,
	[npo02__LastMembershipLevel__c] [nvarchar](255) NULL,
	[npo02__LastMembershipOrigin__c] [nvarchar](255) NULL,
	[npo02__LastOppAmount__c] [float] NULL,
	[npo02__MembershipEndDate__c] [date] NULL,
	[npo02__MembershipJoinDate__c] [date] NULL,
	[npo02__NumberOfClosedOpps__c] [float] NULL,
	[npo02__NumberOfMembershipOpps__c] [float] NULL,
	[npo02__OppAmount2YearsAgo__c] [float] NULL,
	[npo02__OppAmountLastNDays__c] [float] NULL,
	[npo02__OppAmountLastYear__c] [float] NULL,
	[npo02__OppAmountThisYear__c] [float] NULL,
	[npo02__OppsClosed2YearsAgo__c] [float] NULL,
	[npo02__OppsClosedLastNDays__c] [float] NULL,
	[npo02__OppsClosedLastYear__c] [float] NULL,
	[npo02__OppsClosedThisYear__c] [float] NULL,
	[npo02__SmallestAmount__c] [float] NULL,
	[npo02__SYSTEM_CUSTOM_NAMING__c] [nvarchar](max) NULL,
	[npo02__TotalMembershipOppAmount__c] [float] NULL,
	[npo02__TotalOppAmount__c] [float] NULL,
	[npsp__Batch__c] [nvarchar](18) NULL,
	[npsp__Funding_Focus__c] [nvarchar](max) NULL,
	[npsp__Grantmaker__c] [bit] NULL,
	[npsp__Matching_Gift_Administrator_Name__c] [nvarchar](255) NULL,
	[npsp__Matching_Gift_Amount_Max__c] [float] NULL,
	[npsp__Matching_Gift_Amount_Min__c] [float] NULL,
	[npsp__Matching_Gift_Annual_Employee_Max__c] [float] NULL,
	[npsp__Matching_Gift_Comments__c] [nvarchar](max) NULL,
	[npsp__Matching_Gift_Company__c] [bit] NULL,
	[npsp__Matching_Gift_Email__c] [nvarchar](80) NULL,
	[npsp__Matching_Gift_Info_Updated__c] [date] NULL,
	[npsp__Matching_Gift_Percent__c] [float] NULL,
	[npsp__Matching_Gift_Phone__c] [nvarchar](40) NULL,
	[npsp__Matching_Gift_Request_Deadline__c] [nvarchar](255) NULL,
	[npsp__Membership_Span__c] [float] NULL,
	[npsp__Membership_Status__c] [nvarchar](1300) NULL,
	[npsp__Number_of_Household_Members__c] [float] NULL,
	[NS_Internal_Id__c] [nvarchar](255) NULL,
	[NS_Sync_Date__c] [datetime] NULL,
	[NS_Sync_Error__c] [nvarchar](max) NULL,
	[NTEE_Code__c] [nvarchar](255) NULL,
	[NumberOfEmployees] [int] NULL,
	[OrganizationExempt990Type__c] [nvarchar](80) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Ownership] [nvarchar](4000) NULL,
	[ParentId] [nvarchar](18) NULL,
	[Phone] [nvarchar](40) NULL,
	[PhotoUrl] [nvarchar](255) NULL,
	[Previous_Level__c] [nvarchar](18) NULL,
	[Primary_Contact1__c] [nvarchar](1300) NULL,
	[Primary_PCS_Code__c] [nvarchar](255) NULL,
	[Public_Charity_Described_in_Section__c] [nvarchar](255) NULL,
	[PublicSupportTest__c] [nvarchar](255) NULL,
	[Rating] [nvarchar](4000) NULL,
	[Reason_for_Non_Private_Foundation_Status__c] [nvarchar](255) NULL,
	[Recieve_Newsletter__c] [nvarchar](4000) NULL,
	[Recommend_A_Grant__c] [nvarchar](1300) NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[ReportTypeForGifts__c] [nvarchar](80) NULL,
	[Ruling_Date__c] [nvarchar](30) NULL,
	[ShippingCity] [nvarchar](40) NULL,
	[ShippingCountry] [nvarchar](80) NULL,
	[ShippingGeocodeAccuracy] [nvarchar](4000) NULL,
	[ShippingLatitude] [float] NULL,
	[ShippingLongitude] [float] NULL,
	[ShippingPostalCode] [nvarchar](20) NULL,
	[ShippingState] [nvarchar](80) NULL,
	[ShippingStreet] [nvarchar](255) NULL,
	[Sic] [nvarchar](20) NULL,
	[SicDesc] [nvarchar](80) NULL,
	[Site] [nvarchar](80) NULL,
	[Staff_Contact__c] [nvarchar](18) NULL,
	[State_Province__c] [nvarchar](1300) NULL,
	[Sum_of_Unpaid_Pledges__c] [float] NULL,
	[Sync_to_GuideStar__c] [bit] NULL,
	[Sync_to_NetSuite__c] [bit] NULL,
	[SystemModstamp] [datetime] NULL,
	[TaxIDAlternate__c] [nvarchar](80) NULL,
	[TaxIDGroupExempt__c] [nvarchar](255) NULL,
	[TickerSymbol] [nvarchar](20) NULL,
	[Type] [nvarchar](4000) NULL,
	[Unpaid_Pledges__c] [float] NULL,
	[Verified_Most_Recent_Internal_Revenue__c] [nvarchar](50) NULL,
	[VetEntityCurrentIssue__c] [nvarchar](255) NULL,
	[VetEntityEquivalencyDeterminationRequire__c] [nvarchar](255) NULL,
	[VetEntityExpenditureResponsibilityRequir__c] [bit] NULL,
	[VetEntityIntlDueDiligenceType__c] [nvarchar](255) NULL,
	[VetEntityIntlHasMasterGrantAgreement__c] [nvarchar](255) NULL,
	[VetEntityIntlMasterGrantAgreementDate__c] [date] NULL,
	[VetEntityOrgSource__c] [nvarchar](255) NULL,
	[VetEntityOutreachNeeded__c] [nvarchar](255) NULL,
	[VetEntityType__c] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
	[Constituent_Eligible_for_Grants__c] [varchar](100) NULL,
	[Constituent_Type_for_Gifts_Reporting__c] [varchar](100) NULL,
	[FXExecute_Wire_Confirmation__c] [varchar](50) NULL,
	[Hate_Group_SPLC__c] [varchar](50) NULL,
	[India_FCRA_Number__c] [varchar](50) NULL,
	[India_IPAN__c] [varchar](50) NULL,
	[India_SR_Number__c] [varchar](50) NULL,
	[Indian_Org_Type__c] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SF_All_Contacts]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_All_Contacts](
	[AccountId] [nvarchar](18) NULL,
	[Alias__c] [nvarchar](20) NULL,
	[AnonymousForGifts__c] [bit] NULL,
	[AssistantName] [nvarchar](40) NULL,
	[AssistantPhone] [nvarchar](40) NULL,
	[Birthdate] [date] NULL,
	[Business_Mobile__c] [float] NULL,
	[ConstituentID__c] [nvarchar](255) NULL,
	[ConstituentSystemID__c] [nvarchar](255) NULL,
	[Created_From_Paypal__c] [bit] NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Current_Age__c] [float] NULL,
	[Deceased_Date__c] [date] NULL,
	[DeceasedDate__c] [date] NULL,
	[Department] [nvarchar](80) NULL,
	[Description] [nvarchar](max) NULL,
	[Do_Not_Mail__c] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[DoNotShareDirectBusinessPhone__c] [bit] NULL,
	[DoNotShareEmailBusiness__c] [bit] NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[DoNotShareMainBusinessPhone__c] [bit] NULL,
	[DS360oi__Background_Batch_Flag__c] [bit] NULL,
	[DS360oi__DS_update__c] [nvarchar](255) NULL,
	[DS360oi__DS_update_date__c] [datetime] NULL,
	[DS360oi__Middle_Initial_Name__c] [nvarchar](10) NULL,
	[DS360oi__X5_Postal_code__c] [float] NULL,
	[Email] [nvarchar](80) NULL,
	[Email__c] [nvarchar](1300) NULL,
	[EmailBouncedDate] [datetime] NULL,
	[EmailBouncedReason] [nvarchar](255) NULL,
	[Ethnicity__c] [nvarchar](50) NULL,
	[Fax] [nvarchar](40) NULL,
	[Field_of_Interest__c] [nvarchar](max) NULL,
	[FirstName] [nvarchar](40) NULL,
	[Focus_Area__c] [nvarchar](max) NULL,
	[Focus_Area_Other__c] [nvarchar](255) NULL,
	[Force_Sync_to_NetSuite__c] [bit] NULL,
	[Formal_Greeting__c] [nvarchar](1300) NULL,
	[Gender__c] [nvarchar](4000) NULL,
	[Giving_Fund_Preferences__c] [nvarchar](max) NULL,
	[Goals_questions_or_concerns__c] [nvarchar](max) NULL,
	[Grant_Acknowledgement_Email__c] [nvarchar](80) NULL,
	[Grant_Acknowledgement_Mailing_City__c] [nvarchar](50) NULL,
	[Grant_Acknowledgement_Mailing_Country__c] [nvarchar](100) NULL,
	[Grant_Acknowledgement_Mailing_State__c] [nvarchar](50) NULL,
	[Grant_Acknowledgement_Mailing_Street__c] [nvarchar](255) NULL,
	[Grant_Acknowledgement_Zipcode__c] [nvarchar](50) NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[HomePhone] [nvarchar](40) NULL,
	[Id] [nvarchar](18) NULL,
	[IndividualId] [nvarchar](18) NULL,
	[Informal_Greeting__c] [nvarchar](1300) NULL,
	[IsActive__c] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsEmailBounced] [bit] NULL,
	[IsStaff__c] [bit] NULL,
	[Jigsaw] [nvarchar](20) NULL,
	[JigsawContactId] [nvarchar](20) NULL,
	[LastActivityDate] [date] NULL,
	[LastCURequestDate] [datetime] NULL,
	[LastCUUpdateDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastName] [nvarchar](80) NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[LeadSource] [nvarchar](4000) NULL,
	[Maiden_Name__c] [nvarchar](80) NULL,
	[MaidenName__c] [nvarchar](80) NULL,
	[Mailing_Address__c] [nvarchar](1300) NULL,
	[MailingCity] [nvarchar](40) NULL,
	[MailingCountry] [nvarchar](80) NULL,
	[MailingGeocodeAccuracy] [nvarchar](4000) NULL,
	[MailingLatitude] [float] NULL,
	[MailingLongitude] [float] NULL,
	[MailingPostalCode] [nvarchar](20) NULL,
	[MailingState] [nvarchar](80) NULL,
	[MailingStreet] [nvarchar](255) NULL,
	[Marital_Status__c] [nvarchar](4000) NULL,
	[MaritalStatus__c] [nvarchar](4000) NULL,
	[MasterRecordId] [nvarchar](18) NULL,
	[MiddleName] [nvarchar](40) NULL,
	[MobilePhone] [nvarchar](40) NULL,
	[Name] [nvarchar](121) NULL,
	[Name__c] [nvarchar](1300) NULL,
	[NetSuite_Last_Sync_Date_Time__c] [datetime] NULL,
	[Netsuite_Sync_Error__c] [nvarchar](255) NULL,
	[Nickname__c] [nvarchar](255) NULL,
	[Nintex_Name__c] [nvarchar](1300) NULL,
	[npe01__AlternateEmail__c] [nvarchar](80) NULL,
	[npe01__Home_Address__c] [nvarchar](1300) NULL,
	[npe01__HomeEmail__c] [nvarchar](80) NULL,
	[npe01__Organization_Type__c] [nvarchar](1300) NULL,
	[npe01__Other_Address__c] [nvarchar](1300) NULL,
	[npe01__Preferred_Email__c] [nvarchar](4000) NULL,
	[npe01__PreferredPhone__c] [nvarchar](4000) NULL,
	[npe01__Primary_Address_Type__c] [nvarchar](4000) NULL,
	[npe01__Private__c] [bit] NULL,
	[npe01__Secondary_Address_Type__c] [nvarchar](4000) NULL,
	[npe01__Type_of_Account__c] [nvarchar](1300) NULL,
	[npe01__Work_Address__c] [nvarchar](1300) NULL,
	[npe01__WorkEmail__c] [nvarchar](80) NULL,
	[npe01__WorkPhone__c] [nvarchar](40) NULL,
	[npo02__AverageAmount__c] [float] NULL,
	[npo02__Best_Gift_Year__c] [nvarchar](4) NULL,
	[npo02__Best_Gift_Year_Total__c] [float] NULL,
	[npo02__FirstCloseDate__c] [date] NULL,
	[npo02__Formula_HouseholdMailingAddress__c] [nvarchar](1300) NULL,
	[npo02__Formula_HouseholdPhone__c] [nvarchar](1300) NULL,
	[npo02__Household__c] [nvarchar](18) NULL,
	[npo02__Household_Naming_Order__c] [float] NULL,
	[npo02__LargestAmount__c] [float] NULL,
	[npo02__LastCloseDate__c] [date] NULL,
	[npo02__LastCloseDateHH__c] [date] NULL,
	[npo02__LastMembershipAmount__c] [float] NULL,
	[npo02__LastMembershipDate__c] [date] NULL,
	[npo02__LastMembershipLevel__c] [nvarchar](255) NULL,
	[npo02__LastMembershipOrigin__c] [nvarchar](255) NULL,
	[npo02__LastOppAmount__c] [float] NULL,
	[npo02__MembershipEndDate__c] [date] NULL,
	[npo02__MembershipJoinDate__c] [date] NULL,
	[npo02__Naming_Exclusions__c] [nvarchar](max) NULL,
	[npo02__NumberOfClosedOpps__c] [float] NULL,
	[npo02__NumberOfMembershipOpps__c] [float] NULL,
	[npo02__OppAmount2YearsAgo__c] [float] NULL,
	[npo02__OppAmountLastNDays__c] [float] NULL,
	[npo02__OppAmountLastYear__c] [float] NULL,
	[npo02__OppAmountLastYearHH__c] [float] NULL,
	[npo02__OppAmountThisYear__c] [float] NULL,
	[npo02__OppAmountThisYearHH__c] [float] NULL,
	[npo02__OppsClosed2YearsAgo__c] [float] NULL,
	[npo02__OppsClosedLastNDays__c] [float] NULL,
	[npo02__OppsClosedLastYear__c] [float] NULL,
	[npo02__OppsClosedThisYear__c] [float] NULL,
	[npo02__SmallestAmount__c] [float] NULL,
	[npo02__Soft_Credit_Last_Year__c] [float] NULL,
	[npo02__Soft_Credit_This_Year__c] [float] NULL,
	[npo02__Soft_Credit_Total__c] [float] NULL,
	[npo02__Soft_Credit_Two_Years_Ago__c] [float] NULL,
	[npo02__Total_Household_Gifts__c] [float] NULL,
	[npo02__TotalMembershipOppAmount__c] [float] NULL,
	[npo02__TotalOppAmount__c] [float] NULL,
	[npsp__Address_Verification_Status__c] [nvarchar](1300) NULL,
	[npsp__Batch__c] [nvarchar](18) NULL,
	[npsp__Current_Address__c] [nvarchar](18) NULL,
	[npsp__Deceased__c] [bit] NULL,
	[npsp__Do_Not_Contact__c] [bit] NULL,
	[npsp__Exclude_from_Household_Formal_Greeting__c] [bit] NULL,
	[npsp__Exclude_from_Household_Informal_Greeting__c] [bit] NULL,
	[npsp__Exclude_from_Household_Name__c] [bit] NULL,
	[npsp__First_Soft_Credit_Amount__c] [float] NULL,
	[npsp__First_Soft_Credit_Date__c] [date] NULL,
	[npsp__HHId__c] [nvarchar](1300) NULL,
	[npsp__is_Address_Override__c] [bit] NULL,
	[npsp__Largest_Soft_Credit_Amount__c] [float] NULL,
	[npsp__Largest_Soft_Credit_Date__c] [date] NULL,
	[npsp__Last_Soft_Credit_Amount__c] [float] NULL,
	[npsp__Last_Soft_Credit_Date__c] [date] NULL,
	[npsp__Number_of_Soft_Credits__c] [float] NULL,
	[npsp__Number_of_Soft_Credits_Last_N_Days__c] [float] NULL,
	[npsp__Number_of_Soft_Credits_Last_Year__c] [float] NULL,
	[npsp__Number_of_Soft_Credits_This_Year__c] [float] NULL,
	[npsp__Number_of_Soft_Credits_Two_Years_Ago__c] [float] NULL,
	[npsp__Primary_Affiliation__c] [nvarchar](18) NULL,
	[npsp__Primary_Contact__c] [bit] NULL,
	[npsp__Soft_Credit_Last_N_Days__c] [float] NULL,
	[NS_Internal_Id__c] [nvarchar](50) NULL,
	[NS_Sync_Date__c] [datetime] NULL,
	[NS_Sync_Error__c] [nvarchar](max) NULL,
	[NSID__c] [nvarchar](64) NULL,
	[Opportunities_Not_Acknowledged__c] [float] NULL,
	[OtherCity] [nvarchar](40) NULL,
	[OtherCountry] [nvarchar](80) NULL,
	[OtherGeocodeAccuracy] [nvarchar](4000) NULL,
	[OtherLatitude] [float] NULL,
	[OtherLongitude] [float] NULL,
	[OtherPhone] [nvarchar](40) NULL,
	[OtherPostalCode] [nvarchar](20) NULL,
	[OtherState] [nvarchar](80) NULL,
	[OtherStreet] [nvarchar](255) NULL,
	[Outstanding_Pledges__c] [float] NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Phone] [nvarchar](40) NULL,
	[Photo__c] [nvarchar](max) NULL,
	[PhotoUrl] [nvarchar](255) NULL,
	[pi__campaign__c] [nvarchar](255) NULL,
	[pi__comments__c] [nvarchar](max) NULL,
	[pi__conversion_date__c] [datetime] NULL,
	[pi__conversion_object_name__c] [nvarchar](255) NULL,
	[pi__conversion_object_type__c] [nvarchar](255) NULL,
	[pi__created_date__c] [datetime] NULL,
	[pi__first_activity__c] [datetime] NULL,
	[pi__first_search_term__c] [nvarchar](255) NULL,
	[pi__first_search_type__c] [nvarchar](255) NULL,
	[pi__first_touch_url__c] [nvarchar](max) NULL,
	[pi__grade__c] [nvarchar](10) NULL,
	[pi__last_activity__c] [datetime] NULL,
	[pi__Needs_Score_Synced__c] [bit] NULL,
	[pi__notes__c] [nvarchar](max) NULL,
	[pi__pardot_hard_bounced__c] [bit] NULL,
	[pi__Pardot_Last_Scored_At__c] [datetime] NULL,
	[pi__score__c] [float] NULL,
	[pi__url__c] [nvarchar](255) NULL,
	[pi__utm_campaign__c] [nvarchar](255) NULL,
	[pi__utm_content__c] [nvarchar](255) NULL,
	[pi__utm_medium__c] [nvarchar](255) NULL,
	[pi__utm_source__c] [nvarchar](255) NULL,
	[pi__utm_term__c] [nvarchar](255) NULL,
	[Portal_Access_Request__c] [bit] NULL,
	[Professional_Advisor_Type__c] [nvarchar](255) NULL,
	[ProfessionalAdvisorRating__c] [nvarchar](255) NULL,
	[Receive_Newsletter__c] [nvarchar](4000) NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[ReportsToId] [nvarchar](18) NULL,
	[ReportTypeForGifts__c] [nvarchar](255) NULL,
	[Salutation] [nvarchar](4000) NULL,
	[Social_Security_Number__c] [nvarchar](9) NULL,
	[SpouseConstituentSystemID__c] [nvarchar](80) NULL,
	[Suffix] [nvarchar](40) NULL,
	[Sync_to_Netsuite__c] [bit] NULL,
	[SystemModstamp] [datetime] NULL,
	[Title] [nvarchar](128) NULL,
	[Website__c] [nvarchar](255) NULL,
	[WebsiteBusiness__c] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_Opportunity]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE view [dbo].[vw_Opportunity] as

select GiftSystemID								GiftSystemID__c					
	, GiftID									Gift_ID__c
	--, case when AccountConstituentSystemID =-1 then null
	--	else AccountConstituentSystemID	end		AccountId	
	, coalesce(acc.id,con.AccountId) as			AccountId
	--, ContactConstituentSystemID				npsp__Primary_Contact__c
	, con.Id as									npsp__Primary_Contact__c
	,case when GiftType in ('Cash')				then 'Liquid_Gift'
		when GiftType in ('Gift-in-Kind')		then 'InKindGift'
		when GiftType in ('Interfund Transfer') then 'Interfund_Gift'
		when GiftType in ('Other')				then 'Other'
		when GiftType in ('Pledge')				then 'Committed_Pledge'
		when GiftType in ('Stock/Property')		then 'Stock_Crypto_Gift'
		else GiftType end						RecordTypeId				
	, GiftSubType								GiftSubType__c
	, case when GiftPostStatus='Posted'			then 'Gift Posted'
		else 'Gift Closed - Not Posted' end		StageName
	, GiftAmount								Amount
	, GiftDate									CloseDate
	, GiftPostDate								GiftPostDate__c
	, GiftPostStatus							GiftPostStatus__c
	, GiftReference								GiftReference__c
	, BatchNumber								npsp__Batch_Number__c
	, AcknowledgementLetterCode					Acknowledgment_Letter_Code__c
	, AcknowledgementStatus						npsp__Acknowledgment_Status__c
	, case when isdate(Substring(AcknowledgementDateFuzzy, 1,4) + '-' +
					  Substring(AcknowledgementDateFuzzy, 5,2) + '-' +
					  Substring(AcknowledgementDateFuzzy, 7,2) ) = 0 then null 
	  else Substring(AcknowledgementDateFuzzy, 1,4) + '-' +
			Substring(AcknowledgementDateFuzzy, 5,2) + '-' +
			Substring(AcknowledgementDateFuzzy, 7,2)	end
												npsp__Acknowledgment_Date__c
	, LetterSigner								LetterSigner__c
	, AcknowledgeAsCombined						Acknowledge_as_Combined__c
	, IsAnonymous								Anonymous__c
	, IsEstablishingGiftToFund					Establishing_Gift_to_Fund__c
	, IsFirstGiftFromNewDonor					IsFirstGiftFromNewDonor__c
	, PaymentIssuer								Payment_Issuer__c
	, IsGrant									Is_Grant__c
	, PaymentMethod								Payment_Method__c
	, PaymentNumber								Payment_Number__c
	, Substring(PaymentDate, 1,4) + '-' +
	  Substring(PaymentDate, 5,2) + '-' +
	  Substring(PaymentDate, 7,2)	
												Payment_Date__c
	, AssetName									Asset_Name__c
	, AssetSymbol								Asset_Symbol__c
	, replace(AssetNumberOfUnits,'units','')	Number_of_Units__c
	, AssetHighValue							High_Value__c
	, AssetLowValue								Low_Value__c
	, AssetMeanValue							Mean_Value__c
	, Brokerage									Brokerage_Firm__c
	, EightyTwoEightyTwoRequired				X8282_Required__c
	, EightyTwoEightyTwoFilingComplete			X8282_Filing_Completed__c
	, StockPropertyDetail						Asset_Type__c
	, ISNULL(StockPropertyWasSold,0)						StockPropertyWasSold__c
	, FairMarketValue							npsp__Fair_Market_Value__c
	, FairMarketValueDetail						Fair_Market_Value_Detail__c
	, cast('Opportunity' as nvarchar(255))		[Name]

	-- Olena changes [290622]: Practitest #563 - New field
	,case when [GiftDetail] = 'Grant Award with Payment' then 'Grant Award Payment' else [GiftDetail] end as Gift_Detail__c

from PlativeDB.dbo.GiftToLoad g
left join PlativeDB.dbo.SF_All_Accounts acc on g.AccountConstituentSystemID = acc.ConstituentSystemID__c
left join PlativeDB.dbo.SF_All_Contacts con on g.ContactConstituentSystemID = con.ConstituentSystemID__c

	-- Begin Test
	--where GiftSystemID in (1,14,32,38419,78594,191555)
	-- End Test
	--where acc.id is null and con.AccountId is null
GO
/****** Object:  View [dbo].[vw_Payment]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE view [dbo].[vw_Payment]
as
select GiftSystemID		PaymentSystemID__c
	, GiftSystemID		npe01__Opportunity__c
	, SaleAmount		SaleAmount__c
	, SaleAmount		npe01__Payment_Amount__c
	, SaleFeeAmount		SaleFee__c
	, SaleDate			SaleDate__c
	, SalePostDate		SalePostDate__c
	, SalePostStatus	SalePostStatus__c
	, SaleReference		SaleReference__c
	, 'True'			npe01__Paid__c
from PlativeDB.dbo.GiftToLoad
where StockPropertyWasSold = 1
	-- Begin Test
	--and GiftSystemID in (1,14,32,38419,78594,191555)
	-- End Test
GO
/****** Object:  Table [dbo].[Succ_Grants]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Grants](
	[Grant_ID__c] [int] NULL,
	[Grant_Number__c] [nvarchar](255) NULL,
	[Historic_Grant_Type__c] [nvarchar](4) NULL,
	[Historic_Full_Grant_Type__c] [nvarchar](308) NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[Status__c] [nvarchar](50) NULL,
	[Historic_Created_Date__c] [datetime] NULL,
	[Date_Submitted__c] [datetime] NULL,
	[Approved_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [varchar](255) NULL,
	[Special_Instructions__c] [varchar](255) NULL,
	[Number_of_Payments__c] [int] NULL,
	[Amount__c] [numeric](20, 2) NULL,
	[Adjusted_Amount__c] [numeric](20, 2) NULL,
	[Grant_Anonymous__c] [varchar](5) NULL,
	[FundInd__c] [varchar](8) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Recipient__c] [nvarchar](18) NULL,
	[Recipient_Contact__c] [nvarchar](18) NULL,
	[Recipient_Salutation__c] [nvarchar](255) NULL,
	[Recipient_Mailing_Address_Historic__c] [nvarchar](255) NULL,
	[Recipient_Valid_Through_Date__c] [datetime] NULL,
	[Payee_Org_ID__c] [int] NULL,
	[Payee_Organization__c] [nvarchar](18) NULL,
	[Payee_Contact__c] [nvarchar](18) NULL,
	[Payee_Salutation__c] [nvarchar](255) NULL,
	[Payee_Address__c] [nvarchar](1025) NULL,
	[Program_Manager__c] [nvarchar](18) NULL,
	[Anonymous_Fund__c] [varchar](5) NULL,
	[Recipient_Fund__c] [nvarchar](18) NULL,
	[Grant_Contact_Method__c] [nvarchar](50) NULL,
	[Anonymous_Fund_Advisor__c] [varchar](5) NULL,
	[Anticipated_Outcomes__c] [nvarchar](255) NULL,
	[CC1_Name__c] [nvarchar](255) NULL,
	[CC1_Email__c] [nvarchar](255) NULL,
	[CC2_Name__c] [nvarchar](255) NULL,
	[CC2_Email__c] [nvarchar](255) NULL,
	[Grant_Period_Start_Date__c] [date] NULL,
	[Grant_Period_End_Date__c] [date] NULL,
	[Grant_Recommendation_Agreement__c] [varchar](5) NULL,
	[Grant_Agreement_Received_Date__c] [date] NULL,
	[CC3_Email__c] [nvarchar](255) NULL,
	[CC4_Name__c] [nvarchar](255) NULL,
	[CC4_Email__c] [nvarchar](255) NULL,
	[Service_Area__c] [nvarchar](255) NULL,
	[Grant_Strategy__c] [nvarchar](255) NULL,
	[Conditions__c] [nvarchar](255) NULL,
	[Special_Accounting_Instruction__c] [nvarchar](255) NULL,
	[Conditional_Grant__c] [varchar](5) NULL,
	[CAFProposalFocusArea__c] [nvarchar](255) NULL,
	[Decline_Comments__c] [nvarchar](255) NULL,
	[Department__c] [nvarchar](255) NULL,
	[Due_Diligence_Type__c] [nvarchar](255) NULL,
	[CAFProposalGeoArea__c] [nvarchar](255) NULL,
	[Historic_T_code__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team_Employee__c] [nvarchar](255) NULL,
	[CiscoCyberGrantsProposalID__c] [nvarchar](255) NULL,
	[Historic_CAF_Focus_Area__c] [nvarchar](255) NULL,
	[Historic_CAF_Geographic_Area__c] [nvarchar](255) NULL,
	[Standard_Grant__c] [varchar](5) NULL,
	[Expedited__c] [varchar](5) NULL,
	[PayPalGrantType__c] [nvarchar](255) NULL,
	[BCC1_Name__c] [nvarchar](255) NULL,
	[BCC1_Email__c] [nvarchar](255) NULL,
	[BCC2_Name__c] [nvarchar](255) NULL,
	[BCC2_Email__c] [nvarchar](255) NULL,
	[GlobalCharityDatabase__c] [varchar](5) NULL,
	[Recoverable_Grant__c] [varchar](5) NULL,
	[Expected_Recoverable_Return_Date__c] [date] NULL,
	[Historic_RecognitionName__c] [varchar](255) NULL,
	[Historic_Ack_Constituent__c] [nvarchar](255) NULL,
	[Historic_Ack_CC_Name__c] [nvarchar](1023) NULL,
	[Lobbying_Reporting__c] [nvarchar](255) NULL,
	[Grassroot_Amount__c] [nvarchar](255) NULL,
	[Direct_Amount__c] [nvarchar](255) NULL,
	[Adj_Grassroot_Amount__c] [nvarchar](255) NULL,
	[Adj_Direct_Amount__c] [nvarchar](255) NULL,
	[Recurring_Grant__c] [nvarchar](18) NULL,
	[Historic_Parent_Grant_Request__c] [int] NULL,
	[Historic_Parent_Proposal__c] [nvarchar](18) NULL,
	[Historic_Parent_Scholarship__c] [int] NULL,
	[Historic_Schol_Year_Attending__c] [nvarchar](4) NULL,
	[Historic_Schol_Student_ID__c] [nvarchar](255) NULL,
	[Historic_Schol_First_Name__c] [varchar](50) NULL,
	[Historic_Schol_Last_Name__c] [varchar](100) NULL,
	[Historic_Schol_Salutation__c] [nvarchar](255) NULL,
	[Historic_Schol_Academic_Year__c] [nvarchar](9) NULL,
	[Historic_Schol_Enrollment_Status__c] [nvarchar](255) NULL,
	[Historic_Schol_Student_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_School_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_Disbursement__c] [nvarchar](255) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SF_Case]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[SF_Case] as 
select 
	GC.CharcteristicID as CharacteristicId__C,
	GR.SalesforceRecordId as Grant__c,
	GC.Name as CharacteristicsName__c,
	GC.CodeValue as Subject,
	GC.Notes as Description
from [Grants].[api].[Grant_Characteristics] GC
Left Join Succ_Grants GR ON GR.Grant_ID__c = GC.GrantID
where GC.Name NOT IN ('Appeal Code', -- Sandesh: 0629: Added as per Email from Max
'CAF Funding Round',
'DCFA Location/Timing of Project',
'Donor Anonymous',
'Expenditure Responsibility',
'Fund Anonymous',
'Gender',
'Grant Check On Hold',
'NTEE Codes',
'Organization 501c3 Status',
'Release Payment Pending',
'Service Area',
'Strategy')

GO
/****** Object:  Table [dbo].[Succ_User2]    Script Date: 6/30/2022 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_User2](
	[FirstName] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[Email] [varchar](1000) NULL,
	[TimeZoneSidKey] [varchar](19) NULL,
	[LocaleSidKey] [varchar](5) NULL,
	[LanguageLocaleKey] [varchar](5) NULL,
	[EmailEncodingKey] [varchar](5) NULL,
	[UserName] [varchar](255) NULL,
	[Alias] [varchar](50) NULL,
	[ProfileId] [varchar](18) NULL,
	[IsActive] [int] NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Success_Fund]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Success_Fund](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[FundSystemID__c] [int] NULL,
	[Fund_ID__c] [varchar](20) NULL,
	[Fund_Category__c] [varchar](100) NULL,
	[Fund_Type__c] [varchar](100) NULL,
	[Fund_Family__c] [varchar](100) NULL,
	[Annotation__c] [nvarchar](max) NULL,
	[DisplayAnnotation__c] [bit] NULL,
	[Active__c] [bit] NULL,
	[Fund_Opened_Date__c] [datetime] NULL,
	[EndDate__c] [datetime] NULL,
	[Philanthropy_Lead_Contact__c] [nvarchar](18) NULL,
	[Philanthropy_Support_Contact__c] [nvarchar](18) NULL,
	[FundAnonymousForGrants__c] [bit] NULL,
	[AdvisorsAnonymousForGrants__c] [bit] NULL,
	[CustomGrantAgreement__c] [varchar](100) NULL,
	[CustomGrantAwardLetter__c] [varchar](100) NULL,
	[CustomGrantAwardLetterLanguage__c] [nvarchar](max) NULL,
	[NoteGrantProcessing__c] [nvarchar](max) NULL,
	[SuppressGiftAmountsForNonStaff__c] [bit] NULL,
	[NoteGiftProcessing__c] [nvarchar](max) NULL,
	[NoteGiftLetterProcessing__c] [nvarchar](max) NULL,
	[FundStatementType__c] [varchar](100) NULL,
	[FundStatementHeldAfterDate__c] [datetime] NULL,
	[IsSpecialHandling__c] [bit] NULL,
	[IMF_Fund__c] [bit] NULL,
	[IsBlackLabel__c] [bit] NULL,
	[BlackLabelSuite__c] [varchar](100) NULL,
	[SupportTier__c] [varchar](29) NULL,
	[FundSalesPlan__c] [varchar](100) NULL,
	[WillNotGiveTo__c] [nvarchar](max) NULL,
	[Account__c] [varchar](20) NULL,
	[Fund_Name__c] [varchar](100) NULL,
	[Focus_Area__c] [nvarchar](max) NULL,
	[Tax_ID__c] [varchar](255) NULL,
	[Principal_Restriction__c] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[SF_Activity]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE view [dbo].[SF_Activity] as
select 
	Ac.[Action Date] as ActivityDate,
	U.SalesforceRecordId as CreatedbyId,
	---U.SalesforceRecordId as OwnerId,
	Ac.[Action Campaign Description] as Campaign_Description__c,
	Ac.CATEGORY as Type,
	Ac.[Action Completed On] as CompletedDateTime,
	Ac.[Action Status] as Status,
	Ac.[Action Date Added] as CreatedDate,
	Ac.[Action Date Last Changed] as LastModifiedDate,
	F.SalesforceRecordId as Fund__c,
	---Pr.SalesforceRecordId as Proposal__c,
	Ac.[Action Subject] as Subject,
	Ac.[Action Type] as ActivityType__c,
	Ac.[Action Note Description] as Notes_Description__c,
	Ac.[Action Notes] as Description,
    'Task'as TaskSubType,
	Acc.Id as WhatId,
	Con.Id as WhoId,
	U.SalesforceRecordId as OwnerId
	---(case Ac.[Constituent ID]
       -- When  Null then  F.SalesforceRecordId
		-- else Pr.SalesforceRecordId
		--end) as WhatId
From [SVCF].[api].[Actions] Ac
Left Join Success_Fund F On F.Fund_ID__c = Ac.[Action Fund ID] 
--Left Join Succ_Proposal Pr On Pr. = Ac.[Action Proposal]
Left Join  SF_All_Contacts Con ON Con.ConstituentID__c = Ac.[Constituent ID]
Left Join  SF_All_Accounts Acc ON Acc.ConstituentID__c = Ac.[Constituent ID]
---Left Join [SVCF].[dbo].USERS Us ON Ac.[Action Added By ID] = Us.USER_ID
---Left Join Succ_User U ON U.Email = Us.OUTLOOK_NAME
Left Join Succ_User2 U ON U.Alias = Ac.[Action Added By]
where Ac.[Action Status] in ('Completed' , 'To Do') and Acc.Id is not null and U.SalesforceRecordId is not null 
---and Ac.[Action Added By] != 'Blackbaud Conversions'


---where U.SalesforceRecordId is not null

	
GO
/****** Object:  Table [dbo].[Succ_RecurringGrants]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_RecurringGrants](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[Recommender__c] [nvarchar](18) NULL,
	[Installment_Period__c] [nvarchar](255) NULL,
	[Date_Established__c] [datetime] NULL,
	[End_Date__c] [datetime] NULL,
	[Scheduled_Start_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [nvarchar](max) NULL,
	[Total_Granted_Amount__c] [money] NULL,
	[ExternalID__c] [int] NULL,
	[Fund__c] [nvarchar](18) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grant_Acknowledge]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grant_Acknowledge](
	[GrantId] [int] NULL,
	[FundInd] [varchar](8) NOT NULL,
	[PrimaryFund] [nvarchar](52) NULL,
	[FundName_Anon_NotAnon] [nvarchar](259) NULL,
	[Header_Fund_Anon_NotAnon] [nvarchar](255) NULL,
	[Requestor] [varchar](255) NULL,
	[AcknolwedgementName] [varchar](2227) NULL,
	[FundAnonymous] [varchar](3) NULL,
	[GrantAckSalutation_REFund] [nvarchar](255) NULL,
	[CCName] [nvarchar](1023) NULL,
	[FundAnonymous_Grant] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grant_Grant2Profile]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grant_Grant2Profile](
	[GrantId] [int] NOT NULL,
	[FundAnonymous] [nvarchar](255) NULL,
	[DonorAnonymous] [nvarchar](255) NULL,
	[AnticipatedOutcomes] [nvarchar](255) NULL,
	[CC1CityStateZip] [nvarchar](255) NULL,
	[CC1Name] [nvarchar](255) NULL,
	[CC1email] [nvarchar](255) NULL,
	[CC2Name] [nvarchar](255) NULL,
	[CC2email] [nvarchar](255) NULL,
	[StartDate] [nvarchar](255) NULL,
	[EndDate] [nvarchar](255) NULL,
	[InterimReport1DueDate] [nvarchar](255) NULL,
	[InterimReport1RecdDate] [nvarchar](255) NULL,
	[FinalReportDueDate] [nvarchar](255) NULL,
	[FinalReportRecdDate] [nvarchar](255) NULL,
	[SkollEndDate] [nvarchar](255) NULL,
	[InterimReport2DueDate] [nvarchar](255) NULL,
	[InterimReport2RecdDate] [nvarchar](255) NULL,
	[GrantAgreement] [nvarchar](255) NULL,
	[GrantAgreementrecddate] [nvarchar](255) NULL,
	[CC3Name] [nvarchar](255) NULL,
	[CC3email] [nvarchar](255) NULL,
	[CC4Name] [nvarchar](255) NULL,
	[CC4email] [nvarchar](255) NULL,
	[ServiceArea] [nvarchar](255) NULL,
	[Strategy] [nvarchar](255) NULL,
	[Conditions] [nvarchar](255) NULL,
	[SpecialAccountingInstructions] [nvarchar](255) NULL,
	[Conditionalgrant] [nvarchar](255) NULL,
	[CAFProposalFocusArea] [nvarchar](255) NULL,
	[CAFProposalGeoArea] [nvarchar](255) NULL,
	[DeclineRationale] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[InterimReport3DueDate] [nvarchar](255) NULL,
	[InterimReport3RecdDate] [nvarchar](255) NULL,
	[InterimReport4DueDate] [nvarchar](255) NULL,
	[InterimReport5DueDate] [nvarchar](255) NULL,
	[InterimReport6DueDate] [nvarchar](255) NULL,
	[InterimReport7DueDate] [nvarchar](255) NULL,
	[InterimReport8DueDate] [nvarchar](255) NULL,
	[InterimReport4RecdDate] [nvarchar](255) NULL,
	[InterimReport5RecdDate] [nvarchar](255) NULL,
	[InterimReport6RecdDate] [nvarchar](255) NULL,
	[InterimReport8RecdDate] [nvarchar](255) NULL,
	[DueDiligenceType] [nvarchar](255) NULL,
	[XilinxGeography] [nvarchar](255) NULL,
	[CommunityConnectionComments] [nvarchar](max) NULL,
	[InterimReport1Approved] [nvarchar](255) NULL,
	[InterimReport2Approved] [nvarchar](255) NULL,
	[InterimReport3Approved] [nvarchar](255) NULL,
	[FinalReportApproved] [nvarchar](255) NULL,
	[TCode2] [nvarchar](255) NULL,
	[eBayGIVETeam] [nvarchar](255) NULL,
	[eBayGIVETeamEmployee] [nvarchar](255) NULL,
	[eBayGiveTeamEmployeeInfo] [nvarchar](255) NULL,
	[CiscoCyberGrantsProposalID] [nvarchar](255) NULL,
	[NetAcadGrantType] [nvarchar](255) NULL,
	[NetAcadRegion] [nvarchar](255) NULL,
	[StandardGrant] [nvarchar](255) NULL,
	[ExpeditedGrant] [nvarchar](255) NULL,
	[PayPalGrantType] [nvarchar](255) NULL,
	[BCC1Name] [nvarchar](255) NULL,
	[BCC1email] [nvarchar](255) NULL,
	[BCC2Name] [nvarchar](255) NULL,
	[BCC2email] [nvarchar](255) NULL,
	[GlobalCharityDatabaseWhenRecd] [nvarchar](255) NULL,
	[RecoverableGrant] [nvarchar](255) NULL,
	[ExpectedRecoverableReturnDate] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grant_Parents]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grant_Parents](
	[GrantId] [int] NOT NULL,
	[DesignatedGrantId] [int] NULL,
	[GrantRequestId] [int] NULL,
	[ProposalId] [int] NULL,
	[ScholarshipApplicationId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grant_Scholarship]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grant_Scholarship](
	[GrantId] [int] NULL,
	[YearAttending] [nchar](4) NULL,
	[StudentId] [nvarchar](255) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](100) NULL,
	[Salutation] [nvarchar](255) NULL,
	[AcademicYear] [nvarchar](9) NULL,
	[EnrollmentStatus] [nvarchar](255) NULL,
	[StudentAcceptanceVerification] [nvarchar](255) NULL,
	[CollegeAcceptanceVerification] [nvarchar](255) NULL,
	[ScholarshipDisbursement] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_User]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_User](
	[FirstName] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[Email] [varchar](1000) NULL,
	[TimeZoneSidKey] [varchar](19) NULL,
	[LocaleSidKey] [varchar](5) NULL,
	[LanguageLocaleKey] [varchar](5) NULL,
	[EmailEncodingKey] [varchar](5) NULL,
	[UserName] [varchar](255) NULL,
	[Alias] [varchar](50) NULL,
	[ProfileId] [varchar](18) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Proposal]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Proposal](
	[ProposalSystemID__c] [int] NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[Name] [varchar](255) NULL,
	[Donor_Account__c] [nvarchar](1300) NULL,
	[Donor_Contact__c] [nvarchar](18) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Campaign__c] [nvarchar](18) NULL,
	[Staff_Lead__c] [nvarchar](18) NULL,
	[Staff_Support__c] [nvarchar](18) NULL,
	[Proposal_Purpose__c] [varchar](100) NULL,
	[Stage__c] [varchar](100) NULL,
	[Closed_Reason__c] [varchar](100) NULL,
	[Likelihood__c] [varchar](100) NULL,
	[Date_Rated__c] [datetime] NULL,
	[Anticipated_Gift_Type__c] [varchar](100) NULL,
	[Vehicle__c] [varchar](100) NULL,
	[Amount_Asked__c] [numeric](30, 6) NULL,
	[AskedDate__c] [datetime] NULL,
	[Amount_Expected__c] [numeric](30, 6) NULL,
	[Date_Expected__c] [datetime] NULL,
	[Amount_Received__c] [numeric](30, 6) NULL,
	[ReceivedDate__c] [datetime] NULL,
	[ClientType__c] [varchar](100) NULL,
	[Referral_Types__C] [nvarchar](max) NULL,
	[ContractType__c] [varchar](100) NULL,
	[ContractSigned__c] [varchar](100) NULL,
	[ContractEntity__c] [varchar](100) NULL,
	[ContractEffectiveDate__c] [datetime] NULL,
	[ContractEndDate__c] [datetime] NULL,
	[RenegotiationNewAmount__c] [numeric](19, 4) NULL,
	[RenegotiationPriorAmount__c] [numeric](19, 4) NULL,
	[BillingMethod__c] [nvarchar](max) NULL,
	[TimeTrackingRequired__c] [bit] NULL,
	[TimeTrackingNotes__c] [nvarchar](max) NULL,
	[Region__c] [varchar](100) NULL,
	[SalesLead__c] [varchar](100) NULL,
	[ServiceLead__c] [varchar](100) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grant_Lobbying]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grant_Lobbying](
	[LobbyingReporting] [nvarchar](100) NOT NULL,
	[GrantId] [int] NOT NULL,
	[LobbyingGrassrootsAmount] [int] NULL,
	[LobbyingDirectAmount] [int] NULL,
	[LobbyingAdjustedGrassrootsAmount] [nvarchar](1) NULL,
	[LobbyingAdjustedDirectAmount] [nvarchar](1) NULL,
 CONSTRAINT [PK_Grant_Lobbying] PRIMARY KEY CLUSTERED 
(
	[GrantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SF_RecordType]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_RecordType](
	[BusinessProcessId] [nvarchar](18) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Description] [nvarchar](255) NULL,
	[DeveloperName] [nvarchar](80) NULL,
	[Id] [nvarchar](18) NULL,
	[IsActive] [bit] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[Name] [nvarchar](80) NULL,
	[NamespacePrefix] [nvarchar](15) NULL,
	[SobjectType] [nvarchar](4000) NULL,
	[SystemModstamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SF_Grant]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[SF_Grant] as
select 
	 distinct G.GrantId as Grant_ID__c
	 ,G.GrantNumber as Grant_Number__c
	,G.GrantType as Historic_Grant_Type__c
	,G.FullGrantType as Historic_Full_Grant_Type__c 
	,(case G.GrantType
		when  'DA' then (select distinct id from SF_RecordType where SobjectType='Grants__c' and  DeveloperName= 'Donor_Advised')
	    when 'DISC' then  (select distinct id from SF_RecordType where SobjectType='Grants__c' and  DeveloperName= 'Donor_Driven_Scholarship')
		when 'T' then  (select distinct id from SF_RecordType where SobjectType='Grants__c' and  DeveloperName= 'Interfund_Transfer')
		when'GT' then (select distinct id from SF_RecordType where SobjectType='Grants__c' and  DeveloperName= 'Interfund_Transfer')
		else (select distinct id from SF_RecordType where SobjectType='Grants__c' and  DeveloperName= 'Other')
		end )as RecordTypeID
	
	,G.GrantStatus as Status__c
	,G.EnteredDate as Historic_Created_Date__c
	,G.ReceivedDate as Date_Submitted__c
	,G.GrantDate as Approved_Date__c
	,G.Designation as Grant_Purpose_Comments__c
	,G.SpecialInstructions as Special_Instructions__c
	,G.NumberOfPayments as Number_of_Payments__c
	,G.GrantAmount as Amount__c
	,G.AdjustedGrant as Adjusted_Amount__c
	
	,(case G.Anonymous 
	when   null then 'False'
	when ' ' then 'False'
	when 'Yes' then 'TRue'
	When 'No' then 'False'
	When 'Anonymous' then 'True'
	else 'False'
	end ) as  Grant_Anonymous__c
	,G.FundInd  as FundInd__c
	,(case F.SalesforceRecordID 	
	 when null then Fb.SalesforceRecordId
	else F.SalesforceRecordID
	end) as Fund__c
	
	--, c.ID as Grantor__c
	,A.ID as Recipient__c
	,Ca.Id as Recipient_Contact__c
	,G.RecipientSalutation as Recipient_Salutation__c

	,G.RecipientAddress as Recipient_Mailing_Address_Historic__c

	,G.RecipientGRRDateTo as Recipient_Valid_Through_Date__c
	,G.PayeeId as Payee_Org_ID__c
	,Aa.ID as Payee_Organization__c
	,cb.Id as Payee_Contact__c
	,G.PayeeSalutation as Payee_Salutation__c
	
	,G.PayeeFullAddress as Payee_Address__c
	,U.SalesforceRecordId as Program_Manager__c

	,(case G.FundAnonymous 
	when   null then 'False'
	when ' ' then 'False'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False' 
	end ) as Anonymous_Fund__c
	
	,Fa.SalesforceRecordId as Recipient_Fund__c

	,G.ContactMethod as Grant_Contact_Method__c
	
	
	,(case GP.DonorAnonymous
	when   null then 'false'
	when ' ' then 'false'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False'
	end ) as Anonymous_Fund_Advisor__c
	,GP.AnticipatedOutcomes as Anticipated_Outcomes__c
	,GP.CC1Name as CC1_Name__c
	,GP.CC1email as CC1_Email__c
	,GP.CC2Name as CC2_Name__c
	,GP.CC2email as CC2_Email__c
	
	,(case 
	when Isdate(GP.StartDate ) = 0  then null 
	when Isdate(GP.StartDate ) = 1  then (convert(Date,GP.StartDate ))
	
	end ) as Grant_Period_Start_Date__c
	,(case 
	when Isdate(GP.EndDate ) = 0  then null 
	when Isdate(GP.EndDate ) = 1  then (convert(Date,GP.EndDate ))
	
	end ) as Grant_Period_End_Date__c
	
	
	,(case GP.GrantAgreement 
	when   null then 'false'
	when ' ' then 'false'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False'
	end ) as Grant_Recommendation_Agreement__c
	,(case 
	when Isdate(GP.GrantAgreementrecddate ) = 0  then null 
	when Isdate(GP.GrantAgreementrecddate ) = 1  then (convert(Date,GP.GrantAgreementrecddate ))
	
	end ) as Grant_Agreement_Received_Date__c

	
	,GP.CC3email as CC3_Email__c
	,GP.CC4Name as CC4_Name__c
	,GP.CC4email as CC4_Email__c
	,GP.ServiceArea as Service_Area__c
	,GP.Strategy as Grant_Strategy__c
	,GP.Conditions as Conditions__c
	,GP.SpecialAccountingInstructions as Special_Accounting_Instruction__c
	
	,(case GP.Conditionalgrant 
	when   null then 'false'
	when ' ' then 'false'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False' 
	end ) as Conditional_Grant__c
	,GP.CAFProposalFocusArea as CAFProposalFocusArea__c
	--,GP.CAFProposalGeoArea as CAFProposalGeoArea__c(only 8 values like America->West Coast->SF Bay Area General)
	,GP.DeclineRationale as Decline_Comments__c
	,GP.Department as Department__c
	,GP.DueDiligenceType as Due_Diligence_Type__c
	,GP.XilinxGeography as CAFProposalGeoArea__c
	--2717
	,GP.TCode2 as Historic_T_code__c
	,GP.eBayGIVETeam as eBay_GIVE_Team__c
	,GP.eBayGIVETeamEmployee as eBay_GIVE_Team_Employee__c
	,GP.CiscoCyberGrantsProposalID as CiscoCyberGrantsProposalID__c
	,GP.NetAcadGrantType as Historic_CAF_Focus_Area__c
	,GP.NetAcadRegion as Historic_CAF_Geographic_Area__c
	
	,(case GP.StandardGrant
	when   null then 'False'
	when ' ' then 'False'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False'
	end ) as Standard_Grant__c
	,(case GP.ExpeditedGrant
	when   null then 'false'
	when ' ' then 'false'
	when 'Yes' then 'True'
	when 'No' then 'False'
	else 'false'
	end ) as Expedited__c

	,GP.PayPalGrantType as PayPalGrantType__c
	,GP.BCC1Name as BCC1_Name__c
	,GP.BCC1email as BCC1_Email__c
	,GP.BCC2email as BCC2_Name__c
	,GP.BCC2Name as BCC2_Email__c
	
	,(case GP.GlobalCharityDatabaseWhenRecd 
	when   null then 'false'
	when ' ' then 'false'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False'
	end ) as  GlobalCharityDatabase__c
	,
	(case GP.RecoverableGrant 
	when   null then 'false'
	when ' ' then 'false'
	when 'Yes' then 'True'
	When 'No' then 'False'
	else 'False'
	end ) as Recoverable_Grant__c
	,(case 
	when Isdate(GP.ExpectedRecoverableReturnDate ) = 0  then null 
	when Isdate(GP.ExpectedRecoverableReturnDate ) = 1  then (convert(Date,GP.ExpectedRecoverableReturnDate))
	
	end ) as Expected_Recoverable_Return_Date__c
	
	--,NUll as Historic_RecognitionName__c
	--,Null as Historic_AckNameandAddress__c
	--,NUll as Historic_Ack_Constituent__c
	--,NUll as Historic_Ack_CC_Name__c
	
	
	,Ga.Requestor as Historic_RecognitionName__c
	--,Ga.AcknolwedgementName as Historic_AckNameandAddress__c
	,Ga.GrantAckSalutation_REFund as Historic_Ack_Constituent__c
	,Ga.CCName as Historic_Ack_CC_Name__c


--GrantId
	,GL.LobbyingReporting as Lobbying_Reporting__c
	,GL.LobbyingGrassrootsAmount as Grassroot_Amount__c
	,GL.LobbyingDirectAmount as Direct_Amount__c
	,GL.LobbyingAdjustedGrassrootsAmount as Adj_Grassroot_Amount__c
	,GL.LobbyingAdjustedDirectAmount as Adj_Direct_Amount__c


	--GrantId
	,RG.SalesforceRecordId as Recurring_Grant__c
	,GPE.GrantRequestId as Historic_Parent_Grant_Request__c
    ,P.SalesforceRecordId as Historic_Parent_Proposal__c
	,GPE.ScholarshipApplicationId as Historic_Parent_Scholarship__c
	
	--GrantId
	,GS.YearAttending as Historic_Schol_Year_Attending__c
	,GS.StudentId as Historic_Schol_Student_ID__c
	,GS.FirstName as Historic_Schol_First_Name__c
	,GS.LastName as Historic_Schol_Last_Name__c
	,GS.Salutation as Historic_Schol_Salutation__c
	,GS.AcademicYear as Historic_Schol_Academic_Year__c
	,GS.EnrollmentStatus as Historic_Schol_Enrollment_Status__c
	,GS.StudentAcceptanceVerification as Historic_Schol_Student_Verification__c
	,GS.CollegeAcceptanceVerification as Historic_Schol_School_Verification__c
	,GS.ScholarshipDisbursement as Historic_Schol_Disbursement__c
	 FROM [Grants].[api].[Grant] G
left join [PlativeDB].dbo.Grant_Acknowledge Ga on Ga.GrantID =G.GrantID
left join PlativeDB.dbo.Grant_Lobbying GL on GL.GrantID =G.GrantID
left join PlativeDB.dbo.Grant_Grant2Profile GP on GP.GrantID =G.GrantID
left join PlativeDB.dbo.Grant_Parents GPE on GPE.GrantID =G.GrantID
left join PlativeDB.dbo.Grant_Scholarship GS on GS.GrantID =G.GrantID
left join [PlativeDB].dbo.Success_Fund F on G.PrimaryFund = F.Fund_ID__c
left join  [PlativeDB].dbo.SF_All_Accounts A on  A.ConstituentSystemID__c= G.[REKeyRecipientID]--G.RecipientId
left join  [PlativeDB].dbo.SF_All_Accounts Aa on Aa.ConstituentSystemID__c=G.PayeeId
--left join  [PlativeDB].dbo.SF_All_Contacts C on C.Name=G.Requestor
left join [PlativeDB].dbo.SF_All_Contacts Ca on Ca.ConstituentSystemID__c =G.[REKeyRecipientID]--G.RecipientId
left join  [PlativeDB].dbo.SF_All_Contacts Cb on Cb.ConstituentSystemID__c =G.PayeeId
left join [PlativeDB].dbo.Success_Fund Fa on Fa.Fund_ID__c=G.TargetFundNumber
left join [PlativeDB].dbo.Succ_Proposal P on P.ProposalSystemID__c= GPE.ProposalId
left join [PlativeDB].dbo.Succ_User U on (U.FirstName+' '+' '+U.LastName) = G.ProgramManager
left join [PlativeDB].dbo.Success_Fund Fb on Fb.FundSystemID__c = G.SourceFundId
left join [PlativeDB].dbo.Succ_RecurringGrants RG on RG.ExternalID__c=GPE.DesignatedGrantId
--where Ca.Id  is not  null  and cb.Id is not null
--where G.GrantId='232989'--'155445'
 --group by 1
--order by 1 desc
GO
/****** Object:  Table [dbo].[SF_Bank]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Bank](
	[Account_Name__c] [nvarchar](255) NULL,
	[Account_Number__c] [nvarchar](255) NULL,
	[Chart_of_Account__c] [nvarchar](18) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Id] [nvarchar](18) NULL,
	[Inactive__c] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[Name] [nvarchar](80) NULL,
	[NS_Internal_Id__c] [nvarchar](100) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Subsidiaries__c] [nvarchar](255) NULL,
	[SystemModstamp] [datetime] NULL,
	[Type__c] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SF_GrantBill]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[SF_GrantBill] as
select 
GP.PaymentId as PaymentId__c,
G.SalesforceRecordId as Grant__c
,GP.PaymentNumber as Payment_Number__c
,GP.IssueNumber as Issue_Number__c
,GP.PayDate as Scheduled_Date__c
,GP.CheckDate as Check_Date__c
,GP.VoidDate as Void_Date__c
,GP.PaymentStatus as Status__c
,GP.Amount as Amount__c
,GP.AdjustedAmount as Adjusted_Payment_Amount__c
,GP.CheckNumber as Check_Reference_Number__c
,GP.FEInvoice as HistoricFEInvoiceID__c
,GP.InvoiceNumber as HistoricInvoiceDescription__c
,B.Id as Bank__c
--,GP.BankName as (BANK ID+BANK NAME)
,GP.ExportedFlag as Exported_Flag__c
,GP.LockedFlag as Locked_Flag__c

,GC.CheckRunId as GE_Batch_ID__c
,GC.DateCreated as GE_Batch_Date_Created__c
,GC.EndDate as GE_Batch_Date_Closed__c
,GC.Description as GE_Batch_Description__c
,GC.FriendlyBatchStatus as GE_Batch_Status__c
,GC.InvoicedBy as GE_Batch_Invoiced_By__c
,GC.PrintedBy as GE_Batch_Printed_By__c
,GC.DatePostProcessed as GE_Batch_Post_Date__c
,GC.PostProcessedBy as GE_Batch_Post_By__c
from Grants.api.Grant_Payments GP
left join Grants.api.Grant_CheckRun GC on GC.GrantId= GP.GrantId -- Sandesh: 06212022: Changed to Left Join 
join PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c=GP.GrantId
left join PlativeDB.dbo.SF_Bank B on B.Account_Name__c=GP.BankName
--WHERE GP.PaymentId ='269377'
--order by 1 desc
GO
/****** Object:  View [dbo].[SF_Address]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[SF_Address] as
SELECT 
	SA.Id as npsp__Household_Account__c,
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
---INNER Join [PlativeDB].[dbo].[SF_Account] A ON ad.ConstituentSystemID = A.ConstituentSystemID__c
INNER Join [PlativeDB].[dbo].[SF_All_Accounts] SA ON ad.ConstituentSystemID = SA.ConstituentSystemID__c
---WHERE SA.Account_Id__c is not null
GO
/****** Object:  Table [dbo].[SF_Contact]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Contact](
	[AccountId] [nvarchar](18) NULL,
	[ConstituentID__c] [nvarchar](255) NULL,
	[ConstituentSystemID__c] [nvarchar](255) NULL,
	[Id] [nvarchar](18) NULL,
	[Name] [nvarchar](121) NULL,
	[FirstName] [nvarchar](40) NULL,
	[LastName] [nvarchar](80) NULL,
	[MiddleName] [nvarchar](40) NULL,
	[Email] [nvarchar](80) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SF_Fund]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE   VIEW [dbo].[SF_Fund] AS
SELECT 
	F.FundSystemID as FundSystemID__c,
	F.FundID as Fund_ID__c,
	F.Name as Fund_Name__c,
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
	A.Id as Account__c,
   --con.ConstituentSystemID
   F.[PrincipalRestriction] as Principal_Restriction__c,
   F.[TaxID] as Tax_ID__c
FROM [SVCF].[api].[Fund] F
left join SF_All_Accounts A ON A.[constituentID__c] =  F.[PrimaryOrganizationConstituentSystemID] 
Left Join SF_Contact C ON C.ConstituentSystemID__c = F.PhilanthropyManagerLeadConstituentSystemID
Left Join SF_Contact Con ON Con.ConstituentSystemID__c = F.PhilanthropyManagerSupportConstituentSystemID
--INNER JOIN [SVCF].api.Constituent con ON SUBSTRING (F.PrimaryOrganizationConstituentSystemID, 3,len(F.PrimaryOrganizationConstituentSystemID)) = con.ConstituentSystemID
--WHERE SUBSTRING (F.PrimaryOrganizationConstituentSystemID, ,3) = 'O-';
--where F.[PrimaryOrganizationConstituentSystemID] IS NOT NULL
--f.PrimaryOrganizationConstituentSystemID<>''--F.FundID = '1013'
GO
/****** Object:  View [dbo].[SF_AccountLoad]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[SF_AccountLoad] as 
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
	end ) as GranteeIsValidPayee__c,
		--GranteeIsValidPayee as GranteeIsValidPayee__c
		--IsOrganization

	-- Olena changes [290622]: Practitest #563 - New fields
		[ConstituentEligibleForGrants] as Constituent_Eligible_for_Grants__c,
		case when [ConstituentTypeForGiftsReporting] = 'Nonprofit/Organization' then 'Nonprofit Organization'
			else [ConstituentTypeForGiftsReporting] end as Constituent_Type_for_Gifts_Reporting__c,
		[FiscalSponsor] as Fiscal_Sponsor__c,
		case when [FXecuteWireConfirmation] is null then 'Yes' else 'No' end as FXExecute_Wire_Confirmation__c,
		case when [HateGroup_SPLC] is null then 'Yes' else 'No' end  as Hate_Group_SPLC__c,
		[IndiaSRNumber] as India_SR_Number__c,
		[IndiaFCRANumber] as India_FCRA_Number__c,
		[IndiaIPAN] as India_IPAN__c,
		[IndianOrgType] as Indian_Org_Type__c
		from SVCF.api.Constituent_20210615
--	where IsOrganization = 'true' and ConstituentID= 'O-22514'
where IsOrganization ='True'

GO
/****** Object:  View [dbo].[SF_FundRole]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[SF_FundRole] AS
SELECT 
    FR.[FundRoleSystemID] as ExternalId__c,
	F.SalesforceRecordId as Fund__c,
	C.Id as Contact__c,
	FR.[Role] as Role__c,
	FR.[RelationshipsToFund] as RelationshipsToFund__c,
	FR.[IsFormer] as Active__c,
	--FR.[FromDateFuzzy] as Start_Date__c,
	(case 
		when len(FR.FromDateFuzzy) =8 then (substring(FR.FromDateFuzzy ,1,4)+'-'+substring(FR.FromDateFuzzy ,5,2)+'-'+substring(FR.FromDateFuzzy ,7,2))
		else Null
		end) as  StartDate__c,
   --FR.[ToDateFuzzy] as End_Date__c,
	(case 
		when len(FR.ToDateFuzzy) =8 then (substring(FR.ToDateFuzzy ,1,4)+'-'+substring(FR.ToDateFuzzy ,5,2)+'-'+substring(FR.ToDateFuzzy ,7,2))
		else Null
		end) as  EndDate__c,
	FR.[IsCombined] as IsCombined__c,
	FR.[StatementDeliveryMethod] as StatementDeliveryMethod__c,
	FR.[AcknowledgeInGrantAwardLetter] as Grant_Acknowledgement__c,
	FR.[AcknowledgementNameInGrantAwardLetter] as Grant_Recognition_Name__c,
	FR.[Notes] as Description__c
FROM [SVCF].[api].[FundRole] FR	 
Left JOIN Success_Fund F ON F.FundSystemID__c = FR.FundSystemID
Left Join SF_All_Contacts C ON C.ConstituentSystemID__c = FR.ConstituentSystemID
where F.SalesforceRecordId is not null
GO
/****** Object:  View [dbo].[SF_Household_Account_Update]    Script Date: 6/30/2022 1:44:44 PM ******/
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
/****** Object:  View [dbo].[SF_RecurringGrants]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[SF_RecurringGrants] as
Select 
	DG.[DesignatedId] as ExternalID__c,
	Con.Id as Recommender__c,   
	Case when DG.[Frequency] = 'Monthly' then 'Month'
		 when DG.[Frequency] = 'Quarterly' then 'Quarter' 
		 when DG.[Frequency] = 'Yearly' then 'Year' 
		 else DG.[Frequency]  end as Installment_Period__c,
	DG.[StartDate] as Date_Established__c,
	DG.[EndDate] as End_Date__c,
	DG.[ScheduleDate] as Scheduled_Start_Date__c,
	----DG.[Notes] as Grant_Purpose_Comments__c,
	LEFT(DG.[Notes], 10) as Grant_Purpose_Comments__c,
	DG.[DesignatedValue] as Total_Granted_Amount__c,
	sf.SalesforceRecordId as Fund__c
FROM [Grants].[api].[V_DesignatedGrants] DG
Left Join SF_All_Contacts Con ON Con.ConstituentSystemID__c = DG.RequestorId
left join Success_Fund sf on dg.DesignatedFundId = sf.Fund_ID__c -- Added by Sandesh
GO
/****** Object:  View [dbo].[SF_GrantReportingSchedules]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[SF_GrantReportingSchedules] as
select 
G.SalesforceRecordId as Grant__c
,'Interim Report 1'as Report_Type__c
,(case 
	when Isdate(a.InterimReport1DueDate ) = 0  then null 
	when Isdate(a.InterimReport1DueDate ) = 1  then (convert(Date,a.InterimReport1DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport1RecdDate) = 0  then null 
	when Isdate(a.InterimReport1RecdDate ) = 1  then (convert(Date,a.InterimReport1RecdDate))
	else null
	end ) as Submitted_Date__c
,(case 
	when Isdate(a.InterimReport1Approved ) = 0  then null 
	when Isdate(a.InterimReport1Approved ) = 1  then (convert(Date,a.InterimReport1Approved))
	else null
	end ) as Approved_Date__c


FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport1DueDate]<>'' or [InterimReport1RecdDate]<>'' or a.InterimReport1Approved <>''
    UNION
SELECT    G.SalesforceRecordId as Grant__c
,'Interim Report 2'as Report_Type__c
,(case 
	when Isdate(a.InterimReport2DueDate ) = 0  then null 
	when Isdate(a.InterimReport2DueDate ) = 1  then (convert(Date,a.InterimReport2DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport2RecdDate) = 0  then null 
	when Isdate(a.InterimReport2RecdDate ) = 1  then (convert(Date,a.InterimReport2RecdDate))
	else null
	end ) as Submitted_Date__c
,(case 
	when Isdate(a.InterimReport2Approved ) = 0  then null 
	when Isdate(a.InterimReport2Approved ) = 1  then (convert(Date,a.InterimReport2Approved))
	else null
	end ) as Approved_Date__c

FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport2DueDate]<>'' or [InterimReport2RecdDate]<>'' or a.InterimReport1Approved <>''
    UNION
SELECT  G.SalesforceRecordId  as Grant__c
,'Interim Report 3'as Report_Type__c
,(case 
	when Isdate(a.InterimReport3DueDate ) = 0  then null 
	when Isdate(a.InterimReport3DueDate ) = 1  then (convert(Date,a.InterimReport3DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport3RecdDate) = 0  then null 
	when Isdate(a.InterimReport3RecdDate ) = 1  then (convert(Date,a.InterimReport3RecdDate))
	else null
	end ) as Submitted_Date__c
,(case 
	when Isdate(a.InterimReport3Approved ) = 0  then null 
	when Isdate(a.InterimReport3Approved ) = 1  then (convert(Date,a.InterimReport3Approved))
	else null
	end ) as Approved_Date__c

FROM [Grants].[api].[Grant_Grant2Profile]  a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport1DueDate]<>'' or [InterimReport1RecdDate]<>'' or a.InterimReport1Approved <>''
    UNION
SELECT    G.SalesforceRecordId  as Grant__c
,'Interim Report 4'as Report_Type__c
,(case 
	when Isdate(a.InterimReport4DueDate ) = 0  then null 
	when Isdate(a.InterimReport4DueDate ) = 1  then (convert(Date,a.InterimReport4DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport4RecdDate) = 0  then null 
	when Isdate(a.InterimReport4RecdDate ) = 1  then (convert(Date,a.InterimReport4RecdDate))
	else null
	end ) as Submitted_Date__c
,Null as Approved_Date__c



FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport1DueDate]<>' ' or [InterimReport1RecdDate]<>' ' 
    UNION
SELECT    G.SalesforceRecordId as Grant__c
,'Interim Report 5'as Report_Type__c
,(case 
	when Isdate(a.InterimReport5DueDate ) = 0  then null 
	when Isdate(a.InterimReport5DueDate ) = 1  then (convert(Date,a.InterimReport5DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport5RecdDate) = 0  then null 
	when Isdate(a.InterimReport5RecdDate ) = 1  then (convert(Date,a.InterimReport5RecdDate))
	else null
	end ) as Submitted_Date__c

,Null as Approved_Date__c
FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport1DueDate]<>'' or [InterimReport1RecdDate]<>'' 
    UNION
SELECT    G.SalesforceRecordId as Grant__c
,'Interim Report 6'as Report_Type__c
,(case 
	when Isdate(a.InterimReport6DueDate ) = 0  then null 
	when Isdate(a.InterimReport6DueDate ) = 1  then (convert(Date,a.InterimReport6DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport6RecdDate) = 0  then null 
	when Isdate(a.InterimReport6RecdDate ) = 1  then (convert(Date,a.InterimReport6RecdDate))
	else null
	end ) as Submitted_Date__c

,Null as Approved_Date__c
FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport6DueDate]<>'' or [InterimReport6RecdDate]<>'' 
    UNION
SELECT  G.SalesforceRecordId  as Grant__c
,'Interim Report 7'as Report_Type__c
,(case 
	when Isdate(a.InterimReport7DueDate ) = 0  then null 
	when Isdate(a.InterimReport7DueDate ) = 1  then (convert(Date,a.InterimReport7DueDate))
	else null
	end ) as Due_Date__c
	

,Null as Submitted_Date__c
,Null as Approved_Date__c
FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where [InterimReport1DueDate]<>'' or [InterimReport1RecdDate]<>'' 
    UNION

SELECT    G.SalesforceRecordId as Grant__c
,'Interim report 8'as Report_Type__c
,(case 
	when Isdate(a.InterimReport8DueDate ) = 0  then null 
	when Isdate(a.InterimReport8DueDate ) = 1  then (convert(Date,a.InterimReport8DueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.InterimReport8RecdDate) = 0  then null 
	when Isdate(a.InterimReport8RecdDate ) = 1  then (convert(Date,a.InterimReport8RecdDate))
	else null
	end ) as Submitted_Date__c

,Null as Approved_Date__c
FROM [Grants].[api].[Grant_Grant2Profile] a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId

where [InterimReport1DueDate]<>'' or [InterimReport1RecdDate]<>'' 
    UNION



SELECT    G.SalesforceRecordId as Grant__c
,'Final Report'as Report_Type__c
,(case 
	when Isdate(a.FinalReportDueDate ) = 0  then null 
	when Isdate(a.FinalReportDueDate) = 1  then (convert(Date,a.FinalReportDueDate))
	else null
	end ) as Due_Date__c
	,(case 
	when Isdate(a.FinalReportRecdDate) = 0  then null 
	when Isdate(a.FinalReportRecdDate ) = 1  then (convert(Date,a.FinalReportRecdDate))
	else null
	end ) as Submitted_Date__c
,(case 
	when Isdate(a.FinalReportApproved ) = 0  then null 
	when Isdate(a.FinalReportApproved ) = 1  then (convert(Date,a.FinalReportApproved))
	else null
	end ) as Approved_Date__c



from Grants.api.Grant_Grant2Profile a
left join  PlativeDB.dbo.Succ_Grants G on G.Grant_ID__c = a.GrantId
where a.FinalReportApproved<>'' or a.FinalReportDueDate<>'' or a.FinalReportRecdDate <>''




GO
/****** Object:  View [dbo].[SF_Affiliation]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE   VIEW [dbo].[SF_Affiliation] as 
SELECT
	AF.AffiliationSystemID as ExternalID__c,
	Con.Id as npe5__Contact__c,	
	Acc.Id as npe5__Organization__c,
	Acc.Name as AccountName,
	AF.ContactRelationshipToOrganization as ContactRelationshipToOrganization__c,
	AF.OrganizationRelationshipToContact as OrganizationRelationshipToContact__c,
	--AF.FromDateFuzzy as npe5__StartDate__c,
	(case 
		when len(AF.FromDateFuzzy) =8 then (substring(AF.FromDateFuzzy ,1,4)+'-'+substring(AF.FromDateFuzzy ,5,2)+'-'+substring(AF.FromDateFuzzy ,7,2))
		else Null
		end) as npe5__StartDate__c,
   -- AF.ToDateFuzzy	as npe5__EndDate__c,
	(case 
		when len(AF.ToDateFuzzy) =8 then (substring(AF.ToDateFuzzy ,1,4)+'-'+substring(AF.ToDateFuzzy ,5,2)+'-'+substring(AF.ToDateFuzzy ,7,2))
		else Null
		end) as npe5__EndDate__c,
	---CONVERT(Date, 'AF.ToDateFuzzy')as  npe5__EndDate__c,
	AF.IsPrimaryBusiness as npe5__Primary__c,
	AF.Position as npe5__Role__c,	
	AF.Notes as npe5__Description__c
	,Con_Source.ConstituentSystemID
	,Con_Source.FirstName
	,Con_Source.LastName
	,Acc_Source.OrganizationName
FROM [SVCF].[api].[Affiliation] AF
Left Join SF_All_Contacts Con ON Con.ConstituentSystemID__c = AF.ContactConstituentSystemID
Left Join SF_All_Accounts Acc ON Acc.ConstituentSystemID__c = AF.OrganizationConstituentSystemID
Left Join [SVCF].[api].Constituent_20210615 Con_Source ON AF.ContactConstituentSystemID = Con_Source.ConstituentSystemID
Left Join [SVCF].[api].Constituent_20210615 Acc_Source ON AF.OrganizationConstituentSystemID = Acc_Source.ConstituentSystemID
--WHERE AF.ToDateFuzzy IS NOT NULL
--where Con.Id is null
--and Con_Source.ConstituentSystemID is not null
GO
/****** Object:  Table [dbo].[Succ_Campaign]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Campaign](
	[Name] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ExpectedRevenue] [numeric](30, 6) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SF_Proposal]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view  [dbo].[SF_Proposal] as
select 
		a.[ProposalSystemID] as ProposalSystemID__c
		,(select distinct Id from SF_RecordType where SobjectType='Proposal__c' and DeveloperName ='Historic_Proposals') as RecordTypeId
		,a.[Name] as Name
		,Acc.Id as Donor_Account__c	
		,cont.Id as Donor_Contact__c
		,F.SalesforceRecordId as Fund__c
		,cs.SalesforceRecordId as Campaign__c
		,C.Id as Staff_Lead__c
		,C.Id as Staff_Support__c
		,a.[Purpose] as Proposal_Purpose__c
		,a.[Stage] as Stage__c
		,a.[ClosedReason] as Closed_Reason__c
		,a.[Rating] as Likelihood__c
		,a.[RatingDate] as Date_Rated__c
		,a.[GiftType] as Anticipated_Gift_Type__c
		,a.[PlannedGivingVehicle] as Vehicle__c
		,a.[AskedAmount] as Amount_Asked__c
		,a.[AskedDate] as AskedDate__c
		,a.[ExpectedAmount] as Amount_Expected__c
		,a.[ExpectedDate] as Date_Expected__c
		,a.[ReceivedAmount] as Amount_Received__c
		,a.[ReceivedDate] as ReceivedDate__c
		,a.[ClientType] as ClientType__c
		,(PlativeDB.dbo.fn_Fix_Invalid_XML_Chars(a.[ReferralSources])) as Referral_Types__C
		,a.[ContractType] as ContractType__c
		,a.[ContractSigned] as ContractSigned__c
		,a.[ContractEntity] as ContractEntity__c
		,a.[ContractEffectiveDate] as ContractEffectiveDate__c
		,a.[ContractEndDate] as ContractEndDate__c
		,a.[RenegotionNewAmount] as RenegotiationNewAmount__c
		,a.[RenegotionPriorAmount] as RenegotiationPriorAmount__c
		,a.[BillingMethods] as BillingMethod__c
		,(case 
		when a.[TimeTrackingRequired] is Null then '0'
		else  a.[TimeTrackingRequired]
		end) as TimeTrackingRequired__c
		,a.[TimeTrackingNotes] as TimeTrackingNotes__c
		,a.[Region] as Region__c
		,a.[SalesLead] as SalesLead__c
		,a.[ServiceLead] as ServiceLead__c
from [SVCF].api.Proposal a
left join SF_All_Contacts C on C.ConstituentSystemID__c=a.StaffLeadConstituentSystemID
left join SF_All_Contacts con on con.ConstituentSystemID__c=a.StaffSupportConstituentSystemID
left join SF_All_Accounts Acc on Acc.ConstituentSystemID__c=a.AccountConstituentSystemID
left join SF_All_Contacts Cont on Cont.ConstituentSystemID__c=a.ContactConstituentSystemID
left join Success_Fund F on F.FundSystemID__c =a.FundSystemID
left join Succ_Campaign cs on ((select ca.CampaignSystemID from[SVCF].api.Campaign Ca where ca.Name= cs.Name)  =a.CampaignSystemID)


GO
/****** Object:  View [dbo].[SF_SecondaryContact]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[SF_SecondaryContact] as 

select 
	Acc.Id as AccountID,
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
	
	when isdate(substring(con.BirthDateFuzzy ,1,4)+'-'+substring(con.BirthDateFuzzy ,5,2)+'-'+substring(con.BirthDateFuzzy ,7,2))=0 then null
	when isdate(substring(con.BirthDateFuzzy ,1,4)+'-'+substring(con.BirthDateFuzzy ,5,2)+'-'+substring(con.BirthDateFuzzy ,7,2))=1 then (convert(date,con.BirthDateFuzzy))
	 end
	) as Birthdate,
	(case
	
	when isdate(substring(con.DeceasedDateFuzzy ,1,4)+'-'+substring(con.DeceasedDateFuzzy ,5,2)+'-'+substring(con.DeceasedDateFuzzy ,7,2))=0 then null
	when isdate(substring(con.DeceasedDateFuzzy ,1,4)+'-'+substring(con.DeceasedDateFuzzy ,5,2)+'-'+substring(con.DeceasedDateFuzzy ,7,2))=1 then (convert(date,con.DeceasedDateFuzzy))
	 end
	) as DeceasedDate__c,
	--con.BirthDateFuzzy as Birthdate,
	con.IsDeceased as npsp__Deceased__c,
	
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
--join [SVCF].api.Household  H on H.HouseholdSystemID = con.ConstituentSystemID
 left join [SVCF].api.Constituent_20210615 s on s.SpouseConstituentSystemID=con.ConstituentSystemID
left join PlativeDB.[dbo].SF_All_Accounts Acc on Acc.ConstituentSystemID__c=s.ConstituentSystemID 
--left join PlativeDB.[dbo].SF_Account Acc on Acc.ConstituentSystemID__c=con.ConstituentSystemID
--where con.ConstituentSystemID not in (select HouseholdSystemID from [SVCF].api.Household ) and 
WHERE con.[ConstituentSystemID]<>con.[HouseholdSystemID]
 and con.IsOrganization ='0' 
 and Acc.Id is not null
GO
/****** Object:  View [dbo].[SF_Relationship]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE      VIEW [dbo].[SF_Relationship] AS
WITH _all_records as (
SELECT 
     (Con.Id+'-'+C.Id)
		 as ExternalID__c,
	Con.Id as npe4__Contact__c,
	C.Id as npe4__RelatedContact__c,
	Rel.[ThisRelationshipToRelated] as npe4__Type__c,
	Rel.[IsFormer] as npe4__Status__c,
	--Rel.[FromDateFuzzy] as Start_Date__c,
	(case 
		when len(Rel.FromDateFuzzy) =8 then (substring(Rel.FromDateFuzzy ,1,4)+'-'+substring(Rel.FromDateFuzzy ,5,2)+'-'+substring(Rel.FromDateFuzzy ,7,2))
		else Null
		end) as  Start_Date__c,
	(case 
		when len(Rel.ToDateFuzzy) =8 then (substring(Rel.ToDateFuzzy ,1,4)+'-'+substring(Rel.ToDateFuzzy ,5,2)+'-'+substring(Rel.ToDateFuzzy ,7,2))
		else Null
		end) as  End_Date__c,
	--Rel.[ToDateFuzzy] as End_Date__c,
	Rel.[Notes] as npe4__Description__c,
	row_number() over(partition by Con.Id, C.Id, Rel.[ThisRelationshipToRelated]
		order by (Con.Id+'-'+C.Id),cast(Rel.[Notes] as nvarchar(max)) desc) as row_num -- to exclude dups that are coming from source
FROM [SVCF].[api].[Relationship] Rel
INNER JOIN SF_All_Contacts Con ON Con.ConstituentSystemID__c = Rel.ThisConstituentSystemID
INNER JOIN SF_All_Contacts C ON C.ConstituentSystemID__c = Rel.RelatedConstituentSystemID
)
SELECT  ExternalID__c,
		npe4__Contact__c,
		npe4__RelatedContact__c,
		npe4__Type__c,
		npe4__Status__c,
		Start_Date__c,
		End_Date__c,
		npe4__Description__c
FROM _all_records
WHERE row_num = 1
GO
/****** Object:  View [dbo].[SF_Campaign]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[SF_Campaign] as
select
 a.[Name] as Name
,a.[IsActive] as IsActive
,a.[StartDate] as StartDate
,a.[EndDate] as EndDate
,a.[FundraisingGoal] as ExpectedRevenue
from svcf.api.Campaign a
GO
/****** Object:  View [dbo].[SF_PrimaryContact]    Script Date: 6/30/2022 1:44:44 PM ******/
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
	/*(case 
		when len(con.BirthDateFuzzy) =8 then (substring(con.BirthDateFuzzy ,1,4)+'-'+substring(con.BirthDateFuzzy ,5,2)+'-'+substring(con.BirthDateFuzzy ,7,2))
		else Null
		end) as BirthDate,*/
	(case
	
	when isdate(substring(con.BirthDateFuzzy ,1,4)+'-'+substring(con.BirthDateFuzzy ,5,2)+'-'+substring(con.BirthDateFuzzy ,7,2))=0 then null
	when isdate(substring(con.BirthDateFuzzy ,1,4)+'-'+substring(con.BirthDateFuzzy ,5,2)+'-'+substring(con.BirthDateFuzzy ,7,2))=1 then (convert(date,con.BirthDateFuzzy))
	 end
	) as Birthdate,
	con.IsDeceased as npsp__Deceased__c,
	(case
	
	when isdate(substring(con.DeceasedDateFuzzy ,1,4)+'-'+substring(con.DeceasedDateFuzzy ,5,2)+'-'+substring(con.DeceasedDateFuzzy ,7,2))=0 then null
	when isdate(substring(con.DeceasedDateFuzzy ,1,4)+'-'+substring(con.DeceasedDateFuzzy ,5,2)+'-'+substring(con.DeceasedDateFuzzy ,7,2))=1 then (convert(date,con.DeceasedDateFuzzy))
	 end
	) as DeceasedDate__c,
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
--join [SVCF].api.Household  H on H.HouseholdSystemID  = con.ConstituentSystemID
where [ConstituentSystemID]=[HouseholdSystemID]and [IsOrganization]=0 --and ConstituentSystemID='123651'
/*and (DoNotShareDirectBusinessPhone = 1
or DoNotShareCellPhone = 1
or DoNotShareEMailBusiness = 1
or DoNotShareEMailPreferred = 1
or DoNotShareHomePhone = 1
or DoNotShareMainBusinessPhone = 1
or AnonymousForGifts = 1)
*/






GO
/****** Object:  View [dbo].[UserLoad]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE      view [dbo].[UserLoad] as
SELECT
	 'America/Los_Angeles' as TimeZoneSidKey ,
	 'en_US' as LocaleSidKey,
	 'en_US' as LanguageLocaleKey, 
      'UTF-8' as EmailEncodingKey,  

 
	  [PlativeDB].dbo.fnParseFMName(DESCRIPTION) as FirstName,
	  [PlativeDB].dbo.fnParseLName(DESCRIPTION) as LastName,
	 '00e8F000000DfZUQA0' AS ProfileId,
	  PlativeDB.dbo.fn_GoodEmailorBlank(([OUTLOOK_NAME]+'.invalid')) as Email,
	 -- CONSTITUENTID as 
    
	   [OUTLOOK_NAME] + '.preprod' as UserName, -- Update when loading to Prod
	  -- ((substring([DESCRIPTION],1,1))+  [PlativeDB].dbo.fnParseLName(DESCRIPTION))as Alias
	  0 as IsActive,

(case	 when len(Name)>8 then  
 trim(substring(Name , 9,len(Name)) from Name)
 else Name
 end
  ) as Alias
 FROM [SVCF].[dbo].[USERS]
 where [DELETED]=0 and [OUTLOOK_NAME] is not null 
 

GO
/****** Object:  View [dbo].[vw_Fulfillment]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[vw_Fulfillment]
as
select 
	--f.PledgeGiftSystemID Opportunity__c
	 f.FulfillingGiftSystemID Opportunity__c
	--,f.FulfillingGiftSystemID Related_Pledge__c
	,f.PledgeGiftSystemID Related_Pledge__c
	,f.FulfillmentAmount Amount__c
	,cast(null as nvarchar(18)) Contact__c	--?
	,cast(f.PledgeGiftSystemID as nvarchar(40)) + '-' + 
	 cast(f.FulfillingGiftSystemID as nvarchar(40)) FulfillmentExternalID__c
	from SVCF.api.PledgeFulfillment f
GO
/****** Object:  View [dbo].[vw_FundAllocation]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[vw_FundAllocation]
as
--select cast(g.GiftSystemID as nvarchar(20)) + '-' + 
--	cast(g.FundSystemID as nvarchar(20)) FundAllocationExternalId__c
--	,g.GiftSystemID 
--	,o.SalesforceRecordId Opportunity__c
--	,g.Amount Amount__c
--	,g.FundSystemID 
--	,f.Id Fund__c
--	,null Allocation_Type__c
--	from api.GiftFundAllocation g
--	left join Log_Opportunity_Success o on o.GiftSystemID__c=g.GiftSystemID
--	left join SF_Fund_Data f on f.[FundSystemID__c]=g.FundSystemID

-- Revising from [api].[GiftFundAllocation] to use GiftSplitId as FundAllocationExternalId__c for unique Id
-- There are lot of duplications using GiftSystemID + FundSystemID
select gs.GiftSplitId FundAllocationExternalId__c
	, gs.GiftId Opportunity__c
	, gs.Amount Amount__c
	, gs.FundId 
	--, fd.[Fund_ID__c] Fund__c
	, fd.Id Fund__c
	--, f.FundID																   --included for validation; null column indicates a problem in api.Fund
	--, f.[Name]	
																   --included for validation; null column indicates a problem in api.Fund
	from SVCF.dbo.GiftSplit as gs
	left outer join svcf.api.FUND as f on gs.FundId = f.FundSystemID
	left join SVCF.dbo.SF_Fund_Data fd on fd.[FundSystemID__c]=gs.FundId
	where gs.GiftId in (														   --Filter for only fund splits on gifts in api.Gift
		select GiftSystemId from SVCF.api.Gift)


GO
/****** Object:  Table [dbo].[_reImport]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_reImport](
	[GiftSystemID__c] [int] NULL,
	[Gift_ID__c] [varchar](50) NULL,
	[AccountId] [int] NULL,
	[npsp__Primary_Contact__c] [int] NULL,
	[RecordTypeId] [varchar](18) NULL,
	[GiftSubType__c] [varchar](100) NULL,
	[StageName] [varchar](24) NULL,
	[Amount] [numeric](20, 4) NULL,
	[GiftPostDate__c] [datetime] NULL,
	[GiftPostStatus__c] [varchar](14) NULL,
	[GiftReference__c] [varchar](255) NULL,
	[npsp__Batch_Number__c] [varchar](50) NULL,
	[Acknowledgment_Letter_Code__c] [varchar](100) NULL,
	[npsp__Acknowledgment_Status__c] [varchar](20) NULL,
	[npsp__Acknowledgment_Date__c] [varchar](10) NULL,
	[LetterSigner__c] [varchar](100) NULL,
	[Acknowledge_as_Combined__c] [bit] NULL,
	[Anonymous__c] [bit] NULL,
	[Establishing_Gift_to_Fund__c] [bit] NULL,
	[IsFirstGiftFromNewDonor__c] [bit] NULL,
	[Payment_Issuer__c] [varchar](100) NULL,
	[Is_Grant__c] [bit] NULL,
	[Payment_Method__c] [varchar](14) NULL,
	[Payment_Number__c] [varchar](20) NULL,
	[Payment_Date__c] [varchar](10) NULL,
	[Asset_Name__c] [varchar](50) NULL,
	[Asset_Symbol__c] [varchar](255) NULL,
	[Number_of_Units__c] [varchar](8000) NULL,
	[High_Value__c] [varchar](8000) NULL,
	[Low_Value__c] [varchar](8000) NULL,
	[Mean_Value__c] [numeric](30, 6) NULL,
	[Brokerage_Firm__c] [varchar](100) NULL,
	[X8282_Required__c] [varchar](100) NULL,
	[X8282_Filing_Completed__c] [varchar](100) NULL,
	[Asset_Type__c] [varchar](100) NULL,
	[StockPropertyWasSold__c] [bit] NULL,
	[npsp__Fair_Market_Value__c] [int] NULL,
	[Fair_Market_Value_Detail__c] [nvarchar](max) NULL,
	[CloseDate] [datetime] NULL,
	[Name] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Account]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Account](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[Name] [varchar](60) NULL,
	[DoingBusinessAs__c] [varchar](100) NULL,
	[MissionStatement__c] [nvarchar](max) NULL,
	[FiscalYearEnd__c] [nvarchar](100) NULL,
	[EIN__c] [varchar](255) NULL,
	[TaxIDAlternate__c] [varchar](255) NULL,
	[TaxIDGroupExempt__c] [varchar](255) NULL,
	[OrganizationExempt990Type__c] [varchar](100) NULL,
	[NTEE_Code__c] [varchar](100) NULL,
	[IsActive__c] [bit] NULL,
	[Email__c] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[Website] [varchar](2047) NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[Abbreviation__c] [varchar](100) NULL,
	[Acronym__c] [varchar](100) NULL,
	[FoundationType__c] [varchar](100) NULL,
	[PublicSupportTest__c] [varchar](100) NULL,
	[IntermediaryName__c] [varchar](255) NULL,
	[IntermediaryTaxID__c] [varchar](50) NULL,
	[IntermediaryEstablishedDate__c] [datetime] NULL,
	[VetEntityType__c] [varchar](100) NULL,
	[VetEntityExpenditureResponsibilityRequir__c] [bit] NULL,
	[VetEntityIntlDueDiligenceType__c] [varchar](100) NULL,
	[VetEntityIntlHasMasterGrantAgreement__c] [bit] NULL,
	[VetEntityIntlMasterGrantAgreementDate__c] [datetime] NULL,
	[GranteeIsRegisteredForAchViaUnionBank__c] [bit] NULL,
	[GranteeRegisteredForAchViaUnionBankDate__c] [datetime] NULL,
	[GranteeValidRecipientStartDate__c] [datetime] NULL,
	[GranteeValidRecipientEndDate__c] [datetime] NULL,
	[GranteeIsValidPayee__c] [bit] NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[Constituent_Eligible_for_Grants__c] [varchar](100) NULL,
	[Constituent_Type_for_Gifts_Reporting__c] [varchar](100) NULL,
	[Fiscal_Sponsor__c] [varchar](50) NULL,
	[FXExecute_Wire_Confirmation__c] [varchar](50) NULL,
	[Hate_Group_SPLC__c] [varchar](50) NULL,
	[India_FCRA_Number__c] [varchar](50) NULL,
	[India_IPAN__c] [varchar](50) NULL,
	[India_SR_Number__c] [varchar](50) NULL,
	[Indian_Org_Type__c] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_AccountUpdate]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_AccountUpdate](
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[ID] [nvarchar](18) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Activity]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Activity](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[ActivityDate] [datetime] NULL,
	[Campaign_Description__c] [varchar](100) NULL,
	[Type] [smallint] NULL,
	[Status] [varchar](100) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Subject] [varchar](255) NULL,
	[Notes_Description__c] [varchar](255) NULL,
	[Description] [varchar](max) NULL,
	[TaskSubType] [varchar](4) NULL,
	[WhatId] [nvarchar](18) NULL,
	[WhoId] [nvarchar](18) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[ActivityType__c] [varchar](100) NULL,
	[CreatedbyId] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Address]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Address](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[npsp__Household_Account__c] [nvarchar](1300) NULL,
	[AddressSystemID__C] [int] NULL,
	[npsp__Address_Type__c] [varchar](100) NULL,
	[npsp__Default_Address__c] [bit] NULL,
	[npsp__MailingCity__c] [varchar](100) NULL,
	[npsp__MailingCountry__c] [varchar](100) NULL,
	[npsp__MailingPostalCode__c] [varchar](12) NULL,
	[npsp__MailingState__c] [varchar](3) NULL,
	[npsp__MailingStreet__c] [varchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Affiliation]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Affiliation](
	[ErrorMessage] [nvarchar](2048) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ExternalID__c] [int] NULL,
	[npe5__Contact__c] [nvarchar](18) NULL,
	[npe5__Organization__c] [nvarchar](1300) NULL,
	[AccountName] [varchar](255) NULL,
	[ContactRelationshipToOrganization__c] [varchar](100) NULL,
	[OrganizationRelationshipToContact__c] [varchar](100) NULL,
	[npe5__StartDate__c] [varchar](10) NULL,
	[npe5__EndDate__c] [varchar](10) NULL,
	[npe5__Primary__c] [bit] NULL,
	[npe5__Role__c] [varchar](50) NULL,
	[npe5__Description__c] [varchar](max) NULL,
	[ConstituentSystemID] [int] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](100) NULL,
	[OrganizationName] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_campaign]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_campaign](
	[Name] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ExpectedRevenue] [numeric](30, 6) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Case]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Case](
	[CharacteristicId__C] [int] NULL,
	[Grant__c] [nvarchar](18) NULL,
	[CharacteristicsName__c] [varchar](255) NULL,
	[Subject] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_FundRole]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_FundRole](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[ExternalId__c] [int] NULL,
	[Fund__c] [varchar](100) NULL,
	[Contact__c] [nvarchar](18) NULL,
	[Role__c] [varchar](100) NULL,
	[RelationshipsToFund__c] [nvarchar](max) NULL,
	[Active__c] [bit] NULL,
	[IsCombined__c] [bit] NULL,
	[StatementDeliveryMethod__c] [varchar](100) NULL,
	[Grant_Acknowledgement__c] [bit] NULL,
	[Grant_Recognition_Name__c] [varchar](255) NULL,
	[Description__c] [varchar](max) NULL,
	[EndDate__c] [varchar](10) NULL,
	[StartDate__c] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_GrantBill]    Script Date: 6/30/2022 1:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_GrantBill](
	[Grant__c] [nvarchar](18) NULL,
	[PaymentId__c] [int] NULL,
	[Payment_Number__c] [int] NULL,
	[Issue_Number__c] [int] NULL,
	[Scheduled_Date__c] [datetime] NULL,
	[Check_Date__c] [datetime] NULL,
	[Void_Date__c] [datetime] NULL,
	[Status__c] [nvarchar](50) NULL,
	[Amount__c] [numeric](20, 2) NULL,
	[Adjusted_Payment_Amount__c] [numeric](20, 2) NULL,
	[Check_Reference_Number__c] [nvarchar](50) NULL,
	[HistoricFEInvoiceID__c] [int] NULL,
	[HistoricInvoiceDescription__c] [nvarchar](50) NULL,
	[Bank__c] [nvarchar](18) NULL,
	[Exported_Flag__c] [int] NULL,
	[Locked_Flag__c] [int] NULL,
	[GE_Batch_ID__c] [int] NULL,
	[GE_Batch_Date_Created__c] [datetime] NULL,
	[GE_Batch_Date_Closed__c] [datetime] NULL,
	[GE_Batch_Description__c] [nvarchar](255) NULL,
	[GE_Batch_Status__c] [nvarchar](9) NULL,
	[GE_Batch_Invoiced_By__c] [nvarchar](255) NULL,
	[GE_Batch_Printed_By__c] [nvarchar](255) NULL,
	[GE_Batch_Post_Date__c] [datetime] NULL,
	[GE_Batch_Post_By__c] [nvarchar](255) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_GrantReporting]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_GrantReporting](
	[Grant__c] [nvarchar](18) NULL,
	[Report_Type__c] [varchar](16) NULL,
	[Due_Date__c] [date] NULL,
	[Submitted_Date__c] [date] NULL,
	[Approved_Date__c] [date] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Grants]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Grants](
	[Grant_ID__c] [int] NULL,
	[Grant_Number__c] [nvarchar](255) NULL,
	[Historic_Grant_Type__c] [nvarchar](4) NULL,
	[Historic_Full_Grant_Type__c] [nvarchar](308) NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[Status__c] [nvarchar](50) NULL,
	[Historic_Created_Date__c] [datetime] NULL,
	[Date_Submitted__c] [datetime] NULL,
	[Approved_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [varchar](255) NULL,
	[Special_Instructions__c] [varchar](255) NULL,
	[Number_of_Payments__c] [int] NULL,
	[Amount__c] [numeric](20, 2) NULL,
	[Adjusted_Amount__c] [numeric](20, 2) NULL,
	[Grant_Anonymous__c] [varchar](5) NULL,
	[FundInd__c] [varchar](8) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Recipient__c] [nvarchar](18) NULL,
	[Recipient_Contact__c] [nvarchar](18) NULL,
	[Recipient_Salutation__c] [nvarchar](255) NULL,
	[Recipient_Mailing_Address_Historic__c] [nvarchar](255) NULL,
	[Recipient_Valid_Through_Date__c] [datetime] NULL,
	[Payee_Org_ID__c] [int] NULL,
	[Payee_Organization__c] [nvarchar](18) NULL,
	[Payee_Contact__c] [nvarchar](18) NULL,
	[Payee_Salutation__c] [nvarchar](255) NULL,
	[Payee_Address__c] [nvarchar](1025) NULL,
	[Program_Manager__c] [nvarchar](18) NULL,
	[Anonymous_Fund__c] [varchar](5) NULL,
	[Recipient_Fund__c] [nvarchar](18) NULL,
	[Grant_Contact_Method__c] [nvarchar](50) NULL,
	[Anonymous_Fund_Advisor__c] [varchar](5) NULL,
	[Anticipated_Outcomes__c] [nvarchar](255) NULL,
	[CC1_Name__c] [nvarchar](255) NULL,
	[CC1_Email__c] [nvarchar](255) NULL,
	[CC2_Name__c] [nvarchar](255) NULL,
	[CC2_Email__c] [nvarchar](255) NULL,
	[Grant_Period_Start_Date__c] [date] NULL,
	[Grant_Period_End_Date__c] [date] NULL,
	[Grant_Recommendation_Agreement__c] [varchar](5) NULL,
	[Grant_Agreement_Received_Date__c] [date] NULL,
	[CC3_Email__c] [nvarchar](255) NULL,
	[CC4_Name__c] [nvarchar](255) NULL,
	[CC4_Email__c] [nvarchar](255) NULL,
	[Service_Area__c] [nvarchar](255) NULL,
	[Grant_Strategy__c] [nvarchar](255) NULL,
	[Conditions__c] [nvarchar](255) NULL,
	[Special_Accounting_Instruction__c] [nvarchar](255) NULL,
	[Conditional_Grant__c] [varchar](5) NULL,
	[CAFProposalFocusArea__c] [nvarchar](255) NULL,
	[Decline_Comments__c] [nvarchar](255) NULL,
	[Department__c] [nvarchar](255) NULL,
	[Due_Diligence_Type__c] [nvarchar](255) NULL,
	[CAFProposalGeoArea__c] [nvarchar](255) NULL,
	[Historic_T_code__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team_Employee__c] [nvarchar](255) NULL,
	[CiscoCyberGrantsProposalID__c] [nvarchar](255) NULL,
	[Historic_CAF_Focus_Area__c] [nvarchar](255) NULL,
	[Historic_CAF_Geographic_Area__c] [nvarchar](255) NULL,
	[Standard_Grant__c] [varchar](5) NULL,
	[Expedited__c] [varchar](5) NULL,
	[PayPalGrantType__c] [nvarchar](255) NULL,
	[BCC1_Name__c] [nvarchar](255) NULL,
	[BCC1_Email__c] [nvarchar](255) NULL,
	[BCC2_Name__c] [nvarchar](255) NULL,
	[BCC2_Email__c] [nvarchar](255) NULL,
	[GlobalCharityDatabase__c] [varchar](5) NULL,
	[Recoverable_Grant__c] [varchar](5) NULL,
	[Expected_Recoverable_Return_Date__c] [date] NULL,
	[Historic_RecognitionName__c] [varchar](255) NULL,
	[Historic_Ack_Constituent__c] [nvarchar](255) NULL,
	[Historic_Ack_CC_Name__c] [nvarchar](1023) NULL,
	[Lobbying_Reporting__c] [nvarchar](255) NULL,
	[Grassroot_Amount__c] [nvarchar](255) NULL,
	[Direct_Amount__c] [nvarchar](255) NULL,
	[Adj_Grassroot_Amount__c] [nvarchar](255) NULL,
	[Adj_Direct_Amount__c] [nvarchar](255) NULL,
	[Recurring_Grant__c] [nvarchar](18) NULL,
	[Historic_Parent_Grant_Request__c] [int] NULL,
	[Historic_Parent_Proposal__c] [nvarchar](18) NULL,
	[Historic_Parent_Scholarship__c] [int] NULL,
	[Historic_Schol_Year_Attending__c] [nvarchar](4) NULL,
	[Historic_Schol_Student_ID__c] [nvarchar](255) NULL,
	[Historic_Schol_First_Name__c] [varchar](50) NULL,
	[Historic_Schol_Last_Name__c] [varchar](100) NULL,
	[Historic_Schol_Salutation__c] [nvarchar](255) NULL,
	[Historic_Schol_Academic_Year__c] [nvarchar](9) NULL,
	[Historic_Schol_Enrollment_Status__c] [nvarchar](255) NULL,
	[Historic_Schol_Student_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_School_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_Disbursement__c] [nvarchar](255) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Grants_Backup]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Grants_Backup](
	[Grant_ID__c] [int] NULL,
	[Grant_Number__c] [nvarchar](255) NULL,
	[Historic_Grant_Type__c] [nvarchar](4) NULL,
	[Historic_Full_Grant_Type__c] [nvarchar](308) NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[Status__c] [nvarchar](50) NULL,
	[Historic_Created_Date__c] [datetime] NULL,
	[Date_Submitted__c] [datetime] NULL,
	[Approved_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [varchar](255) NULL,
	[Special_Instructions__c] [varchar](255) NULL,
	[Number_of_Payments__c] [int] NULL,
	[Amount__c] [numeric](20, 2) NULL,
	[Adjusted_Amount__c] [numeric](20, 2) NULL,
	[Grant_Anonymous__c] [varchar](5) NULL,
	[FundInd__c] [varchar](8) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Recipient__c] [nvarchar](18) NULL,
	[Recipient_Contact__c] [nvarchar](18) NULL,
	[Recipient_Salutation__c] [nvarchar](255) NULL,
	[Recipient_Mailing_Address_Historic__c] [nvarchar](255) NULL,
	[Recipient_Valid_Through_Date__c] [datetime] NULL,
	[Payee_Org_ID__c] [int] NULL,
	[Payee_Organization__c] [nvarchar](18) NULL,
	[Payee_Contact__c] [nvarchar](18) NULL,
	[Payee_Salutation__c] [nvarchar](255) NULL,
	[Payee_Address__c] [nvarchar](1025) NULL,
	[Program_Manager__c] [nvarchar](18) NULL,
	[Anonymous_Fund__c] [varchar](5) NULL,
	[Recipient_Fund__c] [nvarchar](18) NULL,
	[Grant_Contact_Method__c] [nvarchar](50) NULL,
	[Anonymous_Fund_Advisor__c] [varchar](5) NULL,
	[Anticipated_Outcomes__c] [nvarchar](255) NULL,
	[CC1_Name__c] [nvarchar](255) NULL,
	[CC1_Email__c] [nvarchar](255) NULL,
	[CC2_Name__c] [nvarchar](255) NULL,
	[CC2_Email__c] [nvarchar](255) NULL,
	[Grant_Period_Start_Date__c] [date] NULL,
	[Grant_Period_End_Date__c] [date] NULL,
	[Grant_Recommendation_Agreement__c] [varchar](5) NULL,
	[Grant_Agreement_Received_Date__c] [date] NULL,
	[CC3_Email__c] [nvarchar](255) NULL,
	[CC4_Name__c] [nvarchar](255) NULL,
	[CC4_Email__c] [nvarchar](255) NULL,
	[Service_Area__c] [nvarchar](255) NULL,
	[Grant_Strategy__c] [nvarchar](255) NULL,
	[Conditions__c] [nvarchar](255) NULL,
	[Special_Accounting_Instruction__c] [nvarchar](255) NULL,
	[Conditional_Grant__c] [varchar](5) NULL,
	[CAFProposalFocusArea__c] [nvarchar](255) NULL,
	[Decline_Comments__c] [nvarchar](255) NULL,
	[Department__c] [nvarchar](255) NULL,
	[Due_Diligence_Type__c] [nvarchar](255) NULL,
	[CAFProposalGeoArea__c] [nvarchar](255) NULL,
	[Historic_T_code__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team_Employee__c] [nvarchar](255) NULL,
	[CiscoCyberGrantsProposalID__c] [nvarchar](255) NULL,
	[Historic_CAF_Focus_Area__c] [nvarchar](255) NULL,
	[Historic_CAF_Geographic_Area__c] [nvarchar](255) NULL,
	[Standard_Grant__c] [varchar](5) NULL,
	[Expedited__c] [varchar](5) NULL,
	[PayPalGrantType__c] [nvarchar](255) NULL,
	[BCC1_Name__c] [nvarchar](255) NULL,
	[BCC1_Email__c] [nvarchar](255) NULL,
	[BCC2_Name__c] [nvarchar](255) NULL,
	[BCC2_Email__c] [nvarchar](255) NULL,
	[GlobalCharityDatabase__c] [varchar](5) NULL,
	[Recoverable_Grant__c] [varchar](5) NULL,
	[Expected_Recoverable_Return_Date__c] [date] NULL,
	[Historic_RecognitionName__c] [varchar](255) NULL,
	[Historic_Ack_Constituent__c] [nvarchar](255) NULL,
	[Historic_Ack_CC_Name__c] [nvarchar](1023) NULL,
	[Lobbying_Reporting__c] [nvarchar](255) NULL,
	[Grassroot_Amount__c] [nvarchar](255) NULL,
	[Direct_Amount__c] [nvarchar](255) NULL,
	[Adj_Grassroot_Amount__c] [nvarchar](255) NULL,
	[Adj_Direct_Amount__c] [nvarchar](255) NULL,
	[Recurring_Grant__c] [nvarchar](18) NULL,
	[Historic_Parent_Grant_Request__c] [int] NULL,
	[Historic_Parent_Proposal__c] [nvarchar](18) NULL,
	[Historic_Parent_Scholarship__c] [int] NULL,
	[Historic_Schol_Year_Attending__c] [nvarchar](4) NULL,
	[Historic_Schol_Student_ID__c] [nvarchar](255) NULL,
	[Historic_Schol_First_Name__c] [varchar](50) NULL,
	[Historic_Schol_Last_Name__c] [varchar](100) NULL,
	[Historic_Schol_Salutation__c] [nvarchar](255) NULL,
	[Historic_Schol_Academic_Year__c] [nvarchar](9) NULL,
	[Historic_Schol_Enrollment_Status__c] [nvarchar](255) NULL,
	[Historic_Schol_Student_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_School_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_Disbursement__c] [nvarchar](255) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_PrimaryContact]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_PrimaryContact](
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[Nickname__c] [varchar](50) NULL,
	[MaidenName__c] [varchar](100) NULL,
	[Salutation] [varchar](100) NULL,
	[Suffix] [varchar](100) NULL,
	[MaritalStatus__c] [varchar](100) NULL,
	[Gender__c] [varchar](100) NULL,
	[npsp__Deceased__c] [bit] NULL,
	[IsActive__c] [bit] NULL,
	[IsStaff__c] [bit] NULL,
	[Email] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[MobilePhone] [varchar](2047) NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[npe01__WorkEmail__c] [varchar](2047) NULL,
	[DoNotShareEmailBusiness__c] [bit] NULL,
	[npe01__WorkPhone__c] [varchar](2047) NULL,
	[DoNotShareDirectBusinessPhone__c] [bit] NULL,
	[OtherPhone] [varchar](2047) NULL,
	[DoNotShareMainBusinessPhone__c] [bit] NULL,
	[WebsiteBusiness__c] [varchar](2047) NULL,
	[AnonymousForGifts__c] [bit] NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[ProfessionalAdvisorRating__c] [varchar](100) NULL,
	[Professional_Advisor_Type__c] [nvarchar](max) NULL,
	[Title] [varchar](50) NULL,
	[Website__c] [varchar](2047) NULL,
	[DeceasedDate__c] [varchar](10) NULL,
	[BirthDate] [varchar](10) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Proposal]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Proposal](
	[ProposalSystemID__c] [int] NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[Name] [varchar](255) NULL,
	[Donor_Account__c] [nvarchar](1300) NULL,
	[Donor_Contact__c] [nvarchar](18) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Campaign__c] [nvarchar](18) NULL,
	[Staff_Lead__c] [nvarchar](18) NULL,
	[Staff_Support__c] [nvarchar](18) NULL,
	[Proposal_Purpose__c] [varchar](100) NULL,
	[Stage__c] [varchar](100) NULL,
	[Closed_Reason__c] [varchar](100) NULL,
	[Likelihood__c] [varchar](100) NULL,
	[Date_Rated__c] [datetime] NULL,
	[Anticipated_Gift_Type__c] [varchar](100) NULL,
	[Vehicle__c] [varchar](100) NULL,
	[Amount_Asked__c] [numeric](30, 6) NULL,
	[AskedDate__c] [datetime] NULL,
	[Amount_Expected__c] [numeric](30, 6) NULL,
	[Date_Expected__c] [datetime] NULL,
	[Amount_Received__c] [numeric](30, 6) NULL,
	[ReceivedDate__c] [datetime] NULL,
	[ClientType__c] [varchar](100) NULL,
	[Referral_Types__C] [nvarchar](max) NULL,
	[ContractType__c] [varchar](100) NULL,
	[ContractSigned__c] [varchar](100) NULL,
	[ContractEntity__c] [varchar](100) NULL,
	[ContractEffectiveDate__c] [datetime] NULL,
	[ContractEndDate__c] [datetime] NULL,
	[RenegotiationNewAmount__c] [numeric](19, 4) NULL,
	[RenegotiationPriorAmount__c] [numeric](19, 4) NULL,
	[BillingMethod__c] [nvarchar](max) NULL,
	[TimeTrackingRequired__c] [bit] NULL,
	[TimeTrackingNotes__c] [nvarchar](max) NULL,
	[Region__c] [varchar](100) NULL,
	[SalesLead__c] [varchar](100) NULL,
	[ServiceLead__c] [varchar](100) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_RecurringGrants]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_RecurringGrants](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[Recommender__c] [nvarchar](18) NULL,
	[Installment_Period__c] [nvarchar](255) NULL,
	[Date_Established__c] [datetime] NULL,
	[End_Date__c] [datetime] NULL,
	[Scheduled_Start_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [nvarchar](max) NULL,
	[Total_Granted_Amount__c] [money] NULL,
	[ExternalID__c] [int] NULL,
	[Fund__c] [nvarchar](18) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Relationship]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Relationship](
	[ExternalID__c] [nvarchar](37) NULL,
	[npe4__Contact__c] [nvarchar](18) NULL,
	[npe4__RelatedContact__c] [nvarchar](18) NULL,
	[npe4__Type__c] [nvarchar](100) NULL,
	[npe4__Status__c] [bit] NULL,
	[Start_Date__c] [varchar](10) NULL,
	[End_Date__c] [varchar](10) NULL,
	[npe4__Description__c] [varchar](max) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[Contact_ConstituentSystemId] [varchar](255) NULL,
	[Contact_First_Name] [varchar](255) NULL,
	[Contact_Last_Name] [varchar](255) NULL,
	[Related_Contact_First_Name] [varchar](255) NULL,
	[Related_Contact_Last_Name] [varchar](255) NULL,
	[Related_Contact_ConstituentSystemId] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_Relationship2]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_Relationship2](
	[ExternalID__c] [nvarchar](37) NULL,
	[npe4__Contact__c] [nvarchar](18) NULL,
	[npe4__RelatedContact__c] [nvarchar](18) NULL,
	[npe4__Type__c] [nvarchar](100) NULL,
	[npe4__Status__c] [bit] NULL,
	[Start_Date__c] [varchar](10) NULL,
	[End_Date__c] [varchar](10) NULL,
	[npe4__Description__c] [varchar](max) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_SecondaryContact]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_SecondaryContact](
	[AccountID] [nvarchar](18) NULL,
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[Nickname__c] [varchar](50) NULL,
	[MaidenName__c] [varchar](100) NULL,
	[Salutation] [varchar](100) NULL,
	[Suffix] [varchar](100) NULL,
	[MaritalStatus__c] [varchar](100) NULL,
	[Gender__c] [varchar](100) NULL,
	[BirthDate] [varchar](10) NULL,
	[npsp__Deceased__c] [bit] NULL,
	[DeceasedDate__c] [varchar](10) NULL,
	[IsActive__c] [bit] NULL,
	[IsStaff__c] [bit] NULL,
	[Email] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[MobilePhone] [varchar](2047) NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[Website__c] [varchar](2047) NULL,
	[npe01__WorkEmail__c] [varchar](1000) NULL,
	[DoNotShareEmailBusiness__c] [bit] NULL,
	[npe01__WorkPhone__c] [varchar](2047) NULL,
	[DoNotShareDirectBusinessPhone__c] [bit] NULL,
	[OtherPhone] [varchar](2047) NULL,
	[DoNotShareMainBusinessPhone__c] [bit] NULL,
	[WebsiteBusiness__c] [varchar](2047) NULL,
	[AnonymousForGifts__c] [bit] NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[ProfessionalAdvisorRating__c] [varchar](100) NULL,
	[Professional_Advisor_Type__c] [nvarchar](max) NULL,
	[Title] [varchar](50) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_User]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_User](
	[FirstName] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[Email] [varchar](1000) NULL,
	[TimeZoneSidKey] [varchar](19) NULL,
	[LocaleSidKey] [varchar](5) NULL,
	[LanguageLocaleKey] [varchar](5) NULL,
	[EmailEncodingKey] [varchar](5) NULL,
	[UserName] [varchar](255) NULL,
	[Alias] [varchar](50) NULL,
	[ProfileId] [varchar](18) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Err_User2]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Err_User2](
	[FirstName] [varchar](128) NULL,
	[LastName] [varchar](128) NULL,
	[Email] [varchar](1000) NULL,
	[TimeZoneSidKey] [varchar](19) NULL,
	[LocaleSidKey] [varchar](5) NULL,
	[LanguageLocaleKey] [varchar](5) NULL,
	[EmailEncodingKey] [varchar](5) NULL,
	[UserName] [varchar](255) NULL,
	[Alias] [varchar](50) NULL,
	[ProfileId] [varchar](18) NULL,
	[IsActive] [int] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error_Fund]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_Fund](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[FundSystemID__c] [int] NULL,
	[Fund_ID__c] [varchar](20) NULL,
	[Fund_Category__c] [varchar](100) NULL,
	[Fund_Type__c] [varchar](100) NULL,
	[Fund_Family__c] [varchar](100) NULL,
	[Annotation__c] [nvarchar](max) NULL,
	[DisplayAnnotation__c] [bit] NULL,
	[Active__c] [bit] NULL,
	[Fund_Opened_Date__c] [datetime] NULL,
	[EndDate__c] [datetime] NULL,
	[Philanthropy_Lead_Contact__c] [nvarchar](18) NULL,
	[Philanthropy_Support_Contact__c] [nvarchar](18) NULL,
	[FundAnonymousForGrants__c] [bit] NULL,
	[AdvisorsAnonymousForGrants__c] [bit] NULL,
	[CustomGrantAgreement__c] [varchar](100) NULL,
	[CustomGrantAwardLetter__c] [varchar](100) NULL,
	[CustomGrantAwardLetterLanguage__c] [nvarchar](max) NULL,
	[NoteGrantProcessing__c] [nvarchar](max) NULL,
	[SuppressGiftAmountsForNonStaff__c] [bit] NULL,
	[NoteGiftProcessing__c] [nvarchar](max) NULL,
	[NoteGiftLetterProcessing__c] [nvarchar](max) NULL,
	[FundStatementType__c] [varchar](100) NULL,
	[FundStatementHeldAfterDate__c] [datetime] NULL,
	[IsSpecialHandling__c] [bit] NULL,
	[IMF_Fund__c] [bit] NULL,
	[IsBlackLabel__c] [bit] NULL,
	[BlackLabelSuite__c] [varchar](100) NULL,
	[SupportTier__c] [varchar](29) NULL,
	[FundSalesPlan__c] [varchar](100) NULL,
	[WillNotGiveTo__c] [nvarchar](max) NULL,
	[Account__c] [varchar](20) NULL,
	[Fund_Name__c] [varchar](100) NULL,
	[Focus_Area__c] [nvarchar](max) NULL,
	[Tax_ID__c] [varchar](255) NULL,
	[Principal_Restriction__c] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FC_SF_Account]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FC_SF_Account](
	[ConstituentID__c] [nvarchar](255) NULL,
	[Id] [nvarchar](18) NULL,
	[ConstituentSystemID__c] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[RecordTypeId] [nvarchar](18) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FC_SF_Contact]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FC_SF_Contact](
	[ConstituentID__c] [nvarchar](255) NULL,
	[ConstituentSystemID__c] [nvarchar](255) NULL,
	[Id] [nvarchar](18) NULL,
	[Name] [nvarchar](121) NULL,
	[AccountId] [nvarchar](18) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FC_SF_Grant]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FC_SF_Grant](
	[Acknowledgement_Address__c] [nvarchar](4000) NULL,
	[Adj_Direct_Amount__c] [float] NULL,
	[Adj_Grassroot_Amount__c] [float] NULL,
	[Adjusted_Amount__c] [float] NULL,
	[Agreement_Generated__c] [bit] NULL,
	[Agreement_Letter_Program_Manager__c] [nvarchar](1300) NULL,
	[Agreement_Letter_Template__c] [nvarchar](18) NULL,
	[Amount__c] [float] NULL,
	[Anonymous_Fund__c] [bit] NULL,
	[Anonymous_Fund_Advisor__c] [bit] NULL,
	[Anticipated_Outcomes__c] [nvarchar](255) NULL,
	[Approval_Comments__c] [nvarchar](255) NULL,
	[Approved_By__c] [nvarchar](18) NULL,
	[Approved_Date__c] [datetime] NULL,
	[Approved_Date_Formula__c] [date] NULL,
	[Are_you_recommending_grant_to_SVFC_Fund__c] [nvarchar](4000) NULL,
	[Auto_Approved__c] [bit] NULL,
	[Automation_Timer__c] [datetime] NULL,
	[Award_Letter_Wire_Transfer_Type__c] [nvarchar](1300) NULL,
	[Bank_Account__c] [nvarchar](4000) NULL,
	[BCC1_Email__c] [nvarchar](80) NULL,
	[BCC1_Name__c] [nvarchar](255) NULL,
	[BCC2_Email__c] [nvarchar](80) NULL,
	[BCC2_Name__c] [nvarchar](255) NULL,
	[Bill_Number_IFT__c] [nvarchar](80) NULL,
	[Box_Approval_Document_Link__c] [nvarchar](max) NULL,
	[CAFProposalFocusArea__c] [nvarchar](255) NULL,
	[CAFProposalGeoArea__c] [nvarchar](255) NULL,
	[CC1_Email__c] [nvarchar](255) NULL,
	[CC1_Name__c] [nvarchar](255) NULL,
	[CC2_Email__c] [nvarchar](255) NULL,
	[CC2_Name__c] [nvarchar](255) NULL,
	[CC3_Email__c] [nvarchar](80) NULL,
	[CC3_Name__c] [nvarchar](255) NULL,
	[CC4_Email__c] [nvarchar](80) NULL,
	[CC4_Name__c] [nvarchar](255) NULL,
	[CiscoCyberGrantsProposalID__c] [float] NULL,
	[Closed_Lost_Details__c] [nvarchar](max) NULL,
	[Conditional_Grant__c] [bit] NULL,
	[Conditions__c] [nvarchar](255) NULL,
	[Conditions_of_Future_Payments__c] [nvarchar](255) NULL,
	[Cost_Center__c] [nvarchar](18) NULL,
	[Country_Name__c] [nvarchar](4000) NULL,
	[Create_Fund_Allocation__c] [bit] NULL,
	[Create_Payment__c] [bit] NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Current_Grant_Bill_Amount__c] [float] NULL,
	[Current_Grant_Bill_Date__c] [date] NULL,
	[Customization_Settings__c] [nvarchar](max) NULL,
	[Date_Submitted__c] [date] NULL,
	[Decline_Comments__c] [nvarchar](255) NULL,
	[Declined_By__c] [nvarchar](18) NULL,
	[Declined_Date__c] [datetime] NULL,
	[Deductibility_Status_Description__c] [nvarchar](max) NULL,
	[Department__c] [nvarchar](4000) NULL,
	[Direct_Amount__c] [float] NULL,
	[Domestic_ER__c] [bit] NULL,
	[Due_Diligence_Type__c] [nvarchar](4000) NULL,
	[eBay_GIVE_Team__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team_Employee__c] [nvarchar](255) NULL,
	[EIN__c] [nvarchar](1300) NULL,
	[Email__c] [nvarchar](80) NULL,
	[End_Date__c] [date] NULL,
	[End_Month__c] [nvarchar](4000) NULL,
	[End_Year__c] [nvarchar](4000) NULL,
	[Entity_Type_Comments__c] [nvarchar](255) NULL,
	[Entity_Type_Not_Appropriate__c] [bit] NULL,
	[Error_Reason__c] [nvarchar](255) NULL,
	[Expected_Approval_Date__c] [date] NULL,
	[Expected_Recoverable_Return_Date__c] [date] NULL,
	[Expedited__c] [bit] NULL,
	[Final_report_Due_Date__c] [date] NULL,
	[Flow_Interview_Guide_ID__c] [nvarchar](100) NULL,
	[Focus_Area__c] [nvarchar](4000) NULL,
	[Foundation_Status_Code__c] [nvarchar](10) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Fund_Balance__c] [float] NULL,
	[Fund_Name_needed_on_Grant_Award_Letter__c] [bit] NULL,
	[Fund_Not_Found__c] [bit] NULL,
	[Fund_Type__c] [nvarchar](1300) NULL,
	[FundInd__c] [nvarchar](255) NULL,
	[Future_Payment_Month__c] [nvarchar](4000) NULL,
	[Future_Payment_Year__c] [nvarchar](4000) NULL,
	[GA_Template__c] [nvarchar](4000) NULL,
	[Generate_Grant_Agreement_Letter__c] [bit] NULL,
	[GlobalCharityDatabase__c] [bit] NULL,
	[Grant_Acknowledgement_Email__c] [nvarchar](80) NULL,
	[Grant_Acknowledgement_Mailing_Address__c] [nvarchar](max) NULL,
	[Grant_Age__c] [float] NULL,
	[Grant_Agreement__c] [bit] NULL,
	[Grant_Agreement_document__c] [nvarchar](120) NULL,
	[Grant_Agreement_Received_Date__c] [date] NULL,
	[Grant_Agreement_Template_dep__c] [nvarchar](4000) NULL,
	[Grant_Anonymous__c] [bit] NULL,
	[Grant_Approver_Division__c] [nvarchar](1300) NULL,
	[Grant_Contact_Method__c] [nvarchar](4000) NULL,
	[Grant_Dedication_Type__c] [nvarchar](4000) NULL,
	[Grant_ID__c] [nvarchar](255) NULL,
	[Grant_Letter_Template__c] [nvarchar](100) NULL,
	[Grant_Number__c] [nvarchar](255) NULL,
	[Grant_Period_End_Date__c] [date] NULL,
	[Grant_Period_Start_Date__c] [date] NULL,
	[Grant_Purpose__c] [nvarchar](4000) NULL,
	[Grant_Purpose_Comments__c] [nvarchar](255) NULL,
	[Grant_Purpose_Not_Appropriate__c] [bit] NULL,
	[Grant_Purpose_Summary__c] [nvarchar](1300) NULL,
	[Grant_Recommendation_Agreement__c] [bit] NULL,
	[Grant_Region__c] [nvarchar](100) NULL,
	[Grant_Strategy__c] [nvarchar](100) NULL,
	[Grantee_Organization_Formula_Flow__c] [nvarchar](1300) NULL,
	[Grantor__c] [nvarchar](18) NULL,
	[Grantor_Email__c] [nvarchar](1300) NULL,
	[Grantor_Household_Account__c] [nvarchar](18) NULL,
	[Grassroot_Amount__c] [float] NULL,
	[GuideStar_Address__c] [nvarchar](255) NULL,
	[Guidestar_Location__c] [nvarchar](255) NULL,
	[GuideStar_Organization_Name__c] [nvarchar](255) NULL,
	[Guidestar_Sync_Date__c] [datetime] NULL,
	[Guidestar_Sync_Error__c] [nvarchar](255) NULL,
	[Historic_Ack_CC_Name__c] [nvarchar](255) NULL,
	[Historic_Ack_Constituent__c] [nvarchar](255) NULL,
	[Historic_Ack_Fund_Name__c] [nvarchar](20) NULL,
	[Historic_AckFundName__c] [nvarchar](80) NULL,
	[Historic_AckNameandAddress__c] [nvarchar](255) NULL,
	[Historic_CAF_Focus_Area__c] [nvarchar](255) NULL,
	[Historic_CAF_Geographic_Area__c] [nvarchar](255) NULL,
	[Historic_Created_Date__c] [date] NULL,
	[Historic_Full_Grant_Type__c] [nvarchar](255) NULL,
	[Historic_Grant_Type__c] [nvarchar](255) NULL,
	[Historic_Parent_Grant_Request__c] [nvarchar](255) NULL,
	[Historic_Parent_Proposal__c] [nvarchar](18) NULL,
	[Historic_Parent_Scholarship__c] [nvarchar](80) NULL,
	[Historic_RecognitionName__c] [nvarchar](255) NULL,
	[Historic_Schol_Academic_Year__c] [nvarchar](255) NULL,
	[Historic_Schol_Disbursement__c] [nvarchar](4000) NULL,
	[Historic_Schol_Enrollment_Status__c] [nvarchar](4000) NULL,
	[Historic_Schol_First_Name__c] [nvarchar](255) NULL,
	[Historic_Schol_Last_Name__c] [nvarchar](255) NULL,
	[Historic_Schol_Salutation__c] [nvarchar](255) NULL,
	[Historic_Schol_School_Verification__c] [nvarchar](10) NULL,
	[Historic_Schol_Student_ID__c] [nvarchar](255) NULL,
	[Historic_Schol_Student_Verification__c] [nvarchar](10) NULL,
	[Historic_Schol_Year_Attending__c] [nvarchar](10) NULL,
	[Historic_T_code__c] [nvarchar](255) NULL,
	[HistoricFundAnon__c] [nvarchar](20) NULL,
	[How_much_would_you_like_to_grant__c] [nvarchar](4000) NULL,
	[How_should_the_charity_to_use_this_grant__c] [nvarchar](4000) NULL,
	[Id] [nvarchar](18) NULL,
	[In_Honor_Of__c] [nvarchar](255) NULL,
	[Initiating_Grant__c] [bit] NULL,
	[Installment_Amount__c] [float] NULL,
	[Installment_Number__c] [float] NULL,
	[Installment_Number_remove__c] [float] NULL,
	[Installment_Period__c] [nvarchar](4000) NULL,
	[Insufficient_Balance__c] [bit] NULL,
	[Intermediary_Grant__c] [bit] NULL,
	[International_ED__c] [bit] NULL,
	[International_ER__c] [bit] NULL,
	[Interval__c] [nvarchar](10) NULL,
	[IRS_Subsection__c] [nvarchar](255) NULL,
	[Is_this_an_International_Organization__c] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[LastActivityDate] [date] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[Letter_Generated__c] [bit] NULL,
	[Letter_Template__c] [nvarchar](4000) NULL,
	[Lobbying_Reporting__c] [nvarchar](4000) NULL,
	[Mailing_City__c] [nvarchar](20) NULL,
	[Mailing_Country__c] [nvarchar](20) NULL,
	[Mailing_State__c] [nvarchar](20) NULL,
	[Mailing_Street__c] [nvarchar](max) NULL,
	[Mailing_Zip_Code__c] [nvarchar](10) NULL,
	[Mass_Grant_Creation_Process__c] [bit] NULL,
	[Most_Recent_IRS_BMF__c] [nvarchar](50) NULL,
	[Most_Recent_IRS_Publication_78__c] [nvarchar](50) NULL,
	[My_Need_is_More_Specific__c] [nvarchar](max) NULL,
	[Name] [nvarchar](80) NULL,
	[NCES_School_Id__c] [nvarchar](50) NULL,
	[NCES_Sync_Date__c] [datetime] NULL,
	[NCES_Valid_Through__c] [date] NULL,
	[Never__c] [bit] NULL,
	[New_Fund_Name_IFT_Recipient__c] [nvarchar](255) NULL,
	[Next_Grant_Bill__c] [nvarchar](18) NULL,
	[Next_Payment_Date__c] [date] NULL,
	[Nintex_Designation__c] [nvarchar](255) NULL,
	[Nintex_Designation_dep__c] [nvarchar](1300) NULL,
	[Nintex_Fund_Name__c] [nvarchar](1300) NULL,
	[Nintex_Name__c] [nvarchar](100) NULL,
	[Nintex_Title__c] [nvarchar](255) NULL,
	[No_of_Recurrences__c] [float] NULL,
	[NTEE_Code__c] [nvarchar](1300) NULL,
	[Number_of_Open_Payments__c] [float] NULL,
	[Number_of_Payments__c] [nvarchar](10) NULL,
	[Number_of_Planned_Installments__c] [float] NULL,
	[Number_of_recurrences__c] [nvarchar](30) NULL,
	[Open_Cases__c] [float] NULL,
	[Open_Ended__c] [bit] NULL,
	[Operational_Comments__c] [nvarchar](255) NULL,
	[Operational_Issues__c] [bit] NULL,
	[Opportunity_Notes__c] [nvarchar](max) NULL,
	[Other__c] [nvarchar](255) NULL,
	[Other_Comments__c] [nvarchar](255) NULL,
	[Other_Grant_Purpose__c] [nvarchar](50) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Payee_Address__c] [nvarchar](255) NULL,
	[Payee_Contact__c] [nvarchar](18) NULL,
	[Payee_Org_ID__c] [nvarchar](255) NULL,
	[Payee_Organization__c] [nvarchar](18) NULL,
	[Payee_Salutation__c] [nvarchar](255) NULL,
	[Payment_Number__c] [float] NULL,
	[Payment_Schedule__c] [nvarchar](4000) NULL,
	[Payment_Timing__c] [nvarchar](4000) NULL,
	[Payment_Type__c] [nvarchar](4000) NULL,
	[PayPalGrantType__c] [nvarchar](255) NULL,
	[Phone__c] [nvarchar](40) NULL,
	[Primary_NTEE_Code__c] [nvarchar](255) NULL,
	[Primary_PCS_Code__c] [nvarchar](10) NULL,
	[Program_Manager__c] [nvarchar](18) NULL,
	[Public_Charity_Described_in_Section__c] [nvarchar](255) NULL,
	[Purpose_restricted_description__c] [nvarchar](100) NULL,
	[Reason_for_Non_Private_Foundation_Status__c] [nvarchar](255) NULL,
	[Recipient__c] [nvarchar](18) NULL,
	[Recipient_Address__c] [nvarchar](1300) NULL,
	[Recipient_Address1__c] [nvarchar](18) NULL,
	[Recipient_City__c] [nvarchar](1300) NULL,
	[Recipient_Contact__c] [nvarchar](18) NULL,
	[Recipient_Contact_Email__c] [nvarchar](1300) NULL,
	[Recipient_Contact_Name__c] [nvarchar](255) NULL,
	[Recipient_Contact_Phone__c] [nvarchar](1300) NULL,
	[Recipient_Contact_Title__c] [nvarchar](255) NULL,
	[Recipient_Contact_Title_dep__c] [nvarchar](1300) NULL,
	[Recipient_Cost_Center__c] [nvarchar](18) NULL,
	[Recipient_Country__c] [nvarchar](1300) NULL,
	[Recipient_Fund__c] [nvarchar](18) NULL,
	[Recipient_Mailing_Address_Historic__c] [nvarchar](255) NULL,
	[Recipient_Name__c] [nvarchar](1300) NULL,
	[Recipient_Organization_Mailing_City__c] [nvarchar](50) NULL,
	[Recipient_Organization_Mailing_Street__c] [nvarchar](100) NULL,
	[Recipient_Organization_Name__c] [nvarchar](255) NULL,
	[Recipient_Organization_State__c] [nvarchar](20) NULL,
	[Recipient_Organization_ZipCode__c] [nvarchar](10) NULL,
	[Recipient_Salutation__c] [nvarchar](255) NULL,
	[Recipient_State__c] [nvarchar](1300) NULL,
	[Recipient_Street__c] [nvarchar](1300) NULL,
	[Recipient_Tax_ID__c] [nvarchar](1300) NULL,
	[Recipient_Valid_Through_Date__c] [date] NULL,
	[Recipient_Website__c] [nvarchar](1300) NULL,
	[Recipient_Zipcode__c] [nvarchar](1300) NULL,
	[Recognition_Name__c] [nvarchar](100) NULL,
	[Record_Type__c] [nvarchar](1300) NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[Recoverable_Grant__c] [bit] NULL,
	[Recoverable_Terms_Details__c] [nvarchar](255) NULL,
	[Recurring_Grant__c] [nvarchar](18) NULL,
	[Recurring_Grant_Type__c] [nvarchar](4000) NULL,
	[Regenerate_Award_Letter__c] [bit] NULL,
	[Reporting_Request__c] [nvarchar](4000) NULL,
	[Ruling_Date__c] [nvarchar](30) NULL,
	[Scheduled_Start_Date__c] [date] NULL,
	[Selected_Grant_Template__c] [nvarchar](18) NULL,
	[Service_Area__c] [nvarchar](255) NULL,
	[Single_Payment_Schedule__c] [nvarchar](4000) NULL,
	[Special_Accounting_Instruction__c] [nvarchar](255) NULL,
	[Special_Instructions__c] [nvarchar](max) NULL,
	[Special_Payment_Handling__c] [nvarchar](4000) NULL,
	[Standard_Grant__c] [bit] NULL,
	[Start_Month__c] [nvarchar](4000) NULL,
	[Start_Year__c] [nvarchar](4000) NULL,
	[Status__c] [nvarchar](4000) NULL,
	[Stop_repeating_this_grant__c] [nvarchar](4000) NULL,
	[Sub_Status__c] [nvarchar](4000) NULL,
	[SystemModstamp] [datetime] NULL,
	[Tax_ID__c] [nvarchar](80) NULL,
	[Title__c] [nvarchar](80) NULL,
	[Total_Paid_Amount__c] [float] NULL,
	[Verified_Most_Recent_Internal_Revenue__c] [nvarchar](50) NULL,
	[Website__c] [nvarchar](255) NULL,
	[WFR_Now_45_min__c] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncorrectContacts]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncorrectContacts](
	[ConstituentSystemID] [varchar](18) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_Fulfillment_Error]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Fulfillment_Error](
	[Opportunity__c] [int] NULL,
	[Related_Pledge__c] [int] NULL,
	[Amount__c] [numeric](38, 4) NULL,
	[Contact__c] [nvarchar](18) NULL,
	[FulfillmentExternalID__c] [nvarchar](81) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_Fulfillment_Success]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Fulfillment_Success](
	[Opportunity__c] [int] NULL,
	[Related_Pledge__c] [int] NULL,
	[Amount__c] [numeric](38, 4) NULL,
	[Contact__c] [nvarchar](18) NULL,
	[FulfillmentExternalID__c] [nvarchar](81) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_FundAllocation_Error]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_FundAllocation_Error](
	[FundAllocationExternalId__c] [int] NULL,
	[Opportunity__c] [int] NULL,
	[Amount__c] [numeric](20, 4) NULL,
	[FundId] [int] NULL,
	[Fund__c] [nvarchar](18) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_FundAllocation_Success]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_FundAllocation_Success](
	[FundAllocationExternalId__c] [int] NULL,
	[Opportunity__c] [int] NULL,
	[Amount__c] [numeric](20, 4) NULL,
	[FundId] [int] NULL,
	[Fund__c] [nvarchar](18) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_Opportunity_Error]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Opportunity_Error](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL,
	[GiftSystemID__c] [int] NULL,
	[Gift_ID__c] [varchar](50) NULL,
	[RecordTypeId] [varchar](18) NULL,
	[GiftSubType__c] [varchar](100) NULL,
	[StageName] [varchar](24) NULL,
	[Amount] [numeric](20, 4) NULL,
	[GiftPostDate__c] [datetime] NULL,
	[GiftPostStatus__c] [varchar](14) NULL,
	[GiftReference__c] [varchar](255) NULL,
	[npsp__Batch_Number__c] [varchar](50) NULL,
	[Acknowledgment_Letter_Code__c] [varchar](100) NULL,
	[npsp__Acknowledgment_Status__c] [varchar](20) NULL,
	[npsp__Acknowledgment_Date__c] [varchar](10) NULL,
	[LetterSigner__c] [varchar](100) NULL,
	[Acknowledge_as_Combined__c] [bit] NULL,
	[Anonymous__c] [bit] NULL,
	[Establishing_Gift_to_Fund__c] [bit] NULL,
	[IsFirstGiftFromNewDonor__c] [bit] NULL,
	[Payment_Issuer__c] [varchar](100) NULL,
	[Is_Grant__c] [bit] NULL,
	[Payment_Method__c] [varchar](14) NULL,
	[Payment_Number__c] [varchar](20) NULL,
	[Payment_Date__c] [varchar](10) NULL,
	[Asset_Name__c] [varchar](50) NULL,
	[Asset_Symbol__c] [varchar](255) NULL,
	[Number_of_Units__c] [varchar](8000) NULL,
	[High_Value__c] [varchar](8000) NULL,
	[Low_Value__c] [varchar](8000) NULL,
	[Mean_Value__c] [numeric](30, 6) NULL,
	[Brokerage_Firm__c] [varchar](100) NULL,
	[X8282_Required__c] [varchar](100) NULL,
	[X8282_Filing_Completed__c] [varchar](100) NULL,
	[Asset_Type__c] [varchar](100) NULL,
	[StockPropertyWasSold__c] [bit] NULL,
	[npsp__Fair_Market_Value__c] [int] NULL,
	[Fair_Market_Value_Detail__c] [nvarchar](max) NULL,
	[CloseDate] [datetime] NULL,
	[Name] [nvarchar](255) NULL,
	[AccountId] [nvarchar](18) NULL,
	[npsp__Primary_Contact__c] [nvarchar](18) NULL,
	[Gift_Detail__c] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_Opportunity_Payment_Error]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Opportunity_Payment_Error](
	[PaymentSystemID] [int] NULL,
	[npe01__Opportunity__c] [int] NULL,
	[SaleAmount__c] [numeric](30, 6) NULL,
	[npe01__Payment_Amount__c] [numeric](30, 6) NULL,
	[SaleFee__c] [numeric](30, 6) NULL,
	[SaleDate__c] [datetime] NULL,
	[SalePostDate__c] [datetime] NULL,
	[SalePostStatus__c] [varchar](14) NULL,
	[SaleReference__c] [varchar](max) NULL,
	[npe01__Paid__c] [varchar](4) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_Opportunity_Payment_Success]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Opportunity_Payment_Success](
	[PaymentSystemID] [int] NULL,
	[npe01__Opportunity__c] [int] NULL,
	[SaleAmount__c] [numeric](30, 6) NULL,
	[npe01__Payment_Amount__c] [numeric](30, 6) NULL,
	[SaleFee__c] [numeric](30, 6) NULL,
	[SaleDate__c] [datetime] NULL,
	[SalePostDate__c] [datetime] NULL,
	[SalePostStatus__c] [varchar](14) NULL,
	[SaleReference__c] [varchar](max) NULL,
	[npe01__Paid__c] [varchar](4) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log_Opportunity_Success]    Script Date: 6/30/2022 1:44:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log_Opportunity_Success](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[GiftSystemID__c] [int] NULL,
	[Gift_ID__c] [varchar](50) NULL,
	[RecordTypeId] [varchar](18) NULL,
	[GiftSubType__c] [varchar](100) NULL,
	[StageName] [varchar](24) NULL,
	[Amount] [numeric](20, 4) NULL,
	[GiftPostDate__c] [datetime] NULL,
	[GiftPostStatus__c] [varchar](14) NULL,
	[GiftReference__c] [varchar](255) NULL,
	[npsp__Batch_Number__c] [varchar](50) NULL,
	[Acknowledgment_Letter_Code__c] [varchar](100) NULL,
	[npsp__Acknowledgment_Status__c] [varchar](20) NULL,
	[npsp__Acknowledgment_Date__c] [varchar](10) NULL,
	[LetterSigner__c] [varchar](100) NULL,
	[Acknowledge_as_Combined__c] [bit] NULL,
	[Anonymous__c] [bit] NULL,
	[Establishing_Gift_to_Fund__c] [bit] NULL,
	[IsFirstGiftFromNewDonor__c] [bit] NULL,
	[Payment_Issuer__c] [varchar](100) NULL,
	[Is_Grant__c] [bit] NULL,
	[Payment_Method__c] [varchar](14) NULL,
	[Payment_Number__c] [varchar](20) NULL,
	[Payment_Date__c] [varchar](10) NULL,
	[Asset_Name__c] [varchar](50) NULL,
	[Asset_Symbol__c] [varchar](255) NULL,
	[Number_of_Units__c] [varchar](8000) NULL,
	[High_Value__c] [varchar](8000) NULL,
	[Low_Value__c] [varchar](8000) NULL,
	[Mean_Value__c] [numeric](30, 6) NULL,
	[Brokerage_Firm__c] [varchar](100) NULL,
	[X8282_Required__c] [varchar](100) NULL,
	[X8282_Filing_Completed__c] [varchar](100) NULL,
	[Asset_Type__c] [varchar](100) NULL,
	[StockPropertyWasSold__c] [bit] NULL,
	[npsp__Fair_Market_Value__c] [int] NULL,
	[Fair_Market_Value_Detail__c] [nvarchar](max) NULL,
	[CloseDate] [datetime] NULL,
	[Name] [nvarchar](255) NULL,
	[AccountId] [nvarchar](18) NULL,
	[npsp__Primary_Contact__c] [nvarchar](18) NULL,
	[Gift_Detail__c] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OLE DB Destination]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OLE DB Destination](
	[ExternalID__c] [int] NULL,
	[Recommender__c] [nvarchar](18) NULL,
	[Installment_Period__c] [nvarchar](255) NULL,
	[Date_Established__c] [datetime] NULL,
	[End_Date__c] [datetime] NULL,
	[Scheduled_Start_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [nvarchar](max) NULL,
	[Total_Granted_Amount__c] [money] NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_All_Opportunities]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_All_Opportunities](
	[Id] [nvarchar](18) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_Err_Account]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_Err_Account](
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[Name] [varchar](60) NULL,
	[DoingBusinessAs__c] [varchar](100) NULL,
	[MissionStatement__c] [nvarchar](max) NULL,
	[FiscalYearEnd__c] [nvarchar](100) NULL,
	[EIN__c] [varchar](255) NULL,
	[TaxIDAlternate__c] [varchar](255) NULL,
	[TaxIDGroupExempt__c] [varchar](255) NULL,
	[OrganizationExempt990Type__c] [varchar](100) NULL,
	[NTEE_Code__c] [varchar](100) NULL,
	[IsActive__c] [bit] NULL,
	[Email__c] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[Website] [varchar](2047) NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[Abbreviation__c] [varchar](100) NULL,
	[Acronym__c] [varchar](100) NULL,
	[FoundationType__c] [varchar](100) NULL,
	[PublicSupportTest__c] [varchar](100) NULL,
	[IntermediaryName__c] [varchar](255) NULL,
	[IntermediaryTaxID__c] [varchar](50) NULL,
	[IntermediaryEstablishedDate__c] [datetime] NULL,
	[VetEntityType__c] [varchar](100) NULL,
	[VetEntityExpenditureResponsibilityRequir__c] [bit] NULL,
	[VetEntityIntlDueDiligenceType__c] [varchar](100) NULL,
	[VetEntityIntlHasMasterGrantAgreement__c] [bit] NULL,
	[VetEntityIntlMasterGrantAgreementDate__c] [datetime] NULL,
	[GranteeIsRegisteredForAchViaUnionBank__c] [bit] NULL,
	[GranteeRegisteredForAchViaUnionBankDate__c] [datetime] NULL,
	[GranteeValidRecipientStartDate__c] [datetime] NULL,
	[GranteeValidRecipientEndDate__c] [datetime] NULL,
	[GranteeIsValidPayee__c] [bit] NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](2048) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_Succ_Account]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_Succ_Account](
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[Name] [varchar](60) NULL,
	[DoingBusinessAs__c] [varchar](100) NULL,
	[MissionStatement__c] [nvarchar](max) NULL,
	[FiscalYearEnd__c] [nvarchar](100) NULL,
	[EIN__c] [varchar](255) NULL,
	[TaxIDAlternate__c] [varchar](255) NULL,
	[TaxIDGroupExempt__c] [varchar](255) NULL,
	[OrganizationExempt990Type__c] [varchar](100) NULL,
	[NTEE_Code__c] [varchar](100) NULL,
	[IsActive__c] [bit] NULL,
	[Email__c] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[Website] [varchar](2047) NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[Abbreviation__c] [varchar](100) NULL,
	[Acronym__c] [varchar](100) NULL,
	[FoundationType__c] [varchar](100) NULL,
	[PublicSupportTest__c] [varchar](100) NULL,
	[IntermediaryName__c] [varchar](255) NULL,
	[IntermediaryTaxID__c] [varchar](50) NULL,
	[IntermediaryEstablishedDate__c] [datetime] NULL,
	[VetEntityType__c] [varchar](100) NULL,
	[VetEntityExpenditureResponsibilityRequir__c] [bit] NULL,
	[VetEntityIntlDueDiligenceType__c] [varchar](100) NULL,
	[VetEntityIntlHasMasterGrantAgreement__c] [bit] NULL,
	[VetEntityIntlMasterGrantAgreementDate__c] [datetime] NULL,
	[GranteeIsRegisteredForAchViaUnionBank__c] [bit] NULL,
	[GranteeRegisteredForAchViaUnionBankDate__c] [datetime] NULL,
	[GranteeValidRecipientStartDate__c] [datetime] NULL,
	[GranteeValidRecipientEndDate__c] [datetime] NULL,
	[GranteeIsValidPayee__c] [bit] NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RelationshipToLoad]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelationshipToLoad](
	[ExternalID__c] [nvarchar](37) NULL,
	[npe4__Contact__c] [nvarchar](18) NULL,
	[npe4__RelatedContact__c] [nvarchar](18) NULL,
	[npe4__Type__c] [nvarchar](100) NULL,
	[npe4__Status__c] [bit] NULL,
	[Start_Date__c] [varchar](10) NULL,
	[End_Date__c] [varchar](10) NULL,
	[npe4__Description__c] [varchar](max) NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SF_Account]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Account](
	[Abbreviation__c] [nvarchar](255) NULL,
	[Account_Id__c] [nvarchar](1300) NULL,
	[Account_Image_URL__c] [nvarchar](255) NULL,
	[Account_Name__c] [nvarchar](1300) NULL,
	[Account_URL__c] [nvarchar](1300) NULL,
	[AccountNumber] [nvarchar](40) NULL,
	[AccountSource] [nvarchar](4000) NULL,
	[Acronym__c] [nvarchar](80) NULL,
	[Address_Verified__c] [float] NULL,
	[Alias__c] [nvarchar](20) NULL,
	[AnnualRevenue] [float] NULL,
	[Approved_Recipient_Account__c] [bit] NULL,
	[Assets__c] [float] NULL,
	[Bank_Name__c] [nvarchar](100) NULL,
	[BillingCity] [nvarchar](40) NULL,
	[BillingCountry] [nvarchar](80) NULL,
	[BillingGeocodeAccuracy] [nvarchar](4000) NULL,
	[BillingLatitude] [float] NULL,
	[BillingLongitude] [float] NULL,
	[BillingPostalCode] [nvarchar](20) NULL,
	[BillingState] [nvarchar](80) NULL,
	[BillingStreet] [nvarchar](255) NULL,
	[ChannelProgramLevelName] [nvarchar](255) NULL,
	[ChannelProgramName] [nvarchar](255) NULL,
	[Charitable_goals_questions_and_concerns__c] [nvarchar](max) NULL,
	[City__c] [nvarchar](1300) NULL,
	[ConstituentID__c] [nvarchar](255) NULL,
	[ConstituentSystemID__c] [nvarchar](255) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Deductibility_Status_Description__c] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DoingBusinessAs__c] [nvarchar](255) NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[DS360oi__Active__c] [nvarchar](4000) NULL,
	[DS360oi__Background_Batch_Flag__c] [bit] NULL,
	[DS360oi__CustomerPriority__c] [nvarchar](4000) NULL,
	[DS360oi__DS_update__c] [nvarchar](255) NULL,
	[DS360oi__DS_update_date__c] [datetime] NULL,
	[DS360oi__Middle_Initial_Name__c] [nvarchar](10) NULL,
	[DS360oi__NumberofLocations__c] [float] NULL,
	[DS360oi__SLA__c] [nvarchar](4000) NULL,
	[DS360oi__SLAExpirationDate__c] [date] NULL,
	[DS360oi__SLASerialNumber__c] [nvarchar](10) NULL,
	[DS360oi__UpsellOpportunity__c] [nvarchar](4000) NULL,
	[EIN__c] [nvarchar](18) NULL,
	[Email__c] [nvarchar](255) NULL,
	[Email_Address__c] [nvarchar](80) NULL,
	[Favourite__c] [nvarchar](1300) NULL,
	[Fax] [nvarchar](40) NULL,
	[Field_of_Interest__c] [nvarchar](max) NULL,
	[FiscalYearEnd__c] [nvarchar](100) NULL,
	[Foundation_Status_Code__c] [nvarchar](10) NULL,
	[FoundationType__c] [nvarchar](255) NULL,
	[Grant_Recommendation_Form_URL__c] [nvarchar](1300) NULL,
	[GranteeIsRegisteredForAchViaUnionBank__c] [bit] NULL,
	[GranteeIsValidPayee__c] [bit] NULL,
	[GranteeRegisteredForAchViaUnionBankDate__c] [date] NULL,
	[GranteeValidRecipientEndDate__c] [date] NULL,
	[GranteeValidRecipientStartDate__c] [date] NULL,
	[Gross_Receipts__c] [float] NULL,
	[GuideStar_Address__c] [nvarchar](255) NULL,
	[GuideStar_Location__c] [nvarchar](255) NULL,
	[GuideStar_Organization_Name__c] [nvarchar](255) NULL,
	[GuideStar_Sync_Date__c] [datetime] NULL,
	[GuideStar_Sync_Error__c] [nvarchar](255) NULL,
	[GuideStar_URL__c] [nvarchar](255) NULL,
	[HeartIcon__c] [nvarchar](1300) NULL,
	[Households_Under_this_LDE__c] [float] NULL,
	[Id] [nvarchar](18) NULL,
	[Image__c] [nvarchar](max) NULL,
	[Industry] [nvarchar](4000) NULL,
	[Interest_Cause_Areas__c] [nvarchar](max) NULL,
	[IntermediaryEstablishedDate__c] [date] NULL,
	[IntermediaryName__c] [nvarchar](255) NULL,
	[IntermediaryTaxID__c] [nvarchar](80) NULL,
	[IRS_Subsection__c] [nvarchar](255) NULL,
	[IsActive__c] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[isFavorite__c] [bit] NULL,
	[IsPartner] [bit] NULL,
	[Jigsaw] [nvarchar](20) NULL,
	[JigsawCompanyId] [nvarchar](20) NULL,
	[LastActivityDate] [date] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[Level__c] [nvarchar](18) NULL,
	[MasterRecordId] [nvarchar](18) NULL,
	[MissionStatement__c] [nvarchar](max) NULL,
	[Most_Recent_IRS_BMF__c] [nvarchar](50) NULL,
	[Most_Recent_IRS_Publication_78__c] [nvarchar](50) NULL,
	[Most_Recent_Verified_Date__c] [date] NULL,
	[Name] [nvarchar](255) NULL,
	[NCES_School_Id__c] [nvarchar](50) NULL,
	[NCES_Search__c] [nvarchar](1300) NULL,
	[NCES_Search_By__c] [nvarchar](4000) NULL,
	[NCES_Sync_Date__c] [datetime] NULL,
	[NCES_Valid_Through__c] [date] NULL,
	[NCES_Verified_Date__c] [date] NULL,
	[NetSuite_Id__c] [nvarchar](20) NULL,
	[NetSuite_Sync_Date__c] [datetime] NULL,
	[NetSuite_Sync_Error__c] [nvarchar](255) NULL,
	[npe01__One2OneContact__c] [nvarchar](18) NULL,
	[npe01__SYSTEM_AccountType__c] [nvarchar](100) NULL,
	[npe01__SYSTEMIsIndividual__c] [bit] NULL,
	[npo02__AverageAmount__c] [float] NULL,
	[npo02__Best_Gift_Year__c] [nvarchar](4) NULL,
	[npo02__Best_Gift_Year_Total__c] [float] NULL,
	[npo02__FirstCloseDate__c] [date] NULL,
	[npo02__Formal_Greeting__c] [nvarchar](255) NULL,
	[npo02__HouseholdPhone__c] [nvarchar](40) NULL,
	[npo02__Informal_Greeting__c] [nvarchar](255) NULL,
	[npo02__LargestAmount__c] [float] NULL,
	[npo02__LastCloseDate__c] [date] NULL,
	[npo02__LastMembershipAmount__c] [float] NULL,
	[npo02__LastMembershipDate__c] [date] NULL,
	[npo02__LastMembershipLevel__c] [nvarchar](255) NULL,
	[npo02__LastMembershipOrigin__c] [nvarchar](255) NULL,
	[npo02__LastOppAmount__c] [float] NULL,
	[npo02__MembershipEndDate__c] [date] NULL,
	[npo02__MembershipJoinDate__c] [date] NULL,
	[npo02__NumberOfClosedOpps__c] [float] NULL,
	[npo02__NumberOfMembershipOpps__c] [float] NULL,
	[npo02__OppAmount2YearsAgo__c] [float] NULL,
	[npo02__OppAmountLastNDays__c] [float] NULL,
	[npo02__OppAmountLastYear__c] [float] NULL,
	[npo02__OppAmountThisYear__c] [float] NULL,
	[npo02__OppsClosed2YearsAgo__c] [float] NULL,
	[npo02__OppsClosedLastNDays__c] [float] NULL,
	[npo02__OppsClosedLastYear__c] [float] NULL,
	[npo02__OppsClosedThisYear__c] [float] NULL,
	[npo02__SmallestAmount__c] [float] NULL,
	[npo02__SYSTEM_CUSTOM_NAMING__c] [nvarchar](max) NULL,
	[npo02__TotalMembershipOppAmount__c] [float] NULL,
	[npo02__TotalOppAmount__c] [float] NULL,
	[npsp__Batch__c] [nvarchar](18) NULL,
	[npsp__Funding_Focus__c] [nvarchar](max) NULL,
	[npsp__Grantmaker__c] [bit] NULL,
	[npsp__Matching_Gift_Administrator_Name__c] [nvarchar](255) NULL,
	[npsp__Matching_Gift_Amount_Max__c] [float] NULL,
	[npsp__Matching_Gift_Amount_Min__c] [float] NULL,
	[npsp__Matching_Gift_Annual_Employee_Max__c] [float] NULL,
	[npsp__Matching_Gift_Comments__c] [nvarchar](max) NULL,
	[npsp__Matching_Gift_Company__c] [bit] NULL,
	[npsp__Matching_Gift_Email__c] [nvarchar](80) NULL,
	[npsp__Matching_Gift_Info_Updated__c] [date] NULL,
	[npsp__Matching_Gift_Percent__c] [float] NULL,
	[npsp__Matching_Gift_Phone__c] [nvarchar](40) NULL,
	[npsp__Matching_Gift_Request_Deadline__c] [nvarchar](255) NULL,
	[npsp__Membership_Span__c] [float] NULL,
	[npsp__Membership_Status__c] [nvarchar](1300) NULL,
	[npsp__Number_of_Household_Members__c] [float] NULL,
	[NS_Internal_Id__c] [nvarchar](255) NULL,
	[NS_Sync_Date__c] [datetime] NULL,
	[NS_Sync_Error__c] [nvarchar](max) NULL,
	[NTEE_Code__c] [nvarchar](255) NULL,
	[NumberOfEmployees] [int] NULL,
	[OrganizationExempt990Type__c] [nvarchar](80) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Ownership] [nvarchar](4000) NULL,
	[ParentId] [nvarchar](18) NULL,
	[Phone] [nvarchar](40) NULL,
	[PhotoUrl] [nvarchar](255) NULL,
	[Previous_Level__c] [nvarchar](18) NULL,
	[Primary_Contact1__c] [nvarchar](1300) NULL,
	[Primary_PCS_Code__c] [nvarchar](255) NULL,
	[Public_Charity_Described_in_Section__c] [nvarchar](255) NULL,
	[PublicSupportTest__c] [nvarchar](255) NULL,
	[Rating] [nvarchar](4000) NULL,
	[Reason_for_Non_Private_Foundation_Status__c] [nvarchar](255) NULL,
	[Recieve_Newsletter__c] [nvarchar](4000) NULL,
	[Recommend_A_Grant__c] [nvarchar](1300) NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[ReportTypeForGifts__c] [nvarchar](80) NULL,
	[Ruling_Date__c] [nvarchar](30) NULL,
	[ShippingCity] [nvarchar](40) NULL,
	[ShippingCountry] [nvarchar](80) NULL,
	[ShippingGeocodeAccuracy] [nvarchar](4000) NULL,
	[ShippingLatitude] [float] NULL,
	[ShippingLongitude] [float] NULL,
	[ShippingPostalCode] [nvarchar](20) NULL,
	[ShippingState] [nvarchar](80) NULL,
	[ShippingStreet] [nvarchar](255) NULL,
	[Sic] [nvarchar](20) NULL,
	[SicDesc] [nvarchar](80) NULL,
	[Site] [nvarchar](80) NULL,
	[Staff_Contact__c] [nvarchar](18) NULL,
	[State_Province__c] [nvarchar](1300) NULL,
	[Sum_of_Unpaid_Pledges__c] [float] NULL,
	[Sync_to_GuideStar__c] [bit] NULL,
	[Sync_to_NetSuite__c] [bit] NULL,
	[SystemModstamp] [datetime] NULL,
	[TaxIDAlternate__c] [nvarchar](80) NULL,
	[TaxIDGroupExempt__c] [nvarchar](255) NULL,
	[TickerSymbol] [nvarchar](20) NULL,
	[Type] [nvarchar](4000) NULL,
	[Unpaid_Pledges__c] [float] NULL,
	[Verified_Most_Recent_Internal_Revenue__c] [nvarchar](50) NULL,
	[VetEntityCurrentIssue__c] [nvarchar](255) NULL,
	[VetEntityEquivalencyDeterminationRequire__c] [nvarchar](255) NULL,
	[VetEntityExpenditureResponsibilityRequir__c] [bit] NULL,
	[VetEntityIntlDueDiligenceType__c] [nvarchar](255) NULL,
	[VetEntityIntlHasMasterGrantAgreement__c] [nvarchar](255) NULL,
	[VetEntityIntlMasterGrantAgreementDate__c] [date] NULL,
	[VetEntityOrgSource__c] [nvarchar](255) NULL,
	[VetEntityOutreachNeeded__c] [nvarchar](255) NULL,
	[VetEntityType__c] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SF_Fund_Data]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Fund_Data](
	[Id] [nvarchar](18) NULL,
	[Fund_ID__c] [nvarchar](10) NULL,
	[FundSystemID__c] [float] NULL,
	[Fund_Name__c] [nvarchar](255) NULL,
	[Name] [nvarchar](80) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SF_User]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_User](
	[AboutMe] [nvarchar](1000) NULL,
	[AccountId] [nvarchar](18) NULL,
	[Alias] [nvarchar](8) NULL,
	[Alternate_Address__c] [nvarchar](255) NULL,
	[Alternate_Email__c] [nvarchar](80) NULL,
	[Alternate_Phone__c] [nvarchar](40) NULL,
	[BadgeText] [nvarchar](80) NULL,
	[BannerPhotoUrl] [nvarchar](1024) NULL,
	[Birth_Date__c] [date] NULL,
	[CallCenterId] [nvarchar](18) NULL,
	[City] [nvarchar](40) NULL,
	[CommunityNickname] [nvarchar](40) NULL,
	[Company_Address__c] [nvarchar](255) NULL,
	[CompanyName] [nvarchar](80) NULL,
	[ContactId] [nvarchar](18) NULL,
	[Country] [nvarchar](80) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[DefaultGroupNotificationFrequency] [nvarchar](4000) NULL,
	[DelegatedApproverId] [nvarchar](18) NULL,
	[Department] [nvarchar](80) NULL,
	[DigestFrequency] [nvarchar](4000) NULL,
	[Division] [nvarchar](80) NULL,
	[Email] [nvarchar](128) NULL,
	[EmailEncodingKey] [nvarchar](4000) NULL,
	[EmailPreferencesAutoBcc] [bit] NULL,
	[EmailPreferencesAutoBccStayInTouch] [bit] NULL,
	[EmailPreferencesStayInTouchReminder] [bit] NULL,
	[EmployeeNumber] [nvarchar](20) NULL,
	[Extension] [nvarchar](40) NULL,
	[Fax] [nvarchar](40) NULL,
	[FederationIdentifier] [nvarchar](512) NULL,
	[FirstName] [nvarchar](40) NULL,
	[ForecastEnabled] [bit] NULL,
	[FullPhotoUrl] [nvarchar](1024) NULL,
	[Gender__c] [nvarchar](4000) NULL,
	[GeocodeAccuracy] [nvarchar](4000) NULL,
	[Giving_Interests__c] [nvarchar](max) NULL,
	[Grant_Acknowledgement_Address__c] [nvarchar](255) NULL,
	[Grant_Recognition_name__c] [nvarchar](30) NULL,
	[Id] [nvarchar](18) NULL,
	[IndividualId] [nvarchar](18) NULL,
	[Interest_Areas__c] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[IsExtIndicatorVisible] [bit] NULL,
	[IsPortalEnabled] [bit] NULL,
	[IsProfilePhotoActive] [bit] NULL,
	[LanguageLocaleKey] [nvarchar](4000) NULL,
	[LastLoginDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastName] [nvarchar](80) NULL,
	[LastPasswordChangeDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[Latitude] [float] NULL,
	[LocaleSidKey] [nvarchar](4000) NULL,
	[Longitude] [float] NULL,
	[Loop__dsPassword__c] [nvarchar](255) NULL,
	[Loop__dsToken__c] [nvarchar](255) NULL,
	[Loop__LOOPlus_Tester__c] [bit] NULL,
	[Make_all_of_my_grants_donor_anonymous__c] [bit] NULL,
	[Make_all_of_my_grants_fund_anonymous__c] [bit] NULL,
	[ManagerId] [nvarchar](18) NULL,
	[MediumBannerPhotoUrl] [nvarchar](1024) NULL,
	[MediumPhotoUrl] [nvarchar](1024) NULL,
	[MiddleName] [nvarchar](40) NULL,
	[MobilePhone] [nvarchar](40) NULL,
	[Name] [nvarchar](121) NULL,
	[NumberOfFailedLogins] [int] NULL,
	[OfflinePdaTrialExpirationDate] [datetime] NULL,
	[OfflineTrialExpirationDate] [datetime] NULL,
	[OutOfOfficeMessage] [nvarchar](40) NULL,
	[Phone] [nvarchar](40) NULL,
	[pi__Can_View_Not_Assigned_Prospects__c] [bit] NULL,
	[pi__Pardot_Api_Key__c] [nvarchar](100) NULL,
	[pi__Pardot_Api_Version__c] [nvarchar](1) NULL,
	[pi__Pardot_User_Id__c] [nvarchar](100) NULL,
	[pi__Pardot_User_Key__c] [nvarchar](100) NULL,
	[pi__Pardot_User_Role__c] [nvarchar](100) NULL,
	[PortalRole] [nvarchar](4000) NULL,
	[Position__c] [nvarchar](20) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[ProfileId] [nvarchar](18) NULL,
	[ReceivesAdminInfoEmails] [bit] NULL,
	[ReceivesInfoEmails] [bit] NULL,
	[SenderEmail] [nvarchar](80) NULL,
	[SenderName] [nvarchar](80) NULL,
	[Signature] [nvarchar](1333) NULL,
	[SmallBannerPhotoUrl] [nvarchar](1024) NULL,
	[SmallPhotoUrl] [nvarchar](1024) NULL,
	[State] [nvarchar](80) NULL,
	[StayInTouchNote] [nvarchar](512) NULL,
	[StayInTouchSignature] [nvarchar](512) NULL,
	[StayInTouchSubject] [nvarchar](80) NULL,
	[Street] [nvarchar](255) NULL,
	[Suffix] [nvarchar](40) NULL,
	[SystemModstamp] [datetime] NULL,
	[TimeZoneSidKey] [nvarchar](4000) NULL,
	[Title] [nvarchar](80) NULL,
	[Username] [nvarchar](80) NULL,
	[UserPermissionsAvantgoUser] [bit] NULL,
	[UserPermissionsCallCenterAutoLogin] [bit] NULL,
	[UserPermissionsInteractionUser] [bit] NULL,
	[UserPermissionsKnowledgeUser] [bit] NULL,
	[UserPermissionsMarketingUser] [bit] NULL,
	[UserPermissionsOfflineUser] [bit] NULL,
	[UserPermissionsSFContentUser] [bit] NULL,
	[UserPermissionsSupportUser] [bit] NULL,
	[UserPreferencesActivityRemindersPopup] [bit] NULL,
	[UserPreferencesApexPagesDeveloperMode] [bit] NULL,
	[UserPreferencesCacheDiagnostics] [bit] NULL,
	[UserPreferencesCreateLEXAppsWTShown] [bit] NULL,
	[UserPreferencesDisableAllFeedsEmail] [bit] NULL,
	[UserPreferencesDisableBookmarkEmail] [bit] NULL,
	[UserPreferencesDisableChangeCommentEmail] [bit] NULL,
	[UserPreferencesDisableEndorsementEmail] [bit] NULL,
	[UserPreferencesDisableFileShareNotificationsForApi] [bit] NULL,
	[UserPreferencesDisableFollowersEmail] [bit] NULL,
	[UserPreferencesDisableLaterCommentEmail] [bit] NULL,
	[UserPreferencesDisableLikeEmail] [bit] NULL,
	[UserPreferencesDisableMentionsPostEmail] [bit] NULL,
	[UserPreferencesDisableMessageEmail] [bit] NULL,
	[UserPreferencesDisableProfilePostEmail] [bit] NULL,
	[UserPreferencesDisableSharePostEmail] [bit] NULL,
	[UserPreferencesDisCommentAfterLikeEmail] [bit] NULL,
	[UserPreferencesDisMentionsCommentEmail] [bit] NULL,
	[UserPreferencesDisProfPostCommentEmail] [bit] NULL,
	[UserPreferencesEnableAutoSubForFeeds] [bit] NULL,
	[UserPreferencesEventRemindersCheckboxDefault] [bit] NULL,
	[UserPreferencesExcludeMailAppAttachments] [bit] NULL,
	[UserPreferencesFavoritesShowTopFavorites] [bit] NULL,
	[UserPreferencesFavoritesWTShown] [bit] NULL,
	[UserPreferencesGlobalNavBarWTShown] [bit] NULL,
	[UserPreferencesGlobalNavGridMenuWTShown] [bit] NULL,
	[UserPreferencesHasCelebrationBadge] [bit] NULL,
	[UserPreferencesHideBiggerPhotoCallout] [bit] NULL,
	[UserPreferencesHideBrowseProductRedirectConfirmation] [bit] NULL,
	[UserPreferencesHideChatterOnboardingSplash] [bit] NULL,
	[UserPreferencesHideCSNDesktopTask] [bit] NULL,
	[UserPreferencesHideCSNGetChatterMobileTask] [bit] NULL,
	[UserPreferencesHideEndUserOnboardingAssistantModal] [bit] NULL,
	[UserPreferencesHideInvoicesRedirectConfirmation] [bit] NULL,
	[UserPreferencesHideLightningMigrationModal] [bit] NULL,
	[UserPreferencesHideOnlineSalesAppWelcomeMat] [bit] NULL,
	[UserPreferencesHideS1BrowserUI] [bit] NULL,
	[UserPreferencesHideSecondChatterOnboardingSplash] [bit] NULL,
	[UserPreferencesHideSfxWelcomeMat] [bit] NULL,
	[UserPreferencesHideStatementsRedirectConfirmation] [bit] NULL,
	[UserPreferencesLightningExperiencePreferred] [bit] NULL,
	[UserPreferencesNativeEmailClient] [bit] NULL,
	[UserPreferencesNewLightningReportRunPageEnabled] [bit] NULL,
	[UserPreferencesPathAssistantCollapsed] [bit] NULL,
	[UserPreferencesPreviewCustomTheme] [bit] NULL,
	[UserPreferencesPreviewLightning] [bit] NULL,
	[UserPreferencesReceiveNoNotificationsAsApprover] [bit] NULL,
	[UserPreferencesReceiveNotificationsAsDelegatedApprover] [bit] NULL,
	[UserPreferencesRecordHomeReservedWTShown] [bit] NULL,
	[UserPreferencesRecordHomeSectionCollapseWTShown] [bit] NULL,
	[UserPreferencesReminderSoundOff] [bit] NULL,
	[UserPreferencesReverseOpenActivitiesView] [bit] NULL,
	[UserPreferencesShowCityToExternalUsers] [bit] NULL,
	[UserPreferencesShowCityToGuestUsers] [bit] NULL,
	[UserPreferencesShowCountryToExternalUsers] [bit] NULL,
	[UserPreferencesShowCountryToGuestUsers] [bit] NULL,
	[UserPreferencesShowEmailToExternalUsers] [bit] NULL,
	[UserPreferencesShowEmailToGuestUsers] [bit] NULL,
	[UserPreferencesShowFaxToExternalUsers] [bit] NULL,
	[UserPreferencesShowFaxToGuestUsers] [bit] NULL,
	[UserPreferencesShowManagerToExternalUsers] [bit] NULL,
	[UserPreferencesShowManagerToGuestUsers] [bit] NULL,
	[UserPreferencesShowMobilePhoneToExternalUsers] [bit] NULL,
	[UserPreferencesShowMobilePhoneToGuestUsers] [bit] NULL,
	[UserPreferencesShowPostalCodeToExternalUsers] [bit] NULL,
	[UserPreferencesShowPostalCodeToGuestUsers] [bit] NULL,
	[UserPreferencesShowProfilePicToGuestUsers] [bit] NULL,
	[UserPreferencesShowStateToExternalUsers] [bit] NULL,
	[UserPreferencesShowStateToGuestUsers] [bit] NULL,
	[UserPreferencesShowStreetAddressToExternalUsers] [bit] NULL,
	[UserPreferencesShowStreetAddressToGuestUsers] [bit] NULL,
	[UserPreferencesShowTitleToExternalUsers] [bit] NULL,
	[UserPreferencesShowTitleToGuestUsers] [bit] NULL,
	[UserPreferencesShowWorkPhoneToExternalUsers] [bit] NULL,
	[UserPreferencesShowWorkPhoneToGuestUsers] [bit] NULL,
	[UserPreferencesSortFeedByComment] [bit] NULL,
	[UserPreferencesSRHOverrideActivities] [bit] NULL,
	[UserPreferencesSuppressEventSFXReminders] [bit] NULL,
	[UserPreferencesSuppressTaskSFXReminders] [bit] NULL,
	[UserPreferencesTaskRemindersCheckboxDefault] [bit] NULL,
	[UserPreferencesUserDebugModePref] [bit] NULL,
	[UserRoleId] [nvarchar](18) NULL,
	[UserType] [nvarchar](4000) NULL,
	[Ways__c] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Account]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Account](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[Name] [varchar](60) NULL,
	[DoingBusinessAs__c] [varchar](100) NULL,
	[MissionStatement__c] [nvarchar](max) NULL,
	[FiscalYearEnd__c] [nvarchar](100) NULL,
	[EIN__c] [varchar](255) NULL,
	[TaxIDAlternate__c] [varchar](255) NULL,
	[TaxIDGroupExempt__c] [varchar](255) NULL,
	[OrganizationExempt990Type__c] [varchar](100) NULL,
	[NTEE_Code__c] [varchar](100) NULL,
	[IsActive__c] [bit] NULL,
	[Email__c] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[Website] [varchar](2047) NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[Abbreviation__c] [varchar](100) NULL,
	[Acronym__c] [varchar](100) NULL,
	[FoundationType__c] [varchar](100) NULL,
	[PublicSupportTest__c] [varchar](100) NULL,
	[IntermediaryName__c] [varchar](255) NULL,
	[IntermediaryTaxID__c] [varchar](50) NULL,
	[IntermediaryEstablishedDate__c] [datetime] NULL,
	[VetEntityType__c] [varchar](100) NULL,
	[VetEntityExpenditureResponsibilityRequir__c] [bit] NULL,
	[VetEntityIntlDueDiligenceType__c] [varchar](100) NULL,
	[VetEntityIntlHasMasterGrantAgreement__c] [bit] NULL,
	[VetEntityIntlMasterGrantAgreementDate__c] [datetime] NULL,
	[GranteeIsRegisteredForAchViaUnionBank__c] [bit] NULL,
	[GranteeRegisteredForAchViaUnionBankDate__c] [datetime] NULL,
	[GranteeValidRecipientStartDate__c] [datetime] NULL,
	[GranteeValidRecipientEndDate__c] [datetime] NULL,
	[GranteeIsValidPayee__c] [bit] NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[Constituent_Eligible_for_Grants__c] [varchar](100) NULL,
	[Constituent_Type_for_Gifts_Reporting__c] [varchar](100) NULL,
	[Fiscal_Sponsor__c] [varchar](50) NULL,
	[FXExecute_Wire_Confirmation__c] [varchar](50) NULL,
	[Hate_Group_SPLC__c] [varchar](50) NULL,
	[India_FCRA_Number__c] [varchar](50) NULL,
	[India_IPAN__c] [varchar](50) NULL,
	[India_SR_Number__c] [varchar](50) NULL,
	[Indian_Org_Type__c] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_AccountUpdate]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_AccountUpdate](
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[ID] [nvarchar](18) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Activity]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Activity](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[ActivityDate] [datetime] NULL,
	[Campaign_Description__c] [varchar](100) NULL,
	[Type] [smallint] NULL,
	[Status] [varchar](100) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Subject] [varchar](255) NULL,
	[Notes_Description__c] [varchar](255) NULL,
	[Description] [varchar](max) NULL,
	[TaskSubType] [varchar](4) NULL,
	[WhatId] [nvarchar](18) NULL,
	[WhoId] [nvarchar](18) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[ActivityType__c] [varchar](100) NULL,
	[CreatedbyId] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Address]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Address](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[npsp__Household_Account__c] [nvarchar](1300) NULL,
	[AddressSystemID__C] [int] NULL,
	[npsp__Address_Type__c] [varchar](100) NULL,
	[npsp__Default_Address__c] [bit] NULL,
	[npsp__MailingCity__c] [varchar](100) NULL,
	[npsp__MailingCountry__c] [varchar](100) NULL,
	[npsp__MailingPostalCode__c] [varchar](12) NULL,
	[npsp__MailingState__c] [varchar](3) NULL,
	[npsp__MailingStreet__c] [varchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Affiliation]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Affiliation](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[ExternalID__c] [int] NULL,
	[npe5__Contact__c] [nvarchar](18) NULL,
	[npe5__Organization__c] [nvarchar](1300) NULL,
	[ContactRelationshipToOrganization__c] [varchar](100) NULL,
	[OrganizationRelationshipToContact__c] [varchar](100) NULL,
	[npe5__StartDate__c] [varchar](10) NULL,
	[npe5__EndDate__c] [varchar](10) NULL,
	[npe5__Primary__c] [bit] NULL,
	[npe5__Role__c] [varchar](50) NULL,
	[npe5__Description__c] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Case]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Case](
	[CharacteristicId__C] [int] NULL,
	[Grant__c] [nvarchar](18) NULL,
	[CharacteristicsName__c] [varchar](255) NULL,
	[Subject] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_FundRole]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_FundRole](
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL,
	[ExternalId__c] [int] NULL,
	[Fund__c] [varchar](100) NULL,
	[Contact__c] [nvarchar](18) NULL,
	[Role__c] [varchar](100) NULL,
	[RelationshipsToFund__c] [nvarchar](max) NULL,
	[Active__c] [bit] NULL,
	[IsCombined__c] [bit] NULL,
	[StatementDeliveryMethod__c] [varchar](100) NULL,
	[Grant_Acknowledgement__c] [bit] NULL,
	[Grant_Recognition_Name__c] [varchar](255) NULL,
	[Description__c] [varchar](max) NULL,
	[EndDate__c] [varchar](10) NULL,
	[StartDate__c] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_GrantBill]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_GrantBill](
	[Grant__c] [nvarchar](18) NULL,
	[PaymentId__c] [int] NULL,
	[Payment_Number__c] [int] NULL,
	[Issue_Number__c] [int] NULL,
	[Scheduled_Date__c] [datetime] NULL,
	[Check_Date__c] [datetime] NULL,
	[Void_Date__c] [datetime] NULL,
	[Status__c] [nvarchar](50) NULL,
	[Amount__c] [numeric](20, 2) NULL,
	[Adjusted_Payment_Amount__c] [numeric](20, 2) NULL,
	[Check_Reference_Number__c] [nvarchar](50) NULL,
	[HistoricFEInvoiceID__c] [int] NULL,
	[HistoricInvoiceDescription__c] [nvarchar](50) NULL,
	[Bank__c] [nvarchar](18) NULL,
	[Exported_Flag__c] [int] NULL,
	[Locked_Flag__c] [int] NULL,
	[GE_Batch_ID__c] [int] NULL,
	[GE_Batch_Date_Created__c] [datetime] NULL,
	[GE_Batch_Date_Closed__c] [datetime] NULL,
	[GE_Batch_Description__c] [nvarchar](255) NULL,
	[GE_Batch_Status__c] [nvarchar](9) NULL,
	[GE_Batch_Invoiced_By__c] [nvarchar](255) NULL,
	[GE_Batch_Printed_By__c] [nvarchar](255) NULL,
	[GE_Batch_Post_Date__c] [datetime] NULL,
	[GE_Batch_Post_By__c] [nvarchar](255) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_GrantReporting]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_GrantReporting](
	[Grant__c] [nvarchar](18) NULL,
	[Report_Type__c] [varchar](16) NULL,
	[Due_Date__c] [date] NULL,
	[Submitted_Date__c] [date] NULL,
	[Approved_Date__c] [date] NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Grants_Backup]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Grants_Backup](
	[Grant_ID__c] [int] NULL,
	[Grant_Number__c] [nvarchar](255) NULL,
	[Historic_Grant_Type__c] [nvarchar](4) NULL,
	[Historic_Full_Grant_Type__c] [nvarchar](308) NULL,
	[RecordTypeID] [nvarchar](18) NULL,
	[Status__c] [nvarchar](50) NULL,
	[Historic_Created_Date__c] [datetime] NULL,
	[Date_Submitted__c] [datetime] NULL,
	[Approved_Date__c] [datetime] NULL,
	[Grant_Purpose_Comments__c] [varchar](255) NULL,
	[Special_Instructions__c] [varchar](255) NULL,
	[Number_of_Payments__c] [int] NULL,
	[Amount__c] [numeric](20, 2) NULL,
	[Adjusted_Amount__c] [numeric](20, 2) NULL,
	[Grant_Anonymous__c] [varchar](5) NULL,
	[FundInd__c] [varchar](8) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Recipient__c] [nvarchar](18) NULL,
	[Recipient_Contact__c] [nvarchar](18) NULL,
	[Recipient_Salutation__c] [nvarchar](255) NULL,
	[Recipient_Mailing_Address_Historic__c] [nvarchar](255) NULL,
	[Recipient_Valid_Through_Date__c] [datetime] NULL,
	[Payee_Org_ID__c] [int] NULL,
	[Payee_Organization__c] [nvarchar](18) NULL,
	[Payee_Contact__c] [nvarchar](18) NULL,
	[Payee_Salutation__c] [nvarchar](255) NULL,
	[Payee_Address__c] [nvarchar](1025) NULL,
	[Program_Manager__c] [nvarchar](18) NULL,
	[Anonymous_Fund__c] [varchar](5) NULL,
	[Recipient_Fund__c] [nvarchar](18) NULL,
	[Grant_Contact_Method__c] [nvarchar](50) NULL,
	[Anonymous_Fund_Advisor__c] [varchar](5) NULL,
	[Anticipated_Outcomes__c] [nvarchar](255) NULL,
	[CC1_Name__c] [nvarchar](255) NULL,
	[CC1_Email__c] [nvarchar](255) NULL,
	[CC2_Name__c] [nvarchar](255) NULL,
	[CC2_Email__c] [nvarchar](255) NULL,
	[Grant_Period_Start_Date__c] [date] NULL,
	[Grant_Period_End_Date__c] [date] NULL,
	[Grant_Recommendation_Agreement__c] [varchar](5) NULL,
	[Grant_Agreement_Received_Date__c] [date] NULL,
	[CC3_Email__c] [nvarchar](255) NULL,
	[CC4_Name__c] [nvarchar](255) NULL,
	[CC4_Email__c] [nvarchar](255) NULL,
	[Service_Area__c] [nvarchar](255) NULL,
	[Grant_Strategy__c] [nvarchar](255) NULL,
	[Conditions__c] [nvarchar](255) NULL,
	[Special_Accounting_Instruction__c] [nvarchar](255) NULL,
	[Conditional_Grant__c] [varchar](5) NULL,
	[CAFProposalFocusArea__c] [nvarchar](255) NULL,
	[Decline_Comments__c] [nvarchar](255) NULL,
	[Department__c] [nvarchar](255) NULL,
	[Due_Diligence_Type__c] [nvarchar](255) NULL,
	[CAFProposalGeoArea__c] [nvarchar](255) NULL,
	[Historic_T_code__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team__c] [nvarchar](255) NULL,
	[eBay_GIVE_Team_Employee__c] [nvarchar](255) NULL,
	[CiscoCyberGrantsProposalID__c] [nvarchar](255) NULL,
	[Historic_CAF_Focus_Area__c] [nvarchar](255) NULL,
	[Historic_CAF_Geographic_Area__c] [nvarchar](255) NULL,
	[Standard_Grant__c] [varchar](5) NULL,
	[Expedited__c] [varchar](5) NULL,
	[PayPalGrantType__c] [nvarchar](255) NULL,
	[BCC1_Name__c] [nvarchar](255) NULL,
	[BCC1_Email__c] [nvarchar](255) NULL,
	[BCC2_Name__c] [nvarchar](255) NULL,
	[BCC2_Email__c] [nvarchar](255) NULL,
	[GlobalCharityDatabase__c] [varchar](5) NULL,
	[Recoverable_Grant__c] [varchar](5) NULL,
	[Expected_Recoverable_Return_Date__c] [date] NULL,
	[Historic_RecognitionName__c] [varchar](255) NULL,
	[Historic_Ack_Constituent__c] [nvarchar](255) NULL,
	[Historic_Ack_CC_Name__c] [nvarchar](1023) NULL,
	[Lobbying_Reporting__c] [nvarchar](255) NULL,
	[Grassroot_Amount__c] [nvarchar](255) NULL,
	[Direct_Amount__c] [nvarchar](255) NULL,
	[Adj_Grassroot_Amount__c] [nvarchar](255) NULL,
	[Adj_Direct_Amount__c] [nvarchar](255) NULL,
	[Recurring_Grant__c] [nvarchar](18) NULL,
	[Historic_Parent_Grant_Request__c] [int] NULL,
	[Historic_Parent_Proposal__c] [nvarchar](18) NULL,
	[Historic_Parent_Scholarship__c] [int] NULL,
	[Historic_Schol_Year_Attending__c] [nvarchar](4) NULL,
	[Historic_Schol_Student_ID__c] [nvarchar](255) NULL,
	[Historic_Schol_First_Name__c] [varchar](50) NULL,
	[Historic_Schol_Last_Name__c] [varchar](100) NULL,
	[Historic_Schol_Salutation__c] [nvarchar](255) NULL,
	[Historic_Schol_Academic_Year__c] [nvarchar](9) NULL,
	[Historic_Schol_Enrollment_Status__c] [nvarchar](255) NULL,
	[Historic_Schol_Student_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_School_Verification__c] [nvarchar](255) NULL,
	[Historic_Schol_Disbursement__c] [nvarchar](255) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Opportunity]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Opportunity](
	[Account_City__c] [nvarchar](1300) NULL,
	[Account_Country__c] [nvarchar](1300) NULL,
	[Account_State__c] [nvarchar](1300) NULL,
	[Account_Street__c] [nvarchar](1300) NULL,
	[Account_Zip__c] [nvarchar](1300) NULL,
	[AccountId] [nvarchar](18) NULL,
	[Acknowledge_as_Combined__c] [bit] NULL,
	[Acknowledgement_Address__c] [nvarchar](255) NULL,
	[Acknowledgement_Mixed_Gift_Value__c] [nvarchar](1300) NULL,
	[Acknowledgement_Title__c] [nvarchar](255) NULL,
	[Acknowledgment_Email__c] [nvarchar](80) NULL,
	[Acknowledgment_Full_Name__c] [nvarchar](255) NULL,
	[Acknowledgment_Letter_Code__c] [nvarchar](4000) NULL,
	[Acknowledgment_Salutation__c] [nvarchar](255) NULL,
	[Agent_Commission__c] [float] NULL,
	[Agreement_Date__c] [date] NULL,
	[Alfavantage_Error_Message__c] [nvarchar](max) NULL,
	[Amount] [float] NULL,
	[Amount_Remaining_for_Fulfillment__c] [float] NULL,
	[Amount_Text__c] [nvarchar](1300) NULL,
	[Annuitant_1__c] [nvarchar](18) NULL,
	[Annuitant_2__c] [nvarchar](18) NULL,
	[Annuity_Rate__c] [float] NULL,
	[Annuity_Type__c] [nvarchar](4000) NULL,
	[AnnuityType__c] [nvarchar](4000) NULL,
	[Anonymous__c] [bit] NULL,
	[Approval_Documents_Uploaded__c] [bit] NULL,
	[Approval_Status__c] [nvarchar](4000) NULL,
	[Asset_Description__c] [nvarchar](max) NULL,
	[Asset_Name__c] [nvarchar](255) NULL,
	[Asset_Symbol__c] [nvarchar](50) NULL,
	[Asset_Type__c] [nvarchar](4000) NULL,
	[AssetSubType__c] [nvarchar](4000) NULL,
	[Bank__c] [nvarchar](18) NULL,
	[Batch_ID_Custom_Formula__c] [nvarchar](1300) NULL,
	[Batch_Name_Custom_Formula__c] [nvarchar](1300) NULL,
	[Benefit_Detail__c] [nvarchar](4000) NULL,
	[Benefit_Value__c] [float] NULL,
	[Brokerage_Firm__c] [nvarchar](4000) NULL,
	[Brokerage_Liquidation_Service__c] [nvarchar](18) NULL,
	[CampaignId] [nvarchar](18) NULL,
	[Captured_Charge_Count__c] [float] NULL,
	[Captured_Charges__c] [float] NULL,
	[Captured_Transfer_Count__c] [float] NULL,
	[Captured_Transfers__c] [float] NULL,
	[Charitable_Amount__c] [float] NULL,
	[Close_Value__c] [float] NULL,
	[CloseDate] [date] NULL,
	[Completed_Payout_Count__c] [float] NULL,
	[Completed_Payouts__c] [float] NULL,
	[Contact_Contituent_Id__c] [nvarchar](1300) NULL,
	[Contact_ID__c] [nvarchar](1300) NULL,
	[ContactId] [nvarchar](18) NULL,
	[ContractId] [nvarchar](18) NULL,
	[Cost_Center__c] [nvarchar](18) NULL,
	[Count_of_Fulfillments_to_Pledges__c] [float] NULL,
	[Created_From_Paypal__c] [bit] NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NULL,
	[Credit_Account__c] [nvarchar](18) NULL,
	[Custodian__c] [nvarchar](18) NULL,
	[Debit_Account__c] [nvarchar](18) NULL,
	[Description] [nvarchar](max) NULL,
	[Divest_by_Date__c] [date] NULL,
	[Docgen_Output_File_Name__c] [nvarchar](255) NULL,
	[Donation_Type__c] [nvarchar](1300) NULL,
	[Donor_Annuitant__c] [nvarchar](4000) NULL,
	[Donor_ID__c] [nvarchar](1300) NULL,
	[Establishing_Gift_to_Fund__c] [bit] NULL,
	[Excess_Business_Holdings__c] [bit] NULL,
	[ExpectedRevenue] [float] NULL,
	[External_Fund__c] [nvarchar](80) NULL,
	[Fair_Market_Value_Detail__c] [nvarchar](4000) NULL,
	[Fees__c] [float] NULL,
	[First_Payment_Date__c] [date] NULL,
	[First_Sale_Date__c] [date] NULL,
	[Fiscal] [nvarchar](6) NULL,
	[FiscalQuarter] [int] NULL,
	[FiscalYear] [int] NULL,
	[ForecastCategory] [nvarchar](4000) NULL,
	[ForecastCategoryName] [nvarchar](4000) NULL,
	[Fund__c] [nvarchar](18) NULL,
	[Fund_Name__c] [nvarchar](1300) NULL,
	[Fund_Type__c] [nvarchar](1300) NULL,
	[GAC_Approval__c] [nvarchar](4000) NULL,
	[Gift_Amount__c] [float] NULL,
	[Gift_ID__c] [nvarchar](80) NULL,
	[Gift_Status__c] [nvarchar](1300) NULL,
	[GiftPostDate__c] [date] NULL,
	[GiftPostStatus__c] [nvarchar](4000) NULL,
	[GiftReference__c] [nvarchar](255) NULL,
	[GiftSubType__c] [nvarchar](4000) NULL,
	[GiftSystemID__c] [nvarchar](255) NULL,
	[HasOpenActivity] [bit] NULL,
	[HasOpportunityLineItem] [bit] NULL,
	[HasOverdueTask] [bit] NULL,
	[High_Value__c] [float] NULL,
	[Id] [nvarchar](18) NULL,
	[IFT_Grant_Cost_Center__c] [nvarchar](18) NULL,
	[IFT_Grant_Name__c] [nvarchar](80) NULL,
	[Initial_Value__c] [float] NULL,
	[Interfund_Grant_Bill_Number__c] [nvarchar](80) NULL,
	[Interfund_Transfer_Fund__c] [nvarchar](18) NULL,
	[IRS_Discount_Rate__c] [float] NULL,
	[Is_Grant__c] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[IsFirstGiftFromNewDonor__c] [bit] NULL,
	[IsPrivate] [bit] NULL,
	[IsWon] [bit] NULL,
	[Jitterbit_Run_Date__c] [datetime] NULL,
	[LastActivityDate] [date] NULL,
	[LastAmountChangedHistoryId] [nvarchar](18) NULL,
	[LastCloseDateChangedHistoryId] [nvarchar](18) NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastStageChangeDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[LeadSource] [nvarchar](4000) NULL,
	[LetterSigner__c] [nvarchar](4000) NULL,
	[Liability_Value_with_Donor_s_Contract__c] [float] NULL,
	[Liability_Value_with_Partner_NonProfit__c] [float] NULL,
	[Low_Value__c] [float] NULL,
	[Mean_Value__c] [float] NULL,
	[Measuring_Life_Lives__c] [nvarchar](18) NULL,
	[Median_Value__c] [float] NULL,
	[Most_Recent_Appraisal_Date__c] [date] NULL,
	[Most_Recent_Appraisal_Value__c] [float] NULL,
	[Name] [nvarchar](120) NULL,
	[NextStep] [nvarchar](255) NULL,
	[Nintex_Address__c] [nvarchar](1300) NULL,
	[Nintex_Email__c] [nvarchar](1300) NULL,
	[Nintex_Full_Name__c] [nvarchar](1300) NULL,
	[Nintex_Name__c] [nvarchar](1300) NULL,
	[Nintex_Salutation__c] [nvarchar](1300) NULL,
	[Non_Charitable_Amount__c] [float] NULL,
	[Not_Pledge_Related__c] [bit] NULL,
	[npe01__Amount_Outstanding__c] [float] NULL,
	[npe01__Amount_Written_Off__c] [float] NULL,
	[npe01__Contact_Id_for_Role__c] [nvarchar](255) NULL,
	[npe01__Do_Not_Automatically_Create_Payment__c] [bit] NULL,
	[npe01__Is_Opp_From_Individual__c] [nvarchar](1300) NULL,
	[npe01__Member_Level__c] [nvarchar](4000) NULL,
	[npe01__Membership_End_Date__c] [date] NULL,
	[npe01__Membership_Origin__c] [nvarchar](4000) NULL,
	[npe01__Membership_Start_Date__c] [date] NULL,
	[npe01__Number_of_Payments__c] [float] NULL,
	[npe01__Payments_Made__c] [float] NULL,
	[npe03__Recurring_Donation__c] [nvarchar](18) NULL,
	[npo02__CombinedRollupFieldset__c] [nvarchar](1300) NULL,
	[npo02__systemHouseholdContactRoleProcessor__c] [nvarchar](4000) NULL,
	[npsp__Acknowledgment_Date__c] [date] NULL,
	[npsp__Acknowledgment_Status__c] [nvarchar](4000) NULL,
	[npsp__Ask_Date__c] [date] NULL,
	[npsp__Batch__c] [nvarchar](18) NULL,
	[npsp__Batch_Number__c] [nvarchar](30) NULL,
	[npsp__Closed_Lost_Reason__c] [nvarchar](max) NULL,
	[npsp__DisableContactRoleAutomation__c] [bit] NULL,
	[npsp__Fair_Market_Value__c] [float] NULL,
	[npsp__Gift_Strategy__c] [nvarchar](4000) NULL,
	[npsp__Grant_Contract_Date__c] [date] NULL,
	[npsp__Grant_Contract_Number__c] [nvarchar](255) NULL,
	[npsp__Grant_Period_End_Date__c] [date] NULL,
	[npsp__Grant_Period_Start_Date__c] [date] NULL,
	[npsp__Grant_Program_Area_s__c] [nvarchar](255) NULL,
	[npsp__Grant_Requirements_Website__c] [nvarchar](255) NULL,
	[npsp__Honoree_Contact__c] [nvarchar](18) NULL,
	[npsp__Honoree_Information__c] [nvarchar](max) NULL,
	[npsp__Honoree_Name__c] [nvarchar](255) NULL,
	[npsp__In_Kind_Description__c] [nvarchar](max) NULL,
	[npsp__In_Kind_Donor_Declared_Value__c] [bit] NULL,
	[npsp__In_Kind_Type__c] [nvarchar](4000) NULL,
	[npsp__Is_Grant_Renewal__c] [bit] NULL,
	[npsp__Matching_Gift__c] [nvarchar](18) NULL,
	[npsp__Matching_Gift_Account__c] [nvarchar](18) NULL,
	[npsp__Matching_Gift_Employer__c] [nvarchar](255) NULL,
	[npsp__Matching_Gift_Status__c] [nvarchar](4000) NULL,
	[npsp__Next_Grant_Deadline_Due_Date__c] [date] NULL,
	[npsp__Notification_Message__c] [nvarchar](max) NULL,
	[npsp__Notification_Preference__c] [nvarchar](4000) NULL,
	[npsp__Notification_Recipient_Contact__c] [nvarchar](18) NULL,
	[npsp__Notification_Recipient_Email__c] [nvarchar](80) NULL,
	[npsp__Notification_Recipient_Information__c] [nvarchar](255) NULL,
	[npsp__Notification_Recipient_Name__c] [nvarchar](255) NULL,
	[npsp__Previous_Grant_Opportunity__c] [nvarchar](18) NULL,
	[npsp__Primary_Contact__c] [nvarchar](18) NULL,
	[npsp__Primary_Contact_Campaign_Member_Status__c] [nvarchar](40) NULL,
	[npsp__Recurring_Donation_Installment_Name__c] [nvarchar](1300) NULL,
	[npsp__Recurring_Donation_Installment_Number__c] [float] NULL,
	[npsp__Requested_Amount__c] [float] NULL,
	[npsp__Tribute_Notification_Date__c] [date] NULL,
	[npsp__Tribute_Notification_Status__c] [nvarchar](4000) NULL,
	[npsp__Tribute_Type__c] [nvarchar](4000) NULL,
	[Num_Of_Units_Formula__c] [float] NULL,
	[Number_of_Units__c] [float] NULL,
	[Number_of_Units_Text__c] [nvarchar](18) NULL,
	[Open_Charge_Count__c] [float] NULL,
	[Open_Charges__c] [float] NULL,
	[Open_Commitments_and_Liabilities__c] [bit] NULL,
	[Open_Payout_Count__c] [float] NULL,
	[Open_Payouts__c] [float] NULL,
	[Open_Transfer_Count__c] [float] NULL,
	[Open_Transfers__c] [float] NULL,
	[Open_Value__c] [float] NULL,
	[OrgDonor__c] [bit] NULL,
	[Other_Fair_Market_Value_Detail__c] [nvarchar](255) NULL,
	[Outstanding_Pledged_Amount__c] [float] NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Partially_Restricted__c] [nvarchar](4000) NULL,
	[Payment_Date__c] [date] NULL,
	[Payment_Issuer__c] [nvarchar](4000) NULL,
	[Payment_Method__c] [nvarchar](4000) NULL,
	[Payment_Number__c] [nvarchar](255) NULL,
	[Payment_Schedule__c] [nvarchar](4000) NULL,
	[Paypal_Item_Description__c] [nvarchar](max) NULL,
	[Percentage_Interest__c] [nvarchar](10) NULL,
	[Percentage_Retained_by_SVCF__c] [float] NULL,
	[Percentage_To_Be_Granted_Out__c] [float] NULL,
	[Pledge__c] [nvarchar](18) NULL,
	[Pledge_Paid__c] [bit] NULL,
	[Pledge_Summary__c] [nvarchar](1300) NULL,
	[Pledge_Write_Off_Reason__c] [nvarchar](255) NULL,
	[PP_TransactionId__c] [nvarchar](25) NULL,
	[Pricebook2Id] [nvarchar](18) NULL,
	[Primary_Contact_Email__c] [bit] NULL,
	[Pro_Rated_First_Payment_Amount__c] [float] NULL,
	[Probability] [float] NULL,
	[Property_Address__c] [nvarchar](255) NULL,
	[Property_Type__c] [nvarchar](4000) NULL,
	[Proposal__c] [nvarchar](18) NULL,
	[PushCount] [int] NULL,
	[Qualified_Charitable_Distribution__c] [bit] NULL,
	[Receipt_Preference__c] [nvarchar](4000) NULL,
	[RecordTypeId] [nvarchar](18) NULL,
	[Reference__c] [nvarchar](18) NULL,
	[Referring_Contact__c] [nvarchar](18) NULL,
	[Referring_Organization__c] [nvarchar](18) NULL,
	[Refunded_Charge_Count__c] [float] NULL,
	[Refunded_Charges__c] [float] NULL,
	[Required_Sales_Plan__c] [bit] NULL,
	[Restriction__c] [nvarchar](18) NULL,
	[Restriction_Notes__c] [nvarchar](255) NULL,
	[Restriction_Reason__c] [nvarchar](255) NULL,
	[Retained_Charge_Count__c] [float] NULL,
	[Retained_Charges__c] [float] NULL,
	[Retained_Transfer_Count__c] [float] NULL,
	[Retained_Transfers__c] [float] NULL,
	[Reversed_Transfer_Count__c] [float] NULL,
	[Reversed_Transfers__c] [float] NULL,
	[Sale_Date__c] [date] NULL,
	[Sales_Plan__c] [nvarchar](4000) NULL,
	[Sales_Plan_Complete__c] [bit] NULL,
	[Sales_Plan_Summary__c] [nvarchar](1000) NULL,
	[Sold_Value__c] [float] NULL,
	[Source_Fund__c] [nvarchar](18) NULL,
	[Source_Fund1__c] [nvarchar](255) NULL,
	[StageName] [nvarchar](4000) NULL,
	[Stock_Property_Detail__c] [nvarchar](4000) NULL,
	[Stock_Restriction__c] [bit] NULL,
	[StockPropertyWasSold__c] [bit] NULL,
	[Sum_of_Fulfillments_to_Pledges__c] [float] NULL,
	[Sum_of_Gifts__c] [float] NULL,
	[SVCF_Data_Import_Batch__c] [nvarchar](18) NULL,
	[Sync_Date__c] [date] NULL,
	[SystemModstamp] [datetime] NULL,
	[Tax_ID__c] [nvarchar](255) NULL,
	[Term_of_Years__c] [float] NULL,
	[Total_Gift_Contribution_Amount__c] [float] NULL,
	[Total_Gifts_from_This_Pledge__c] [float] NULL,
	[TotalOpportunityQuantity] [float] NULL,
	[Transfer_Date__c] [date] NULL,
	[Type] [nvarchar](4000) NULL,
	[Underlying_Asset_Description__c] [nvarchar](max) NULL,
	[Underlying_Asset_Name__c] [nvarchar](255) NULL,
	[Units_Sold__c] [float] NULL,
	[Units_Unsold__c] [float] NULL,
	[Unrelated_Business_Income__c] [bit] NULL,
	[Unrelated_Business_Income_Details__c] [nvarchar](255) NULL,
	[Unrelated_Business_Income_Tax__c] [bit] NULL,
	[Valuation_Contact__c] [nvarchar](18) NULL,
	[Value_of_Asset_Portion__c] [float] NULL,
	[Vehicle__c] [nvarchar](4000) NULL,
	[Who_is_managing_the_sales_plan__c] [nvarchar](18) NULL,
	[X8282_Filing_Completed__c] [nvarchar](4000) NULL,
	[X8282_Required__c] [nvarchar](4000) NULL,
	[X8283_Form_Check__c] [bit] NULL,
	[X8283_Signed_Date__c] [date] NULL,
	[X8283_Signee__c] [nvarchar](18) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_PrimaryContact]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_PrimaryContact](
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[Nickname__c] [varchar](50) NULL,
	[MaidenName__c] [varchar](100) NULL,
	[Salutation] [varchar](100) NULL,
	[Suffix] [varchar](100) NULL,
	[MaritalStatus__c] [varchar](100) NULL,
	[Gender__c] [varchar](100) NULL,
	[npsp__Deceased__c] [bit] NULL,
	[IsActive__c] [bit] NULL,
	[IsStaff__c] [bit] NULL,
	[Email] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[MobilePhone] [varchar](2047) NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[npe01__WorkEmail__c] [varchar](2047) NULL,
	[DoNotShareEmailBusiness__c] [bit] NULL,
	[npe01__WorkPhone__c] [varchar](2047) NULL,
	[DoNotShareDirectBusinessPhone__c] [bit] NULL,
	[OtherPhone] [varchar](2047) NULL,
	[DoNotShareMainBusinessPhone__c] [bit] NULL,
	[WebsiteBusiness__c] [varchar](2047) NULL,
	[AnonymousForGifts__c] [bit] NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[ProfessionalAdvisorRating__c] [varchar](100) NULL,
	[Professional_Advisor_Type__c] [nvarchar](max) NULL,
	[Title] [varchar](50) NULL,
	[Website__c] [varchar](2047) NULL,
	[DeceasedDate__c] [varchar](10) NULL,
	[BirthDate] [varchar](10) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Relationship]    Script Date: 6/30/2022 1:44:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Relationship](
	[ExternalID__c] [nvarchar](37) NULL,
	[npe4__Contact__c] [nvarchar](18) NULL,
	[npe4__RelatedContact__c] [nvarchar](18) NULL,
	[npe4__Type__c] [nvarchar](100) NULL,
	[npe4__Status__c] [bit] NULL,
	[Start_Date__c] [varchar](10) NULL,
	[End_Date__c] [varchar](10) NULL,
	[npe4__Description__c] [varchar](max) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_Relationship2]    Script Date: 6/30/2022 1:44:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_Relationship2](
	[ExternalID__c] [nvarchar](37) NULL,
	[npe4__Contact__c] [nvarchar](18) NULL,
	[npe4__RelatedContact__c] [nvarchar](18) NULL,
	[npe4__Type__c] [nvarchar](100) NULL,
	[npe4__Status__c] [bit] NULL,
	[Start_Date__c] [varchar](10) NULL,
	[End_Date__c] [varchar](10) NULL,
	[npe4__Description__c] [varchar](max) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Succ_SecondaryContact]    Script Date: 6/30/2022 1:44:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Succ_SecondaryContact](
	[AccountID] [nvarchar](18) NULL,
	[ConstituentSystemID__c] [int] NULL,
	[ConstituentID__c] [varchar](20) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[Nickname__c] [varchar](50) NULL,
	[MaidenName__c] [varchar](100) NULL,
	[Salutation] [varchar](100) NULL,
	[Suffix] [varchar](100) NULL,
	[MaritalStatus__c] [varchar](100) NULL,
	[Gender__c] [varchar](100) NULL,
	[BirthDate] [varchar](10) NULL,
	[npsp__Deceased__c] [bit] NULL,
	[DeceasedDate__c] [varchar](10) NULL,
	[IsActive__c] [bit] NULL,
	[IsStaff__c] [bit] NULL,
	[Email] [varchar](1000) NULL,
	[DoNotShareEmailPreferred__c] [bit] NULL,
	[MobilePhone] [varchar](2047) NULL,
	[DoNotShareCellPhone__c] [bit] NULL,
	[Phone] [varchar](2047) NULL,
	[DoNotShareHomePhone__c] [bit] NULL,
	[Website__c] [varchar](2047) NULL,
	[npe01__WorkEmail__c] [varchar](1000) NULL,
	[DoNotShareEmailBusiness__c] [bit] NULL,
	[npe01__WorkPhone__c] [varchar](2047) NULL,
	[DoNotShareDirectBusinessPhone__c] [bit] NULL,
	[OtherPhone] [varchar](2047) NULL,
	[DoNotShareMainBusinessPhone__c] [bit] NULL,
	[WebsiteBusiness__c] [varchar](2047) NULL,
	[AnonymousForGifts__c] [bit] NULL,
	[ReportTypeForGifts__c] [varchar](100) NULL,
	[ProfessionalAdvisorRating__c] [varchar](100) NULL,
	[Professional_Advisor_Type__c] [nvarchar](max) NULL,
	[Title] [varchar](50) NULL,
	[SalesforceRecordId] [nvarchar](18) NULL,
	[IsNew] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_GRANTRecepientUpdatePartial]    Script Date: 6/30/2022 1:44:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_GRANTRecepientUpdatePartial](
	[Grant_ID__c] [int] NOT NULL,
	[Recipient__c] [nvarchar](18) NULL,
	[Recipient_Contact__c] [nvarchar](18) NULL
) ON [PRIMARY]
GO
