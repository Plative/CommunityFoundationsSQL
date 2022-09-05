USE [Netsuite_Staging]
GO

/****** Object:  View [dbo].[JEline]    Script Date: 4/4/2022 11:46:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[JEline] as 
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


