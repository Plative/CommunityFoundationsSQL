USE [master]
GO
/****** Object:  Database [Netsuite_FE_Extracts]    Script Date: 8/20/2022 3:56:26 AM ******/
CREATE DATABASE [Netsuite_FE_Extracts]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Netsuite_FE_Extracts', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Netsuite_FE_Extracts.mdf' , SIZE = 1974272KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Netsuite_FE_Extracts_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Netsuite_FE_Extracts_log.ldf' , SIZE = 1646592KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Netsuite_FE_Extracts].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET ARITHABORT OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET RECOVERY FULL 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET  MULTI_USER 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET QUERY_STORE = OFF
GO
USE [Netsuite_FE_Extracts]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\prajakta]    Script Date: 8/20/2022 3:56:26 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\prajakta] FOR LOGIN [EC2AMAZ-4C784Q4\prajakta] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\opopova]    Script Date: 8/20/2022 3:56:26 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\opopova] FOR LOGIN [EC2AMAZ-4C784Q4\opopova] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\mma]    Script Date: 8/20/2022 3:56:26 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\mma] FOR LOGIN [EC2AMAZ-4C784Q4\mma] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\jagriti]    Script Date: 8/20/2022 3:56:26 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\jagriti] FOR LOGIN [EC2AMAZ-4C784Q4\jagriti] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC2AMAZ-4C784Q4\akanksha]    Script Date: 8/20/2022 3:56:26 AM ******/
CREATE USER [EC2AMAZ-4C784Q4\akanksha] FOR LOGIN [EC2AMAZ-4C784Q4\akanksha] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  View [dbo].[APPayment_Delta]    Script Date: 8/20/2022 3:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[APPayment_Delta]
as
SELECT [APPaymentSystemID]
      ,[APInvoiceSystemID]
      ,[APBankSystemID]
      ,[Amount]
      ,[ScheduledPaymentDate]
      ,[DatePaid]
      ,[DateVoided]
      ,[VoidPostDate]
      ,[Type]
      ,[Status]
      ,[Number]
      ,[CheckDateAdded]
  FROM [FE_SVCF].[api].[APPayment]
  where [CheckDateAdded] between '3/1/2022' and '6/2/2022';
GO
/****** Object:  View [dbo].[APVendorBill_07012022]    Script Date: 8/20/2022 3:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [dbo].[APVendorBill_07012022] as 
SELECT distinct([APInvoiceSystemID])
      ,[APInvoiceImportID]
      ,[InvoiceNumber]

      ,[VendorName]

      ,[Description]

      ,[DateInvoiced]

      ,[DueDate]

      ,[PostDate]

      ,[DateReversed]

      ,[ReversalPostDate]

      ,[InvoiceStatus]

      ,[INVOICEAMOUNT]

      ,[APBankSystemID]

      ,[Bank]

      ,[AmountPaid]

      ,[ScheduledPaymentDate]

      ,[DatePaid]

      ,[DateVoided]

      ,[VoidPostDate]

      ,[Type]

      ,[PaymentStatus]

      ,[CheckNumber]

      ,[TransactionSystemID]

      ,[BatchNumber]

      ,[BatchDescription]

      ,[LineNumber]

      ,[DebitAmount]

      ,[CreditAmount]

      ,[FullAccountNumber]

      ,[Restrictions]

      ,[AccountCodeID]

      ,[AccountCodename]

      ,[RestrictionID]

      ,[RestricitonName]

      ,[CostCenterID]

      ,[CostCenterName]

      ,[FundID]

      ,[FundName]

      ,[PoolID]

      ,[PoolName]

      ,[FunderProjectID]

      ,[FunderProjectName]

      ,[JournalID]

      ,[JournalName]

      ,[ReferenceText]

      ,[ExcludeFromNetSuite]

      ,[NetSuiteAccount]

         ,STUFF((

                     Select CreditAmount

                     from [FE_SVCF].[api].[APVendorBill] t1

                     where t1.APInvoiceSystemID = t2.APInvoiceSystemID

                     for XML PATH(''), Type

                     ). value('.', 'varchar(max)') ,1, 1, '') as Credit2

  FROM [FE_SVCF].[api].[APVendorBill] t2
  where t2.PostDate > '2012-01-01 00:00:00.000'

  group by [APInvoiceSystemID],

          [APInvoiceImportID]

      ,[InvoiceNumber]

      ,[VendorName]

      ,[Description]

      ,[DateInvoiced]

      ,[DueDate]

      ,[PostDate]

      ,[DateReversed]

      ,[ReversalPostDate]

      ,[InvoiceStatus]

      ,[INVOICEAMOUNT]

      ,[APBankSystemID]

      ,[Bank]

      ,[AmountPaid]

      ,[ScheduledPaymentDate]

      ,[DatePaid]

      ,[DateVoided]

      ,[VoidPostDate]

      ,[Type]

      ,[PaymentStatus]

      ,[CheckNumber]

      ,[TransactionSystemID]

      ,[BatchNumber]

      ,[BatchDescription]

      ,[LineNumber]

      ,[DebitAmount]

      ,[CreditAmount]

      ,[FullAccountNumber]

      ,[Restrictions]

      ,[AccountCodeID]

      ,[AccountCodename]

      ,[RestrictionID]

      ,[RestricitonName]

      ,[CostCenterID]

      ,[CostCenterName]

      ,[FundID]

      ,[FundName]

      ,[PoolID]

      ,[PoolName]

      ,[FunderProjectID]

      ,[FunderProjectName]

      ,[JournalID]

      ,[JournalName]

     ,[ReferenceText]

      ,[ExcludeFromNetSuite]

      ,[NetSuiteAccount]
GO
/****** Object:  View [dbo].[APVendorBill_Delta]    Script Date: 8/20/2022 3:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create view [dbo].[APVendorBill_Delta]
as
SELECT [APInvoiceSystemID]
      ,[APInvoiceImportID]
      ,[InvoiceNumber]
      ,[VendorName]
      ,[Description]
      ,[DateInvoiced]
      ,[DueDate]
      ,[PostDate]
      ,[DateReversed]
      ,[ReversalPostDate]
      ,[InvoiceStatus]
      ,[INVOICEAMOUNT]
      ,[APBankSystemID]
      ,[Bank]
      ,[AmountPaid]
      ,[ScheduledPaymentDate]
      ,[DatePaid]
      ,[DateVoided]
      ,[VoidPostDate]
      ,[Type]
      ,[PaymentStatus]
      ,[CheckNumber]
      ,[TransactionSystemID]
      ,[BatchNumber]
      ,[BatchDescription]
      ,[LineNumber]
      ,[DebitAmount]
      ,[CreditAmount]
      ,[FullAccountNumber]
      ,[Restrictions]
      ,[AccountCodeID]
      ,[AccountCodename]
      ,[RestrictionID]
      ,[RestricitonName]
      ,[CostCenterID]
      ,[CostCenterName]
      ,[FundID]
      ,[FundName]
      ,[PoolID]
      ,[PoolName]
      ,[FunderProjectID]
      ,[FunderProjectName]
      ,[JournalID]
      ,[JournalName]
      ,[ReferenceText]
      ,[ExcludeFromNetSuite]
      ,[NetSuiteAccount]
      ,[DateAdded]
  FROM [FE_SVCF].[api].[APVendorBill]
  where DateAdded between '3/1/2022' and '6/2/2022';
GO
/****** Object:  View [dbo].[APVendorBillAdjustment_Delta]    Script Date: 8/20/2022 3:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[APVendorBillAdjustment_Delta]
as
SELECT AP7ADJUSTMENTSID
      ,ADDEDBYID
      ,ADJUSTMENTDATE
      ,PARENTID
      ,NEWTRANSACTIONAMOUNT
      ,CURRENTTRANSACTIONAMOUNT
      ,POSTDATE
      ,REASON
      ,NOTES
      ,DATEADDED
      ,DATECHANGED
      ,LASTCHANGEDBYID
      ,IMPORTID
      ,POSTSTATUS
      ,INTERFUNDSETS7ID
      ,ORIGINALPOSTDATE
      ,AP7SALESTAXITEMSID
      ,TAXAMOUNT
      ,PREVIOUSTAXAMOUNT
      ,REBATEAMOUNT
      ,ACTIVITYCODEID
      ,AP7PREVIOUSSALESTAXITEMSID
      ,PREVIOUSREBATEAMOUNT
      ,PREVIOUSACTIVITYCODEID
      ,PSTREBATEAMOUNT
      ,PREVIOUSPSTREBATEAMOUNT
  FROM FE_SVCF.[dbo].[AP7INVOICEADJUSTMENTS]
  where DATEADDED between '3/1/2022' and '6/2/2022';
GO
/****** Object:  View [dbo].[JournalEntryTransaction_Delta]    Script Date: 8/20/2022 3:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 

 

 

 

 

 

 

 

 



 

 

CREATE view [dbo].[JournalEntryTransaction_Delta]

as

/*

*  View: api.[JournalEntryTransaction]

*

*  Version: 20210615.1

*

*  Description: TODO

*

*  Note2: As of 2021-09-23, SVCF planned to include 10 years of transactions

*  when migrating to NetSuite. This view includes a WHERE close that filters

*  transactions with post dates on or after 2012-01-01 assuming a 2022-01

*  data migration.

*

 *  If the retention period or migration dates change, update the WHERE clause.

*

*  Note2: FE can include multiple post dates across multiple fiscal periods in

*  a single journal entry batch. External systems like NetSuite allow only a

*  single post date. This view therefore splits FE batches into multiple if

*  the original includes multiple post date.

*

*  CAUTION: FE also only requires  balancing by fiscal period, not individual

*  post date. There are several hundred FE batches that do not balance by post

*  date. Examples include 106544 and 105142. External systems consuming

*  transactions from this view may need to change dates to meet more strict

*  balancing requirements (e.g., NetSuite requires balancing by individual

*  post date).

*

*  2021-09-09

*  Logan J Travis 

 *  ltravis@siliconvalleycf.org

*/

/*

* Common Table Expressions

*

* 1. splitBatch: Splits batches by post date. FE can include multiple post

* dates across multiple fiscal periods in a single journal entry batch.

* NetSuite (the primary external system) requires a journal include only one

* fiscal period. Also resequences the transaction line number.

*/

with splitBatch as (

       select tDist.GL7TRANDISTRIBUTIONSID

              , (

                     /* Converts batch number to a 6-character string with leading zeroes */

                     replicate(

                           '0'

                           , 6 - ceiling(log10(BATCHNUMBER + 1))

                     ) + convert(

                           varchar(20)

                           , BATCHNUMBER

                     )

 

                     /* Converts the transaction post date to a string with format

                        YYYY-MM-DD */

                     + '-'

                     + convert(

                           varchar(20)

                           , t.POSTDATE

                           , 112

                     )

              ) as BatchNumber

              , b.[DESCRIPTION] as BatchDescription

              , row_number() over (

                     partition by t.GL7BATCHESID

                           , t.POSTDATE

                     order by t.[SEQUENCE]

                           , tDist.[SEQUENCE]

              ) as LineNumber

       from FE_SVCF.dbo.GL7TRANSACTIONS as t

              join FE_SVCF.dbo.GL7BATCHES as b on t.GL7BATCHESID = b.GL7BATCHESID

              join FE_SVCF.dbo.GL7TRANSACTIONDISTRIBUTIONS as tDist

                     on t.GL7TRANSACTIONSID = tDist.GL7TRANSACTIONSID

)

 

/*

* Main Query

*/

select tDist.GL7TRANDISTRIBUTIONSID as TransactionSystemID

       , splitBatch.BatchNumber

       , splitBatch.BatchDescription

       , t.POSTDATE as PostDate

       , t.DATEADDED

       , case t.POSTSTATUS

              when 1 then 'Not Yet Posted'

              when 2 then 'Posted'

              when 3 then 'Do Not Post'

       end as PostStatus

       , splitBatch.LineNumber

       , case t.TRANSACTIONTYPE

              when 1 then tDist.AMOUNT

              else null

       end as DebitAmount

       , case t.TRANSACTIONTYPE

              when 2 then tDist.AMOUNT

              else null

       end as CreditAmount

       , a.ACCOUNTNUMBER as FullAccountNumber

       , aRestriction.ID as RestrictionID

       , aRestriction.[DESCRIPTION] as RestricitonName

       , aCode.ACCOUNTCODE as AccountCodeID

       , aCode.[DESCRIPTION] as AccountCodename

       , aCostCenter.ID as CostCenterID

       , aCostCenter.[DESCRIPTION] as CostCenterName

       , p.PROJECTID as FundID

       , p.[DESCRIPTION] as FundName

       , tCode1Pool.ENTRYID as PoolID

       , tCode1Pool.[DESCRIPTION] as PoolName

       , tCode2Funder.ENTRYID as FunderProjectID

       , tCode2Funder.[DESCRIPTION] as FunderProjectName

       , journal.ENTRYID as JournalID

       , journal.[DESCRIPTION] JournalName

       , t.REFERENCE as ReferenceText

       , aMap.ExcludeFromNetSuite

       , aMap.NetSuiteAccount

from FE_SVCF.dbo.GL7TRANSACTIONS as t

       join FE_SVCF.dbo.GL7TRANSACTIONDISTRIBUTIONS as tDist

              on t.GL7TRANSACTIONSID = tDist.GL7TRANSACTIONSID

       join splitBatch

              on tDist.GL7TRANDISTRIBUTIONSID = splitBatch.GL7TRANDISTRIBUTIONSID

       join FE_SVCF.dbo.GL7ACCOUNTS as a

              on t.GL7ACCOUNTSID = a.GL7ACCOUNTSID

      

       /* Extract account code */

       join FE_SVCF.dbo.GL7ACCOUNTCODES as aCode

              on a.GL7ACCOUNTCODESID = aCode.GL7ACCOUNTCODESID

 

       /* Extract restriction from account segment 1 */

       cross apply (

              select case

                           when segment.KEYVALUE like '%1' then 'Unrestricted'

                           when segment.KEYVALUE like '%2' then 'Temporarily Restricted'

                           when segment.KEYVALUE like '%3' then 'Permanently Restricted'

                     end as [DESCRIPTION]

                     , convert(

                           tinyint

                           , substring(

                                  segment.KEYVALUE

                                  , 2

                                  , 1

                           )

                     ) as ID

              from FE_SVCF.dbo.GL7ACCOUNTSEGMENTS as segment

              where segment.GL7ACCOUNTSID = a.GL7ACCOUNTSID

                     and segment.GL7SEGMENTSID = 1                                                               --Restriction

       ) as aRestriction

 

       /* Extract cost center from account segment 3 */

       cross apply (

              select tbl.[DESCRIPTION]

                     , tbl.ENTRYID as ID

       from FE_SVCF.dbo.GL7ACCOUNTSEGMENTS as segment

                     join FE_SVCF.dbo.TABLEENTRIES as tbl

                           on segment.TABLEENTRIESID = tbl.TABLEENTRIESID

              where segment.GL7ACCOUNTSID = a.GL7ACCOUNTSID

                     and segment.GL7SEGMENTSID = 3                                                               --Cost Center

       ) as aCostCenter

 

       /* Join fund (aka "project")

      

          NOTE: Every transactions should have a fund but used an outer join out

          of an abundance of caution. */

       left outer join FE_SVCF.dbo.GL7PROJECTS as p on tDist.GL7PROJECTSID = p.GL7PROJECTSID

 

       /* Join pool transaction code */

       left outer join FE_SVCF.dbo.TABLEENTRIES as tCode1Pool

              on tDist.TRANSACTIONCODE1 = tCode1Pool.TABLEENTRIESID

 

       /* Join funder/project transaction code */

       left outer join FE_SVCF.dbo.TABLEENTRIES as tCode2Funder

              on tDist.TRANSACTIONCODE2 = tCode2Funder.TABLEENTRIESID

 

       /* Join check # transaction code

      

          IGNORE: not migrating to NetSuite */

       --left outer join dbo.TABLEENTRIES as tCode3CheckNum

       --     on tDist.TRANSACTIONCODE3 = tCode3CheckNum.TABLEENTRIESID

 

       /* Join journal code

      

              NOTE: Every transactions should have a journal coed but used an outer

              join out of an abundance of caution. */

       left outer join FE_SVCF.dbo.TABLEENTRIES as journal

              on t.JOURNAL = journal.TABLEENTRIESID

 

       /* Join map FE account code to NS account */

       left outer join FE_SVCF.api.MapAccountCodes as aMap

              on a.GL7ACCOUNTCODESID = aMap.GL7ACCOUNTCODESID

where t.POSTSTATUS = 2                                                                                                  --Posted

       and t.POSTDATE >= '2015-01-01'                                                                            --To include 10 years of transactions assuming a 2022-01 data migration

       and t.DATEADDED between '3/1/2022' and '6/2/2022' -- change the dates - the first date is the last date of the previous db backup; the second date is the date of the latest backup

;

 

 

 

GO
/****** Object:  Table [dbo].[olena_tbl_APPayment]    Script Date: 8/20/2022 3:56:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_APPayment](
	[APPaymentSystemID] [int] NOT NULL,
	[APInvoiceSystemID] [int] NOT NULL,
	[APBankSystemID] [int] NULL,
	[Amount] [numeric](19, 4) NOT NULL,
	[ScheduledPaymentDate] [datetime] NOT NULL,
	[DatePaid] [datetime] NULL,
	[DateVoided] [datetime] NULL,
	[VoidPostDate] [datetime] NULL,
	[Type] [varchar](20) NULL,
	[Status] [varchar](20) NULL,
	[Number] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_APPayment_Delta]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_APPayment_Delta](
	[APPaymentSystemID] [int] NOT NULL,
	[APInvoiceSystemID] [int] NOT NULL,
	[APBankSystemID] [int] NULL,
	[Amount] [numeric](19, 4) NOT NULL,
	[ScheduledPaymentDate] [datetime] NOT NULL,
	[DatePaid] [datetime] NULL,
	[DateVoided] [datetime] NULL,
	[VoidPostDate] [datetime] NULL,
	[Type] [varchar](20) NULL,
	[Status] [varchar](20) NULL,
	[Number] [int] NULL,
	[CheckDateAdded] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_APVendorBill]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_APVendorBill](
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
/****** Object:  Table [dbo].[olena_tbl_APVendorBill_Delta]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_APVendorBill_Delta](
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
	[NetSuiteAccount] [varchar](100) NULL,
	[DateAdded] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_APVendorBillAdjustment_Delta]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_APVendorBillAdjustment_Delta](
	[AP7ADJUSTMENTSID] [int] IDENTITY(1,1) NOT NULL,
	[ADDEDBYID] [int] NOT NULL,
	[ADJUSTMENTDATE] [datetime] NOT NULL,
	[PARENTID] [int] NOT NULL,
	[NEWTRANSACTIONAMOUNT] [numeric](19, 4) NOT NULL,
	[CURRENTTRANSACTIONAMOUNT] [numeric](19, 4) NOT NULL,
	[POSTDATE] [datetime] NOT NULL,
	[REASON] [varchar](50) NOT NULL,
	[NOTES] [varchar](1000) NULL,
	[DATEADDED] [datetime] NOT NULL,
	[DATECHANGED] [datetime] NOT NULL,
	[LASTCHANGEDBYID] [int] NOT NULL,
	[IMPORTID] [varchar](50) NULL,
	[POSTSTATUS] [smallint] NOT NULL,
	[INTERFUNDSETS7ID] [int] NULL,
	[ORIGINALPOSTDATE] [datetime] NULL,
	[AP7SALESTAXITEMSID] [int] NULL,
	[TAXAMOUNT] [numeric](19, 4) NULL,
	[PREVIOUSTAXAMOUNT] [numeric](19, 4) NULL,
	[REBATEAMOUNT] [numeric](15, 3) NULL,
	[ACTIVITYCODEID] [int] NULL,
	[AP7PREVIOUSSALESTAXITEMSID] [int] NULL,
	[PREVIOUSREBATEAMOUNT] [numeric](15, 3) NULL,
	[PREVIOUSACTIVITYCODEID] [int] NULL,
	[PSTREBATEAMOUNT] [numeric](19, 4) NULL,
	[PREVIOUSPSTREBATEAMOUNT] [numeric](19, 4) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_APVendorForMigration]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_APVendorForMigration](
	[VendorSystemID] [int] NOT NULL,
	[VendorID] [varchar](20) NULL,
	[TaxIDNumber] [varchar](64) NULL,
	[FEImportID] [varchar](50) NULL,
	[VendorName] [varchar](60) NOT NULL,
	[VendorSearchName] [varchar](60) NOT NULL,
	[VendorDisplayName] [varchar](60) NOT NULL,
	[CustomerNumber] [varchar](20) NULL,
	[PAYMENTOPTION] [varchar](28) NOT NULL,
	[Status] [varchar](8) NOT NULL,
	[HasCreditLimit] [varchar](1) NULL,
	[CreditLimitAmount] [numeric](19, 4) NULL,
	[DefaultPaymentMethod] [varchar](10) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[DateChanged] [datetime] NOT NULL,
	[VendorBalance] [numeric](19, 4) NULL,
	[HighestBalance] [numeric](19, 4) NOT NULL,
	[CheckNotes] [varchar](95) NULL,
	[DistributedDiscount] [varchar](1) NULL,
	[IsVendor1099] [varchar](1) NULL,
	[TotalPurgedInvoicesAmount] [numeric](19, 4) NULL,
	[TotalPurgedCreditMemosAmount] [numeric](19, 4) NULL,
	[TotalPurgedPOAmount] [numeric](19, 4) NULL,
	[BankName] [varchar](60) NULL,
	[AddressLine1] [varchar](150) NULL,
	[AddressLine2] [varchar](150) NULL,
	[AddressLine3] [varchar](150) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](3) NULL,
	[PostCode] [varchar](12) NULL,
	[IsPrimaryAddress] [varchar](3) NOT NULL,
	[Title] [varchar](60) NULL,
	[Firstname] [varchar](50) NULL,
	[Lastname] [varchar](100) NULL,
	[Fullname] [varchar](255) NULL,
	[BusinessPosition] [varchar](60) NULL,
	[ContactKeyIndicator] [varchar](12) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_Budget]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_Budget](
	[GL7PROJECTBUDGETSID] [int] NOT NULL,
	[GL7ACCOUNTBUDGETSID] [int] NOT NULL,
	[AMOUNT] [numeric](19, 4) NOT NULL,
	[AccountDescription] [varchar](60) NULL,
	[AccountInterenalID] [nvarchar](255) NULL,
	[AccountType] [nvarchar](255) NULL,
	[GL7PROJECTSID] [int] NULL,
	[PROJECTID] [varchar](12) NULL,
	[ProjectDescription] [varchar](60) NULL,
	[FundInternalID] [nvarchar](255) NULL,
	[GL7PROJECTBUDGETDETAILSID] [int] NULL,
	[BudgetPeriod] [nvarchar](34) NULL,
	[STARTDATE] [datetime] NULL,
	[ENDDATE] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_FeeSchedule]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_FeeSchedule](
	[FeeScheduleSystemID] [int] NOT NULL,
	[FeeScheduleID] [varchar](12) NOT NULL,
	[FeeScheduleName] [varchar](60) NULL,
	[FeeAmountMethod] [varchar](29) NULL,
	[FeeAmountMethodFeeTable] [varchar](100) NULL,
	[PostMinimuFeeAs] [varchar](28) NULL,
	[HasMaximumFee] [bit] NULL,
	[MaximumFeeAmount] [numeric](19, 4) NULL,
	[MaximumFeePeriod] [varchar](13) NULL,
	[Frequency] [varchar](20) NULL,
	[BalanceType] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_FeeScheduleAccountCodes]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_FeeScheduleAccountCodes](
	[FeeScheduleSystemID] [int] NULL,
	[AccountCode] [varchar](30) NOT NULL,
	[ExcludeFromNetSuite] [bit] NULL,
	[NetSuiteAccount] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_InvestmentAllocation]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_InvestmentAllocation](
	[InvestmentAllocationSystemID] [int] NULL,
	[Name] [varchar](126) NULL,
	[FundID] [varchar](12) NOT NULL,
	[FundName] [varchar](60) NOT NULL,
	[LineNumber] [bigint] NULL,
	[InvestmentPool] [varchar](50) NULL,
	[PercentTarget] [numeric](15, 2) NULL,
	[DollarTarget] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[olena_tbl_JournalEntryTransaction]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_JournalEntryTransaction](
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
/****** Object:  Table [dbo].[olena_tbl_JournalEntryTransaction_Delta]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_JournalEntryTransaction_Delta](
	[TransactionSystemID] [int] NOT NULL,
	[BatchNumber] [varchar](8000) NULL,
	[BatchDescription] [varchar](60) NULL,
	[PostDate] [datetime] NOT NULL,
	[DATEADDED] [datetime] NOT NULL,
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
/****** Object:  Table [dbo].[olena_tbl_SpendingPolicies]    Script Date: 8/20/2022 3:56:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[olena_tbl_SpendingPolicies](
	[SpendingPolicyId] [int] IDENTITY(1,1) NOT NULL,
	[BalanceType] [varchar](50) NULL,
	[Rate] [decimal](18, 2) NULL,
	[Description] [varchar](200) NULL,
	[NumberOfQuarters] [int] NULL,
	[QuarterEnd] [varchar](5) NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [Netsuite_FE_Extracts] SET  READ_WRITE 
GO
