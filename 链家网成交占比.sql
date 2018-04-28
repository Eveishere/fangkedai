select
A5.buname
,A5.partname
,A5.storename
,count(1) as `总成交量`,
sum(case when A3.contact_channel<>'非链家网' then 1 else 0 end) as `链家网成交量`,
sum(case when A3.contact_channel<>'非链家网' then 1 else 0 end)/count(1) as `链家网成交占比`
FROM
(select 
1000000000000000+case_id as caseid,order_date,branchid
from ods.ods_dooioodw_meacasedetail_da 
where pt=20180427000000 and trading_type='二手' and status='签约' and year(sign_date)=2018 and month(sign_date)=4
and casecompany='德佑') A1    -- 从meacasedetail读取签约案源明细，并处理caseid
inner join 
(select order_id,agreement_no from dw.dw_allinfo_agr_agreement_da where pt=20180427000000 and status<>'合同-无效') 
A2 on A2.order_id=A1.caseid  -- 匹配北京的案源表，获取agreement_no
inner join 
(select * from rpt.rpt_ssrp_lianjia_contract_di where pt=20180427000000 and contract_status<>'合同-无效') 
A3 on A3.contract_no=A2.agreement_no  -- 通过agreement_no匹配到链家网成交明细表，找到成交渠道
inner join
(select branchid,fromdate,enddate,storeid from ods.ods_dooioodw_dimbranchhistory_da where pt=20180427000000) 
A4 on A4.branchid=A1.branchid and order_date>=fromdate and order_date<=date_add(enddate,1) -- 匹配成交的组织架构
inner join
(select partname,storename,buname,storeid from ods.ods_dooioodw_dimstore_da where pt=20180427000000) A5 on A5.storeid=A4.storeid
group by buname,partname,storename
order by sum(case when A3.contact_channel<>'非链家网' then 1 else 0 end)/count(1) desc
