USE [master]
GO
/****** Object:  Database [Netsuite_Staging]    Script Date: 8/20/2022 3:57:21 AM ******/
CREATE DATABASE [Netsuite_Staging]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Netsuite_Staging', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Netsuite_Staging.mdf' , SIZE = 3809280KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Netsuite_Staging_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Netsuite_Staging_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Netsuite_Staging] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Netsuite_Staging].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Netsuite_Staging] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET ARITHABORT OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Netsuite_Staging] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Netsuite_Staging] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Netsuite_Staging] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Netsuite_Staging] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Netsuite_Staging] SET  MULTI_USER 
GO
ALTER DATABASE [Netsuite_Staging] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Netsuite_Staging] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Netsuite_Staging] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Netsuite_Staging] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Netsuite_Staging] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Netsuite_Staging] SET QUERY_STORE = OFF
GO
USE [Netsuite_Staging]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\prajakta]    Script Date: 8/20/2022 3:57:22 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\prajakta] FOR LOGIN [EC2AMAZ-4C784Q4\prajakta] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\opopova]    Script Date: 8/20/2022 3:57:22 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\opopova] FOR LOGIN [EC2AMAZ-4C784Q4\opopova] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\mma]    Script Date: 8/20/2022 3:57:22 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\mma] FOR LOGIN [EC2AMAZ-4C784Q4\mma] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\jagriti]    Script Date: 8/20/2022 3:57:22 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\jagriti] FOR LOGIN [EC2AMAZ-4C784Q4\jagriti] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\akanksha]    Script Date: 8/20/2022 3:57:22 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\akanksha] FOR LOGIN [EC2AMAZ-4C784Q4\akanksha] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [EC2AMAZ-4C784Q4\opopova]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [EC2AMAZ-4C784Q4\opopova]
GO
ALTER ROLE [db_owner] ADD MEMBER [EC2AMAZ-4C784Q4\mma]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [EC2AMAZ-4C784Q4\mma]
GO
ALTER ROLE [db_datareader] ADD MEMBER [EC2AMAZ-4C784Q4\mma]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [EC2AMAZ-4C784Q4\mma]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [EC2AMAZ-4C784Q4\mma]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [EC2AMAZ-4C784Q4\mma]
GO
/****** Object:  Table [dbo].[NS_Account]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_Account](
	[acctName] [nvarchar](255) NULL,
	[acctNumber] [nvarchar](255) NULL,
	[acctType] [nvarchar](255) NULL,
	[billableExpensesAcct.externalId] [nvarchar](255) NULL,
	[billableExpensesAcct.internalId] [nvarchar](255) NULL,
	[billableExpensesAcct.name] [nvarchar](255) NULL,
	[billableExpensesAcct.type] [nvarchar](255) NULL,
	[cashFlowRate] [nvarchar](255) NULL,
	[category1099misc.externalId] [nvarchar](255) NULL,
	[category1099misc.internalId] [nvarchar](255) NULL,
	[category1099misc.name] [nvarchar](255) NULL,
	[category1099misc.type] [nvarchar](255) NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[curDocNum] [bigint] NULL,
	[currency.externalId] [nvarchar](255) NULL,
	[currency.internalId] [nvarchar](255) NULL,
	[currency.name] [nvarchar](255) NULL,
	[currency.type] [nvarchar](255) NULL,
	[deferralAcct.externalId] [nvarchar](255) NULL,
	[deferralAcct.internalId] [nvarchar](255) NULL,
	[deferralAcct.name] [nvarchar](255) NULL,
	[deferralAcct.type] [nvarchar](255) NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[description] [nvarchar](4000) NULL,
	[eliminate] [bit] NULL,
	[exchangeRate] [nvarchar](255) NULL,
	[externalId] [nvarchar](255) NULL,
	[generalRate] [nvarchar](255) NULL,
	[includeChildren] [bit] NULL,
	[internalId] [nvarchar](255) NULL,
	[inventory] [bit] NULL,
	[isInactive] [bit] NULL,
	[legalName] [nvarchar](255) NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[openingBalance] [float] NULL,
	[parent.externalId] [nvarchar](255) NULL,
	[parent.internalId] [nvarchar](255) NULL,
	[parent.name] [nvarchar](255) NULL,
	[parent.type] [nvarchar](255) NULL,
	[revalue] [bit] NULL,
	[tranDate] [datetime] NULL,
	[unit.externalId] [nvarchar](255) NULL,
	[unit.internalId] [nvarchar](255) NULL,
	[unit.name] [nvarchar](255) NULL,
	[unit.type] [nvarchar](255) NULL,
	[unitsType.externalId] [nvarchar](255) NULL,
	[unitsType.internalId] [nvarchar](255) NULL,
	[unitsType.name] [nvarchar](255) NULL,
	[unitsType.type] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_Fund]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_Fund](
	[allowAttachments] [bit] NULL,
	[allowInlineEditing] [bit] NULL,
	[allowNumberingOverride] [bit] NULL,
	[allowQuickSearch] [bit] NULL,
	[altName] [nvarchar](255) NULL,
	[Automatic Hold Off] [bit] NULL,
	[autoName] [bit] NULL,
	[Calculated Spending limit for the year] [nvarchar](255) NULL,
	[Carryover from previous year] [nvarchar](255) NULL,
	[Cash Available to Grant Override Method] [nvarchar](255) NULL,
	[Cash Available to Grant Override Method.internalId] [nvarchar](255) NULL,
	[Client Segment] [nvarchar](255) NULL,
	[created] [datetime] NULL,
	[customForm.externalId] [nvarchar](255) NULL,
	[customForm.internalId] [nvarchar](255) NULL,
	[customForm.name] [nvarchar](255) NULL,
	[customForm.type] [nvarchar](255) NULL,
	[customRecordId] [nvarchar](255) NULL,
	[Default Grants Account] [nvarchar](255) NULL,
	[Default Grants Account.internalId] [nvarchar](255) NULL,
	[description] [nvarchar](4000) NULL,
	[disclaimer] [nvarchar](255) NULL,
	[enablEmailMerge] [bit] NULL,
	[enableNumbering] [bit] NULL,
	[Endowment Type] [nvarchar](255) NULL,
	[Established Date] [datetime] NULL,
	[externalId] [nvarchar](255) NULL,
	[Fee Schedule] [nvarchar](255) NULL,
	[Fee Schedule.internalId] [nvarchar](255) NULL,
	[Fund Code] [nvarchar](255) NULL,
	[Fund Family] [nvarchar](255) NULL,
	[Fund Family Segment] [nvarchar](255) NULL,
	[Fund Family Segment.internalId] [nvarchar](255) NULL,
	[Fund Family.internalId] [nvarchar](255) NULL,
	[Fund ID] [nvarchar](255) NULL,
	[Fund Restriction] [bit] NULL,
	[Fund Type] [nvarchar](255) NULL,
	[Fund Type List] [nvarchar](255) NULL,
	[Fund Type List.internalId] [nvarchar](255) NULL,
	[Fund Type.internalId] [nvarchar](255) NULL,
	[Has Spending Policy] [bit] NULL,
	[Hold Off] [bit] NULL,
	[IMF] [bit] NULL,
	[IMF Cash Target Policy (max)] [decimal](28, 0) NULL,
	[IMF Cash Target Policy (min)] [decimal](28, 0) NULL,
	[includeName] [bit] NULL,
	[internalId] [nvarchar](255) NULL,
	[Investment Activity - Last Month] [nvarchar](255) NULL,
	[Investment Activity - YTD] [nvarchar](255) NULL,
	[Investment Allocation] [nvarchar](255) NULL,
	[Investment Allocation.internalId] [nvarchar](255) NULL,
	[isAvailableOffline] [bit] NULL,
	[isInactive] [bit] NULL,
	[isNumberingUpdateable] [bit] NULL,
	[isOrdered] [bit] NULL,
	[Last updated date (Total Spending Limit)] [datetime] NULL,
	[lastModified] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[numberingCurrentNumber] [bigint] NULL,
	[numberingInit] [bigint] NULL,
	[numberingMinDigits] [bigint] NULL,
	[numberingPrefix] [nvarchar](255) NULL,
	[numberingSuffix] [nvarchar](255) NULL,
	[owner.externalId] [nvarchar](255) NULL,
	[owner.internalId] [nvarchar](255) NULL,
	[owner.name] [nvarchar](255) NULL,
	[owner.type] [nvarchar](255) NULL,
	[parent.externalId] [nvarchar](255) NULL,
	[parent.internalId] [nvarchar](255) NULL,
	[parent.name] [nvarchar](255) NULL,
	[parent.type] [nvarchar](255) NULL,
	[Principal Balance] [decimal](28, 0) NULL,
	[recordName] [nvarchar](255) NULL,
	[recType.externalId] [nvarchar](255) NULL,
	[recType.internalId] [nvarchar](255) NULL,
	[recType.name] [nvarchar](255) NULL,
	[recType.type] [nvarchar](255) NULL,
	[Salesforce Fund Id] [nvarchar](255) NULL,
	[scriptId] [nvarchar](255) NULL,
	[SF Sync Date] [datetime] NULL,
	[SF Sync Error] [nvarchar](255) NULL,
	[showCreationDate] [bit] NULL,
	[showId] [bit] NULL,
	[showLastModified] [bit] NULL,
	[showNotes] [bit] NULL,
	[showOwner] [bit] NULL,
	[showOwnerAllowChange] [bit] NULL,
	[Spending Policy] [nvarchar](255) NULL,
	[Spending Policy.internalId] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Sync to Salesforce] [bit] NULL,
	[System - Calculation Logs] [nvarchar](255) NULL,
	[System - Calculation Status] [nvarchar](255) NULL,
	[System - Calculation Status.internalId] [nvarchar](255) NULL,
	[Termination Date] [datetime] NULL,
	[Total Spending Limit for the year] [decimal](28, 0) NULL,
	[usePermissions] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Budget]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Budget] as
SELECT  distinct --top 10
	[GL7PROJECTBUDGETSID]
      ,[GL7ACCOUNTBUDGETSID]
      ,[AMOUNT]
     -- ,[GL7ACCOUNTSID],[ACCOUNTNUMBER]
	  ,[AccountDescription],acc1.internalId as AccountInterenalID,acc1.[acctType] as AccountType
	 -- ,[GL7FUNDSID]
	  ,[GL7PROJECTSID]
	  ,[PROJECTID],[ProjectDescription],f.internalId as FundInternalID   
      --,[GL7FISCALPERIODSID]
      ,[GL7PROJECTBUDGETDETAILSID]
      ,left(datename(month,a.[STARTDATE]),3)+' '+datename(year,a.[STARTDATE]) as BudgetPeriod
      ,[STARTDATE],[ENDDATE]
  FROM [FE_SVCF].[api].[GL7ProjectBudget]a
 -- left join [dbo].[NS_Account]acc on acc.acctNumber=convert(nvarchar,a.[GL7ACCOUNTSID])
  left join [dbo].[NS_Account]acc1 on trim(acc1.acctName)=trim(convert(nvarchar,a.[AccountDescription]))
  left join [dbo].[NS_Fund]f on f.name=a.[ProjectDescription] 
 -- where acc.internalId is not null --only 24 rows
 --where acc1.internalId is  null
 --ORDER BY A.[STARTDATE] DESC
GO
/****** Object:  View [dbo].[AccountMapping]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[AccountMapping] as
select  acc.acctName as NS_AccountName, acc.acctType as NS_AccountType
,* 
from [FE_SVCF].api.MapAccountCodes a
left join [Netsuite_Staging].[dbo].[NS_Account]acc on acc.[acctNumber]=a.netsuiteaccount
where NetSuiteAccount is not null
GO
/****** Object:  Table [dbo].[NS_JE_body]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_JE_body](
	[accountingBook.externalId] [nvarchar](255) NULL,
	[accountingBook.internalId] [nvarchar](255) NULL,
	[accountingBook.name] [nvarchar](255) NULL,
	[accountingBook.type] [nvarchar](255) NULL,
	[approved] [bit] NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[createdDate] [datetime] NULL,
	[createdFrom.externalId] [nvarchar](255) NULL,
	[createdFrom.internalId] [nvarchar](255) NULL,
	[createdFrom.name] [nvarchar](255) NULL,
	[createdFrom.type] [nvarchar](255) NULL,
	[currency.externalId] [nvarchar](255) NULL,
	[currency.internalId] [nvarchar](255) NULL,
	[currency.name] [nvarchar](255) NULL,
	[currency.type] [nvarchar](255) NULL,
	[customForm.externalId] [nvarchar](255) NULL,
	[customForm.internalId] [nvarchar](255) NULL,
	[customForm.name] [nvarchar](255) NULL,
	[customForm.type] [nvarchar](255) NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[exchangeRate] [float] NULL,
	[externalId] [nvarchar](255) NULL,
	[internalId] [nvarchar](255) NULL,
	[isBookSpecific] [bit] NULL,
	[lastModifiedDate] [datetime] NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[memo] [nvarchar](255) NULL,
	[nexus.externalId] [nvarchar](255) NULL,
	[nexus.internalId] [nvarchar](255) NULL,
	[nexus.name] [nvarchar](255) NULL,
	[nexus.type] [nvarchar](255) NULL,
	[parentExpenseAlloc.externalId] [nvarchar](255) NULL,
	[parentExpenseAlloc.internalId] [nvarchar](255) NULL,
	[parentExpenseAlloc.name] [nvarchar](255) NULL,
	[parentExpenseAlloc.type] [nvarchar](255) NULL,
	[postingPeriod.externalId] [nvarchar](255) NULL,
	[postingPeriod.internalId] [nvarchar](255) NULL,
	[postingPeriod.name] [nvarchar](255) NULL,
	[postingPeriod.type] [nvarchar](255) NULL,
	[reversalDate] [datetime] NULL,
	[reversalDefer] [bit] NULL,
	[reversalEntry] [nvarchar](255) NULL,
	[subsidiary.externalId] [nvarchar](255) NULL,
	[subsidiary.internalId] [nvarchar](255) NULL,
	[subsidiary.name] [nvarchar](255) NULL,
	[subsidiary.type] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.externalId] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.internalId] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.name] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.type] [nvarchar](255) NULL,
	[taxPointDate] [datetime] NULL,
	[toSubsidiary.externalId] [nvarchar](255) NULL,
	[toSubsidiary.internalId] [nvarchar](255) NULL,
	[toSubsidiary.name] [nvarchar](255) NULL,
	[toSubsidiary.type] [nvarchar](255) NULL,
	[tranDate] [datetime] NULL,
	[tranId] [nvarchar](255) NULL,
	[_custbody_atlas_no_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_no_hdn_id] [nvarchar](255) NULL,
	[_custbody_atlas_yes_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_yes_hdn_id] [nvarchar](255) NULL,
	[_custbody_pla_rev_grant_bill] [bit] NULL,
	[_custbody_test_bill] [bit] NULL,
	[_cseg_dm_household] [nvarchar](255) NULL,
	[_cseg_dm_household_id] [nvarchar](255) NULL,
	[_custbody_atlas_exist_cust_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_exist_cust_hdn_id] [nvarchar](255) NULL,
	[_custbody_atlas_new_cust_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_new_cust_hdn_id] [nvarchar](255) NULL,
	[_custbody_esc_created_date] [datetime] NULL,
	[_custbody_esc_last_modified_date] [datetime] NULL,
	[_custbody_npo_pledge_promise] [bit] NULL,
	[_cseg_npo_fund_p] [nvarchar](255) NULL,
	[_cseg_npo_fund_p_id] [nvarchar](255) NULL,
	[_cseg_npo_restrictn] [nvarchar](255) NULL,
	[_cseg_npo_restrictn_id] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[JEfull]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[JEfull] as 
SELECT distinct --top 3
      [BatchNumber] as [externalId] 
	  ,[BatchNumber] as [_LinkId]
      ,[PostDate] as trandate
      ,CONVERT(BIT, case when [PostStatus]='Posted' then 1 else 0 end) as approved
	-- ,cast(([PostStatus]='Posted')as boolean) as approved
	  ,2 as [subsidiary.internalId] --[subsidiary.name],[JournalID]
      ,[JournalName] as [_custbody_paltive_journal_type]
      ,[ReferenceText] as memo
	  --line related ---below---
	,b.internalID as [_parent.linkId]
--	,[TransactionSystemID]as line
	,[BatchDescription] as linememo ---,[LineNumber]
    ,[DebitAmount]as debit 
	,[CreditAmount] as credit
   -- ,[FullAccountNumber]  --,[AccountCodeID],[AccountCodename]
	,acc.[internalId] as [account.internalId]
	,[CostCenterName] as [department.name] --,[CostCenterID]  
	,[FunderProjectName]as [entity.name] --,[FunderProjectID] 
	,[PoolName] as [_cseg_pla_invpool] --,[PoolID]      

      ,[RestricitonName],'1' as [_cseg_npo_restrictn] --,[RestrictionID]         
      ,[FundName],f.internalId as [_cseg_npo_fund_p] --,[FundID]            
  FROM [Netsuite_Staging].[dbo].[tbl_JElast2020JanONWARDS]a   
  join [dbo].[NS_JE_body]b on b.externalId=a.[BatchNumber] 
  left join [dbo].[NS_Account]acc on acc.[acctNumber]=a.netsuiteaccount
  left join [dbo].[NS_Fund]f on f.name=a.[FundName]

 -- select name,internalid,* from [dbo].[NS_Fund] where name in ('Ambassador Bill and Jean Lane Endowment Fund','Barnholt Family Foundation')

--select * from [dbo].[NS_Account] where acctnumber='100380' ---21-1130-000 ---110300
--select top 10 * from [dbo].[NS_JE_body]
GO
/****** Object:  View [dbo].[JEfullLINE]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[JEfullLINE] as 
SELECT distinct top 4
 --     [BatchNumber] as [externalId] 
	--  ,[BatchNumber] as [_LinkId]
 --     ,[PostDate] as trandate
 --     ,CONVERT(BIT, case when [PostStatus]='Posted' then 1 else 0 end) as approved
	---- ,cast(([PostStatus]='Posted')as boolean) as approved
	--  ,2 as [subsidiary.internalId] --[subsidiary.name],[JournalID]
 --     ,[JournalName] as [_custbody_paltive_journal_type]
 --     ,[ReferenceText] as memo
	  --line related ---below---
	b.internalID+'2345'
	 as [_parent.linkId]
--	,[TransactionSystemID]as line
	,[BatchDescription] as memo ---,[LineNumber]
    ,[DebitAmount]as debit 
	,[CreditAmount] as credit
   -- ,[FullAccountNumber]  --,[AccountCodeID],[AccountCodename]
	,acc.[internalId] as [account.internalId]
	,'2' as [department.Id] --,[CostCenterID]  
	,[FunderProjectName]as [entity.name] --,[FunderProjectID] 
	,[PoolName] as [_cseg_pla_invpool] --,[PoolID]      

      ,[RestricitonName],'1' as [_cseg_npo_restrictn] --,[RestrictionID]         
      ,[FundName],f.internalId as [_cseg_npo_fund_p] --,[FundID]            
  FROM [Netsuite_Staging].[dbo].[tbl_JElast2020JanONWARDS]a   
  join [dbo].[NS_JE_body]b on b.externalId=a.[BatchNumber] 
  left join [dbo].[NS_Account]acc on acc.[acctNumber]=a.netsuiteaccount
  left join [dbo].[NS_Fund]f on f.name=a.[FundName]

 -- select name,internalid,* from [dbo].[NS_Fund] where name in ('Ambassador Bill and Jean Lane Endowment Fund','Barnholt Family Foundation')

--select * from [dbo].[NS_Account] where acctnumber='100380' ---21-1130-000 ---110300
--select top 10 * from [dbo].[NS_JE_body]
GO
/****** Object:  View [dbo].[JEfullBODY]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[JEfullBODY] as 
SELECT distinct top 2
      '738312345' as [externalId] 
	  ,'738312345' as [_LinkId]
      ,[PostDate] as trandate
      ,CONVERT(BIT, case when [PostStatus]='Posted' then 1 else 0 end) as approved
	-- ,cast(([PostStatus]='Posted')as boolean) as approved
	  ,2 as [subsidiary.internalId] --[subsidiary.name],[JournalID]
      ,[JournalName] as [_custbody_paltive_journal_type]
      ,[ReferenceText] as memo
	  --line related ---below---
--	,b.internalID as [_parent.linkId]
----	,[TransactionSystemID]as line
--	,[BatchDescription] as linememo ---,[LineNumber]
--    ,[DebitAmount]as debit 
--	,[CreditAmount] as credit
--   -- ,[FullAccountNumber]  --,[AccountCodeID],[AccountCodename]
--	,acc.[internalId] as [account.internalId]
	,'2' as [department.Id] --,[CostCenterID]  
--	,[FunderProjectName]as [entity.name] --,[FunderProjectID] 
--	,[PoolName] as [_cseg_pla_invpool] --,[PoolID]      

 --     ,[RestricitonName],'1' as [_cseg_npo_restrictn] --,[RestrictionID]         
  --    ,[FundName],f.internalId as [_cseg_npo_fund_p] --,[FundID]            
  FROM [Netsuite_Staging].[dbo].[tbl_JElast2020JanONWARDS]a   
  join [dbo].[NS_JE_body]b on b.externalId=a.[BatchNumber] 
  left join [dbo].[NS_Account]acc on acc.[acctNumber]=a.netsuiteaccount
  left join [dbo].[NS_Fund]f on f.name=a.[FundName]

 -- select name,internalid,* from [dbo].[NS_Fund] where name in ('Ambassador Bill and Jean Lane Endowment Fund','Barnholt Family Foundation')

--select * from [dbo].[NS_Account] where acctnumber='100380' ---21-1130-000 ---110300
--select top 10 * from [dbo].[NS_JE_body]
GO
/****** Object:  Table [dbo].[tbl_JE2019Jan15]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JE2019Jan15](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[JEline]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[JEline] as 
SELECT distinct --top 200
 --     [BatchNumber] as [externalId] 
	--  ,[BatchNumber] as [_LinkId]
 --     ,[PostDate] as trandate
 --     ,CONVERT(BIT, case when [PostStatus]='Posted' then 1 else 0 end) as approved
	---- ,cast(([PostStatus]='Posted')as boolean) as approved
	--  ,2 as [subsidiary.internalId] --[subsidiary.name],[JournalID]
 --     ,[JournalName] as [_custbody_paltive_journal_type]
 --     ,[ReferenceText] as memo
	  --line related ---below---
	--b.internalID+'2345'
	a.BatchNumber+'MT' as [_parent.linkId]
--	,[TransactionSystemID]as line
	,[BatchDescription] as memo ---,[LineNumber]
    ,[DebitAmount]as debit 
	,[CreditAmount] as credit
   -- ,[FullAccountNumber]  --,[AccountCodeID],[AccountCodename]
	,acc.[internalId] as [account.internalId]--,a.netsuiteaccount
	,'2' as [department.internalId] --,[CostCenterID]  
	,[FunderProjectName]as [entity.name] --,[FunderProjectID] 
	,[PoolName] as [_cseg_pla_invpool] --,[PoolID]      

      ,[RestricitonName],'1' as [_cseg_npo_restrictn] --,[RestrictionID]         
      ,[FundName],f.internalId as [_cseg_npo_fund_p] --,[FundID]            
  FROM [Netsuite_Staging].[dbo].[tbl_JE2019Jan15]a --[tbl_JE2022Jan15]a --[tbl_JE2022JanONWARDS]a --[tbl_JE2019JanONWARDS]a  
 -- join [dbo].[NS_JE_body]b on b.externalId=a.[BatchNumber] 
  left join [dbo].[NS_Account]acc on acc.[acctNumber]=a.netsuiteaccount
  left join [dbo].[NS_Fund]f on f.name=a.[FundName]
 -- where a.BatchNumber in('086148-20190107')
-- where a.BatchNumber in( '086045-20190102','086148-20190107')

 -- select name,internalid,* from [dbo].[NS_Fund] where name in ('Ambassador Bill and Jean Lane Endowment Fund','Barnholt Family Foundation')

--select * from [dbo].[NS_Account] where acctnumber='100380' ---21-1130-000 ---110300
--select top 10 * from [dbo].[NS_JE_body]
GO
/****** Object:  View [dbo].[JEbody]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[JEbody] as 
SELECT distinct --top 3
      --'738312345'
	  a.BatchNumber+'MT' as [externalId] 
	  --,'738312345'
	  ,a.BatchNumber+'MT' as [_LinkId]
      ,[PostDate] as trandate
      ,CONVERT(BIT, case when [PostStatus]='Posted' then 1 else 0 end) as approved
	-- ,cast(([PostStatus]='Posted')as boolean) as approved
	  ,2 as [subsidiary.internalId] --[subsidiary.name],[JournalID]
      ,[JournalName] as [_custbody_paltive_journal_type]
  --    ,[ReferenceText] as memo
	  --line related ---below---
--	,b.internalID as [_parent.linkId]
----	,[TransactionSystemID]as line
--	,[BatchDescription] as linememo ---,[LineNumber]
--    ,[DebitAmount]as debit 
--	,[CreditAmount] as credit
--   -- ,[FullAccountNumber]  --,[AccountCodeID],[AccountCodename]
--	,acc.[internalId] as [account.internalId]
	,'2' as [department.internalId] --,[CostCenterID]  
--	,[FunderProjectName]as [entity.name] --,[FunderProjectID] 
--	,[PoolName] as [_cseg_pla_invpool] --,[PoolID]      

 --     ,[RestricitonName],'1' as [_cseg_npo_restrictn] --,[RestrictionID]         
  --    ,[FundName],f.internalId as [_cseg_npo_fund_p] --,[FundID]            
  FROM [Netsuite_Staging].[dbo].[tbl_JE2019Jan15]a --[tbl_JE2022Jan15]a --[tbl_JE2022JanONWARDS]a --[tbl_JE2019JanONWARDS]a   
 -- join [dbo].[NS_JE_body]b on b.externalId=a.[BatchNumber] 
  left join [dbo].[NS_Account]acc on acc.[acctNumber]=a.netsuiteaccount
  left join [dbo].[NS_Fund]f on f.name=a.[FundName]
  JOIN [dbo].[JEline]L ON L.[_parent.linkId]=a.BatchNumber+'MT'
 -- where a.BatchNumber in( '086148-20190107') --1st success , 2nd error
 -- where a.BatchNumber in( '086045-20190102','086148-20190107') --1st success , 2nd error

 -- select name,internalid,* from [dbo].[NS_Fund] where name in ('Ambassador Bill and Jean Lane Endowment Fund','Barnholt Family Foundation')

--select * from [dbo].[NS_Account] where acctnumber='100380' ---21-1130-000 ---110300
--select top 10 * from [dbo].[NS_JE_body]
GO
/****** Object:  Table [dbo].[aaa_tbl_VendorBills]    Script Date: 8/20/2022 3:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aaa_tbl_VendorBills](
	[APInvoiceSystemID] [int] NOT NULL,
	[APInvoiceImportID] [varchar](50) NULL,
	[InvoiceNumber] [varchar](20) NULL,
	[VendorName] [varchar](60) NULL,
	[Description] [varchar](60) NULL,
	[DateInvoiced] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[PostDate] [datetime] NULL,
	[DateReversed] [datetime] NOT NULL,
	[ReversalPostDate] [datetime] NULL,
	[InvoiceStatus] [varchar](20) NULL,
	[INVOICEAMOUNT] [numeric](19, 4) NOT NULL,
	[APBankSystemID] [int] NULL,
	[Bank] [varchar](60) NULL,
	[AmountPaid] [numeric](19, 4) NULL,
	[ScheduledPaymentDate] [datetime] NULL,
	[DatePaid] [datetime] NULL,
	[DateVoided] [datetime] NULL,
	[VoidPostDate] [datetime] NULL,
	[Type] [varchar](20) NULL,
	[PaymentStatus] [varchar](20) NULL,
	[CheckNumber] [int] NULL,
	[TransactionSystemID] [int] NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NULL,
	[Restrictions] [varchar](41) NULL,
	[AccountCodeID] [varchar](30) NULL,
	[AccountCodename] [varchar](60) NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error_JEBody]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_JEBody](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NULL,
	[externalId] [varchar](8000) NULL,
	[_LinkId] [varchar](8000) NULL,
	[trandate] [datetime] NULL,
	[approved] [bit] NULL,
	[subsidiary.internalId] [int] NULL,
	[_custbody_paltive_journal_type] [varchar](60) NULL,
	[memo] [varchar](100) NULL,
	[department.internalId] [varchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error_JEline]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_JEline](
	[ErrorCode] [int] NULL,
	[ErrorColumn] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NULL,
	[_parent.linkId] [varchar](8000) NULL,
	[memo] [varchar](60) NULL,
	[debit] [numeric](19, 4) NULL,
	[credit] [numeric](19, 4) NULL,
	[account.internalId] [nvarchar](255) NULL,
	[department.internalId] [varchar](1) NULL,
	[entity.name] [varchar](60) NULL,
	[_cseg_pla_invpool] [varchar](60) NULL,
	[RestricitonName] [varchar](22) NULL,
	[_cseg_npo_restrictn] [varchar](1) NULL,
	[FundName] [varchar](60) NULL,
	[_cseg_npo_fund_p] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FE_JE_2YEARS]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FE_JE_2YEARS](
	[TransactionSystemID] [varchar](255) NULL,
	[BatchNumber] [varchar](255) NULL,
	[BatchDescription] [varchar](255) NULL,
	[PostDate] [varchar](255) NULL,
	[PostStatus] [varchar](255) NULL,
	[LineNumber] [varchar](255) NULL,
	[DebitAmount] [varchar](255) NULL,
	[CreditAmount] [varchar](255) NULL,
	[FullAccountNumber] [varchar](255) NULL,
	[RestrictionID] [varchar](255) NULL,
	[RestricitonName] [varchar](255) NULL,
	[AccountCodeID] [varchar](255) NULL,
	[AccountCodename] [varchar](255) NULL,
	[CostCenterID] [varchar](255) NULL,
	[CostCenterName] [varchar](255) NULL,
	[FundID] [varchar](255) NULL,
	[FundName] [varchar](255) NULL,
	[PoolID] [varchar](255) NULL,
	[PoolName] [varchar](255) NULL,
	[FunderProjectID] [varchar](255) NULL,
	[FunderProjectName] [varchar](255) NULL,
	[JournalID] [varchar](255) NULL,
	[JournalName] [varchar](255) NULL,
	[ReferenceText] [varchar](255) NULL,
	[ExcludeFromNetSuite] [varchar](255) NULL,
	[NetSuiteAccount] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JEbody_success]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JEbody_success](
	[NetSuiteRecordID] [nvarchar](255) NULL,
	[externalId] [varchar](8000) NULL,
	[trandate] [datetime] NULL,
	[approved] [bit] NULL,
	[subsidiary.internalId] [int] NULL,
	[memo] [varchar](100) NULL,
	[linememo] [varchar](60) NULL,
	[debit] [numeric](19, 4) NULL,
	[credit] [numeric](19, 4) NULL,
	[department.name] [varchar](60) NULL,
	[entity.name] [varchar](60) NULL,
	[_cseg_npo_fund_p] [nvarchar](255) NULL,
	[_LinkId] [varchar](8000) NULL,
	[_parent.linkId] [nvarchar](255) NULL,
	[_custbody_paltive_journal_type] [varchar](60) NULL,
	[_cseg_pla_invpool] [varchar](60) NULL,
	[_cseg_npo_restrictn] [varchar](22) NULL,
	[account.internalId] [nvarchar](255) NULL,
	[FundName] [varchar](60) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_AccountOLD]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_AccountOLD](
	[acctNumber] [nvarchar](255) NULL,
	[internalId] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_Department]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_Department](
	[externalId] [nvarchar](255) NULL,
	[includeChildren] [bit] NULL,
	[internalId] [nvarchar](255) NULL,
	[isInactive] [bit] NULL,
	[name] [nvarchar](255) NULL,
	[parent.externalId] [nvarchar](255) NULL,
	[parent.internalId] [nvarchar](255) NULL,
	[parent.name] [nvarchar](255) NULL,
	[parent.type] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_JE_body500]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_JE_body500](
	[accountingBook.externalId] [nvarchar](255) NULL,
	[accountingBook.internalId] [nvarchar](255) NULL,
	[accountingBook.name] [nvarchar](255) NULL,
	[accountingBook.type] [nvarchar](255) NULL,
	[approved] [bit] NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[createdDate] [datetime] NULL,
	[createdFrom.externalId] [nvarchar](255) NULL,
	[createdFrom.internalId] [nvarchar](255) NULL,
	[createdFrom.name] [nvarchar](255) NULL,
	[createdFrom.type] [nvarchar](255) NULL,
	[currency.externalId] [nvarchar](255) NULL,
	[currency.internalId] [nvarchar](255) NULL,
	[currency.name] [nvarchar](255) NULL,
	[currency.type] [nvarchar](255) NULL,
	[customForm.externalId] [nvarchar](255) NULL,
	[customForm.internalId] [nvarchar](255) NULL,
	[customForm.name] [nvarchar](255) NULL,
	[customForm.type] [nvarchar](255) NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[exchangeRate] [float] NULL,
	[externalId] [nvarchar](255) NULL,
	[internalId] [nvarchar](255) NULL,
	[isBookSpecific] [bit] NULL,
	[lastModifiedDate] [datetime] NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[memo] [nvarchar](255) NULL,
	[nexus.externalId] [nvarchar](255) NULL,
	[nexus.internalId] [nvarchar](255) NULL,
	[nexus.name] [nvarchar](255) NULL,
	[nexus.type] [nvarchar](255) NULL,
	[parentExpenseAlloc.externalId] [nvarchar](255) NULL,
	[parentExpenseAlloc.internalId] [nvarchar](255) NULL,
	[parentExpenseAlloc.name] [nvarchar](255) NULL,
	[parentExpenseAlloc.type] [nvarchar](255) NULL,
	[postingPeriod.externalId] [nvarchar](255) NULL,
	[postingPeriod.internalId] [nvarchar](255) NULL,
	[postingPeriod.name] [nvarchar](255) NULL,
	[postingPeriod.type] [nvarchar](255) NULL,
	[reversalDate] [datetime] NULL,
	[reversalDefer] [bit] NULL,
	[reversalEntry] [nvarchar](255) NULL,
	[subsidiary.externalId] [nvarchar](255) NULL,
	[subsidiary.internalId] [nvarchar](255) NULL,
	[subsidiary.name] [nvarchar](255) NULL,
	[subsidiary.type] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.externalId] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.internalId] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.name] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.type] [nvarchar](255) NULL,
	[taxPointDate] [datetime] NULL,
	[toSubsidiary.externalId] [nvarchar](255) NULL,
	[toSubsidiary.internalId] [nvarchar](255) NULL,
	[toSubsidiary.name] [nvarchar](255) NULL,
	[toSubsidiary.type] [nvarchar](255) NULL,
	[tranDate] [datetime] NULL,
	[tranId] [nvarchar](255) NULL,
	[_custbody_atlas_no_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_no_hdn_id] [nvarchar](255) NULL,
	[_custbody_atlas_yes_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_yes_hdn_id] [nvarchar](255) NULL,
	[_custbody_pla_rev_grant_bill] [bit] NULL,
	[_custbody_test_bill] [bit] NULL,
	[_cseg_dm_household] [nvarchar](255) NULL,
	[_cseg_dm_household_id] [nvarchar](255) NULL,
	[_custbody_atlas_exist_cust_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_exist_cust_hdn_id] [nvarchar](255) NULL,
	[_custbody_atlas_new_cust_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_new_cust_hdn_id] [nvarchar](255) NULL,
	[_custbody_esc_created_date] [datetime] NULL,
	[_custbody_esc_last_modified_date] [datetime] NULL,
	[_custbody_npo_pledge_promise] [bit] NULL,
	[_cseg_npo_fund_p] [nvarchar](255) NULL,
	[_cseg_npo_fund_p_id] [nvarchar](255) NULL,
	[_cseg_npo_restrictn] [nvarchar](255) NULL,
	[_cseg_npo_restrictn_id] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_JE_bodyfullOLD]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_JE_bodyfullOLD](
	[accountingBook.externalId] [nvarchar](255) NULL,
	[accountingBook.internalId] [nvarchar](255) NULL,
	[accountingBook.name] [nvarchar](255) NULL,
	[accountingBook.type] [nvarchar](255) NULL,
	[approved] [bit] NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[createdDate] [datetime] NULL,
	[createdFrom.externalId] [nvarchar](255) NULL,
	[createdFrom.internalId] [nvarchar](255) NULL,
	[createdFrom.name] [nvarchar](255) NULL,
	[createdFrom.type] [nvarchar](255) NULL,
	[currency.externalId] [nvarchar](255) NULL,
	[currency.internalId] [nvarchar](255) NULL,
	[currency.name] [nvarchar](255) NULL,
	[currency.type] [nvarchar](255) NULL,
	[customForm.externalId] [nvarchar](255) NULL,
	[customForm.internalId] [nvarchar](255) NULL,
	[customForm.name] [nvarchar](255) NULL,
	[customForm.type] [nvarchar](255) NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[exchangeRate] [float] NULL,
	[externalId] [nvarchar](255) NULL,
	[internalId] [nvarchar](255) NULL,
	[isBookSpecific] [bit] NULL,
	[lastModifiedDate] [datetime] NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[memo] [nvarchar](255) NULL,
	[nexus.externalId] [nvarchar](255) NULL,
	[nexus.internalId] [nvarchar](255) NULL,
	[nexus.name] [nvarchar](255) NULL,
	[nexus.type] [nvarchar](255) NULL,
	[parentExpenseAlloc.externalId] [nvarchar](255) NULL,
	[parentExpenseAlloc.internalId] [nvarchar](255) NULL,
	[parentExpenseAlloc.name] [nvarchar](255) NULL,
	[parentExpenseAlloc.type] [nvarchar](255) NULL,
	[postingPeriod.externalId] [nvarchar](255) NULL,
	[postingPeriod.internalId] [nvarchar](255) NULL,
	[postingPeriod.name] [nvarchar](255) NULL,
	[postingPeriod.type] [nvarchar](255) NULL,
	[reversalDate] [datetime] NULL,
	[reversalDefer] [bit] NULL,
	[reversalEntry] [nvarchar](255) NULL,
	[subsidiary.externalId] [nvarchar](255) NULL,
	[subsidiary.internalId] [nvarchar](255) NULL,
	[subsidiary.name] [nvarchar](255) NULL,
	[subsidiary.type] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.externalId] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.internalId] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.name] [nvarchar](255) NULL,
	[subsidiaryTaxRegNum.type] [nvarchar](255) NULL,
	[taxPointDate] [datetime] NULL,
	[toSubsidiary.externalId] [nvarchar](255) NULL,
	[toSubsidiary.internalId] [nvarchar](255) NULL,
	[toSubsidiary.name] [nvarchar](255) NULL,
	[toSubsidiary.type] [nvarchar](255) NULL,
	[tranDate] [datetime] NULL,
	[tranId] [nvarchar](255) NULL,
	[_custbody_atlas_no_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_no_hdn_id] [nvarchar](255) NULL,
	[_custbody_atlas_yes_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_yes_hdn_id] [nvarchar](255) NULL,
	[_custbody_pla_rev_grant_bill] [bit] NULL,
	[_custbody_test_bill] [bit] NULL,
	[_cseg_dm_household] [nvarchar](255) NULL,
	[_cseg_dm_household_id] [nvarchar](255) NULL,
	[_custbody_atlas_exist_cust_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_exist_cust_hdn_id] [nvarchar](255) NULL,
	[_custbody_atlas_new_cust_hdn] [nvarchar](255) NULL,
	[_custbody_atlas_new_cust_hdn_id] [nvarchar](255) NULL,
	[_custbody_esc_created_date] [datetime] NULL,
	[_custbody_esc_last_modified_date] [datetime] NULL,
	[_custbody_npo_pledge_promise] [bit] NULL,
	[_cseg_npo_fund_p] [nvarchar](255) NULL,
	[_cseg_npo_fund_p_id] [nvarchar](255) NULL,
	[_cseg_npo_restrictn] [nvarchar](255) NULL,
	[_cseg_npo_restrictn_id] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_JE_line]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_JE_line](
	[_parent.linkId] [nvarchar](255) NULL,
	[account.externalId] [nvarchar](255) NULL,
	[account.internalId] [nvarchar](255) NULL,
	[account.name] [nvarchar](255) NULL,
	[account.type] [nvarchar](255) NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[credit] [float] NULL,
	[creditTax] [float] NULL,
	[customFieldList] [nvarchar](4000) NULL,
	[debit] [float] NULL,
	[debitTax] [float] NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[eliminate] [bit] NULL,
	[endDate] [datetime] NULL,
	[entity.externalId] [nvarchar](255) NULL,
	[entity.internalId] [nvarchar](255) NULL,
	[entity.name] [nvarchar](255) NULL,
	[entity.type] [nvarchar](255) NULL,
	[grossAmt] [float] NULL,
	[line] [bigint] NULL,
	[lineTaxCode.externalId] [nvarchar](255) NULL,
	[lineTaxCode.internalId] [nvarchar](255) NULL,
	[lineTaxCode.name] [nvarchar](255) NULL,
	[lineTaxCode.type] [nvarchar](255) NULL,
	[lineTaxRate] [float] NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[memo] [nvarchar](255) NULL,
	[residual] [nvarchar](255) NULL,
	[revenueRecognitionRule.externalId] [nvarchar](255) NULL,
	[revenueRecognitionRule.internalId] [nvarchar](255) NULL,
	[revenueRecognitionRule.name] [nvarchar](255) NULL,
	[revenueRecognitionRule.type] [nvarchar](255) NULL,
	[schedule.externalId] [nvarchar](255) NULL,
	[schedule.internalId] [nvarchar](255) NULL,
	[schedule.name] [nvarchar](255) NULL,
	[schedule.type] [nvarchar](255) NULL,
	[scheduleNum.externalId] [nvarchar](255) NULL,
	[scheduleNum.internalId] [nvarchar](255) NULL,
	[scheduleNum.name] [nvarchar](255) NULL,
	[scheduleNum.type] [nvarchar](255) NULL,
	[startDate] [datetime] NULL,
	[tax1Acct.externalId] [nvarchar](255) NULL,
	[tax1Acct.internalId] [nvarchar](255) NULL,
	[tax1Acct.name] [nvarchar](255) NULL,
	[tax1Acct.type] [nvarchar](255) NULL,
	[tax1Amt] [float] NULL,
	[taxAccount.externalId] [nvarchar](255) NULL,
	[taxAccount.internalId] [nvarchar](255) NULL,
	[taxAccount.name] [nvarchar](255) NULL,
	[taxAccount.type] [nvarchar](255) NULL,
	[taxBasis] [float] NULL,
	[taxCode.externalId] [nvarchar](255) NULL,
	[taxCode.internalId] [nvarchar](255) NULL,
	[taxCode.name] [nvarchar](255) NULL,
	[taxCode.type] [nvarchar](255) NULL,
	[taxRate1] [float] NULL,
	[totalAmount] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_JE_line500]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_JE_line500](
	[_parent.linkId] [nvarchar](255) NULL,
	[account.externalId] [nvarchar](255) NULL,
	[account.internalId] [nvarchar](255) NULL,
	[account.name] [nvarchar](255) NULL,
	[account.type] [nvarchar](255) NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[credit] [float] NULL,
	[creditTax] [float] NULL,
	[customFieldList] [nvarchar](4000) NULL,
	[debit] [float] NULL,
	[debitTax] [float] NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[eliminate] [bit] NULL,
	[endDate] [datetime] NULL,
	[entity.externalId] [nvarchar](255) NULL,
	[entity.internalId] [nvarchar](255) NULL,
	[entity.name] [nvarchar](255) NULL,
	[entity.type] [nvarchar](255) NULL,
	[grossAmt] [float] NULL,
	[line] [bigint] NULL,
	[lineTaxCode.externalId] [nvarchar](255) NULL,
	[lineTaxCode.internalId] [nvarchar](255) NULL,
	[lineTaxCode.name] [nvarchar](255) NULL,
	[lineTaxCode.type] [nvarchar](255) NULL,
	[lineTaxRate] [float] NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[memo] [nvarchar](255) NULL,
	[residual] [nvarchar](255) NULL,
	[revenueRecognitionRule.externalId] [nvarchar](255) NULL,
	[revenueRecognitionRule.internalId] [nvarchar](255) NULL,
	[revenueRecognitionRule.name] [nvarchar](255) NULL,
	[revenueRecognitionRule.type] [nvarchar](255) NULL,
	[schedule.externalId] [nvarchar](255) NULL,
	[schedule.internalId] [nvarchar](255) NULL,
	[schedule.name] [nvarchar](255) NULL,
	[schedule.type] [nvarchar](255) NULL,
	[scheduleNum.externalId] [nvarchar](255) NULL,
	[scheduleNum.internalId] [nvarchar](255) NULL,
	[scheduleNum.name] [nvarchar](255) NULL,
	[scheduleNum.type] [nvarchar](255) NULL,
	[startDate] [datetime] NULL,
	[tax1Acct.externalId] [nvarchar](255) NULL,
	[tax1Acct.internalId] [nvarchar](255) NULL,
	[tax1Acct.name] [nvarchar](255) NULL,
	[tax1Acct.type] [nvarchar](255) NULL,
	[tax1Amt] [float] NULL,
	[taxAccount.externalId] [nvarchar](255) NULL,
	[taxAccount.internalId] [nvarchar](255) NULL,
	[taxAccount.name] [nvarchar](255) NULL,
	[taxAccount.type] [nvarchar](255) NULL,
	[taxBasis] [float] NULL,
	[taxCode.externalId] [nvarchar](255) NULL,
	[taxCode.internalId] [nvarchar](255) NULL,
	[taxCode.name] [nvarchar](255) NULL,
	[taxCode.type] [nvarchar](255) NULL,
	[taxRate1] [float] NULL,
	[totalAmount] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NS_JE_linefullOLD]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NS_JE_linefullOLD](
	[_parent.linkId] [nvarchar](255) NULL,
	[account.externalId] [nvarchar](255) NULL,
	[account.internalId] [nvarchar](255) NULL,
	[account.name] [nvarchar](255) NULL,
	[account.type] [nvarchar](255) NULL,
	[class.externalId] [nvarchar](255) NULL,
	[class.internalId] [nvarchar](255) NULL,
	[class.name] [nvarchar](255) NULL,
	[class.type] [nvarchar](255) NULL,
	[credit] [float] NULL,
	[creditTax] [float] NULL,
	[customFieldList] [nvarchar](4000) NULL,
	[debit] [float] NULL,
	[debitTax] [float] NULL,
	[department.externalId] [nvarchar](255) NULL,
	[department.internalId] [nvarchar](255) NULL,
	[department.name] [nvarchar](255) NULL,
	[department.type] [nvarchar](255) NULL,
	[eliminate] [bit] NULL,
	[endDate] [datetime] NULL,
	[entity.externalId] [nvarchar](255) NULL,
	[entity.internalId] [nvarchar](255) NULL,
	[entity.name] [nvarchar](255) NULL,
	[entity.type] [nvarchar](255) NULL,
	[grossAmt] [float] NULL,
	[line] [bigint] NULL,
	[lineTaxCode.externalId] [nvarchar](255) NULL,
	[lineTaxCode.internalId] [nvarchar](255) NULL,
	[lineTaxCode.name] [nvarchar](255) NULL,
	[lineTaxCode.type] [nvarchar](255) NULL,
	[lineTaxRate] [float] NULL,
	[location.externalId] [nvarchar](255) NULL,
	[location.internalId] [nvarchar](255) NULL,
	[location.name] [nvarchar](255) NULL,
	[location.type] [nvarchar](255) NULL,
	[memo] [nvarchar](255) NULL,
	[residual] [nvarchar](255) NULL,
	[revenueRecognitionRule.externalId] [nvarchar](255) NULL,
	[revenueRecognitionRule.internalId] [nvarchar](255) NULL,
	[revenueRecognitionRule.name] [nvarchar](255) NULL,
	[revenueRecognitionRule.type] [nvarchar](255) NULL,
	[schedule.externalId] [nvarchar](255) NULL,
	[schedule.internalId] [nvarchar](255) NULL,
	[schedule.name] [nvarchar](255) NULL,
	[schedule.type] [nvarchar](255) NULL,
	[scheduleNum.externalId] [nvarchar](255) NULL,
	[scheduleNum.internalId] [nvarchar](255) NULL,
	[scheduleNum.name] [nvarchar](255) NULL,
	[scheduleNum.type] [nvarchar](255) NULL,
	[startDate] [datetime] NULL,
	[tax1Acct.externalId] [nvarchar](255) NULL,
	[tax1Acct.internalId] [nvarchar](255) NULL,
	[tax1Acct.name] [nvarchar](255) NULL,
	[tax1Acct.type] [nvarchar](255) NULL,
	[tax1Amt] [float] NULL,
	[taxAccount.externalId] [nvarchar](255) NULL,
	[taxAccount.internalId] [nvarchar](255) NULL,
	[taxAccount.name] [nvarchar](255) NULL,
	[taxAccount.type] [nvarchar](255) NULL,
	[taxBasis] [float] NULL,
	[taxCode.externalId] [nvarchar](255) NULL,
	[taxCode.internalId] [nvarchar](255) NULL,
	[taxCode.name] [nvarchar](255) NULL,
	[taxCode.type] [nvarchar](255) NULL,
	[taxRate1] [float] NULL,
	[totalAmount] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JE_ExternalID]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JE_ExternalID](
	[externalId] [varchar](8000) NULL,
	[Processed] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JE2019JanMay31]    Script Date: 8/20/2022 3:57:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JE2019JanMay31](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEbody_success2019Jan]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEbody_success2019Jan](
	[NetSuiteRecordID] [nvarchar](255) NULL,
	[externalId] [varchar](8000) NULL,
	[trandate] [datetime] NULL,
	[approved] [bit] NULL,
	[subsidiary.internalId] [int] NULL,
	[memo] [varchar](100) NULL,
	[linememo] [varchar](60) NULL,
	[debit] [numeric](19, 4) NULL,
	[credit] [numeric](19, 4) NULL,
	[department.name] [varchar](60) NULL,
	[entity.name] [varchar](60) NULL,
	[_cseg_npo_fund_p] [nvarchar](255) NULL,
	[_LinkId] [varchar](8000) NULL,
	[_parent.linkId] [nvarchar](255) NULL,
	[_custbody_paltive_journal_type] [varchar](60) NULL,
	[_cseg_pla_invpool] [varchar](60) NULL,
	[_cseg_npo_restrictn] [varchar](22) NULL,
	[account.internalId] [nvarchar](255) NULL,
	[FundName] [varchar](60) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEDelta]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEDelta](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEDeltaUptoMay1]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEDeltaUptoMay1](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEDeltaUptoMay1new]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEDeltaUptoMay1new](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEDeltaUptoMay1TRY]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEDeltaUptoMay1TRY](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEDeltaUptoMay1with2020data]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEDeltaUptoMay1with2020data](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEfor2Funds]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEfor2Funds](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEnewDATA2019onwards]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEnewDATA2019onwards](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEsinceJAN2012uptoDEC2014]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEsinceJAN2012uptoDEC2014](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEsinceJAN2012uptoDEC2018]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEsinceJAN2012uptoDEC2018](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEsinceJAN2015uptoDEC2016]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEsinceJAN2015uptoDEC2016](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_JEsinceJAN2017uptoDEC2018]    Script Date: 8/20/2022 3:57:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_JEsinceJAN2017uptoDEC2018](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[PostStatus] [varchar](14) NULL,
	[LineNumber] [bigint] NULL,
	[DebitAmount] [numeric](19, 4) NULL,
	[CreditAmount] [numeric](19, 4) NULL,
	[FullAccountNumber] [varchar](30) NOT NULL,
	[RestrictionID] [tinyint] NULL,
	[RestricitonName] [varchar](22) NULL,
	[AccountCodeID] [varchar](30) NOT NULL,
	[AccountCodename] [varchar](60) NOT NULL,
	[CostCenterID] [varchar](6) NULL,
	[CostCenterName] [varchar](60) NOT NULL,
	[FundID] [varchar](12) NULL,
	[FundName] [varchar](60) NULL,
	[PoolID] [varchar](6) NULL,
	[PoolName] [varchar](60) NULL,
	[FunderProjectID] [varchar](6) NULL,
	[FunderProjectName] [varchar](60) NULL,
	[JournalID] [varchar](6) NULL,
	[JournalName] [varchar](60) NULL,
	[ReferenceText] [varchar](100) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_TrasactionSystemId]    Script Date: 8/20/2022 3:57:26 AM ******/
CREATE NONCLUSTERED INDEX [idx_TrasactionSystemId] ON [dbo].[FE_JE_2YEARS]
(
	[TransactionSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_TransactionSystemID]    Script Date: 8/20/2022 3:57:26 AM ******/
CREATE NONCLUSTERED INDEX [idx_TransactionSystemID] ON [dbo].[tbl_JEnewDATA2019onwards]
(
	[TransactionSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [Netsuite_Staging] SET  READ_WRITE 
GO
