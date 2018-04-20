select 
total.buname as `事业部`,
total.partname as `大区`,
cast(sum(case when total.buynum=0 then 0 else total.empbuyhousenum*1.0/total.buynum end) as decimal(10,2)) as `人均买卖新增房`,
cast(sum(case when total.rentnum=0 then 0 else total.emprenthousenum*1.0/total.rentnum end) as decimal(10,2)) as `人均租赁新增房`,
cast(sum(case when total.buynum=0 then 0 else total.empbuycusnum*1.0/total.buynum end) as decimal(10,2)) as `人均买卖新增客`,
cast(sum(case when total.rentnum=0 then 0 else total.emprentcusnum*1.0/total.rentnum end) as decimal(10,2)) as `人均租赁新增客`,
cast(sum(case when total.buynum=0 then 0 else total.empbuyshownum*1.0/total.buynum end) as decimal(10,2)) as `人均买卖带看`,
cast(sum(case when total.rentnum=0 then 0 else total.emprentshownum*1.0/total.rentnum end) as decimal(10,2)) as `人均租赁带看`
from 
(select 
A1.rptdate,A1.buname,A1.partname,
sum(case when isrentalbroker=1 then 1 else 0 end) as rentnum,
sum(case when isrentalbroker=0 then 1 else 0 end) as buynum,
sum(case when isrentalbroker=1 then A2.renthousecnt else 0 end) as emprenthousenum,
sum(case when isrentalbroker=0 then A2.buyhousecnt else 0 end) as empbuyhousenum,
sum(case when isrentalbroker=1 then A2.rentcustcnt else 0 end) as emprentcusnum,
sum(case when isrentalbroker=0 then A2.buycustcnt else 0 end) as empbuycusnum,
sum(case when isrentalbroker=1 then A2.rentshowcnt else 0 end) as emprentshownum,
sum(case when isrentalbroker=0 then A2.buyshowcnt else 0 end) as empbuyshownum
from 
(select 
regexp_replace(substr(rpt_date,1,10),'-','') as rptdate,
buname,partname,storename,branchname,
case when length(cast(empid as string)) = 5 then concat('220',cast(empid as string))
when length(cast(empid as string)) = 6 then concat('22',cast(empid as string))
else cast(empid as string) end as empid,
case when isrentalbroker=0 and titledegreenew='M2' then 1 else isrentalbroker end as isrentalbroker
from ods.ods_dooioodw_dimempbak_da 
where pt=20180312000000 and to_date(rpt_date) between '2018-03-01' and '2018-03-11' and statetag in (2,8) and rolename='经纪人'
and buname like '沪%') A1 --- 取出这段时间每天在职的经纪人
left join
(select stat_date,user_code,
sum(case when biz_type in (1000000000001,1000000000003) then housedel_cnt else 0 end) as buyhousecnt,
sum(case when biz_type=1000000000002 then housedel_cnt else 0 end) as renthousecnt,
sum(case when biz_type in (1000000000001,1000000000003) then custdel_cnt else 0 end) as buycustcnt,
sum(case when biz_type=1000000000002 then custdel_cnt else 0 end) as rentcustcnt,
sum(case when biz_type in (1000000000001,1000000000003) then showing_cnt else 0 end) as buyshowcnt,
sum(case when biz_type =1000000000002 then showing_cnt else 0 end) as rentshowcnt
from olap.olap_sh_work_agent_di 
where stat_date between '20180301' and '20180312'
group by stat_date,user_code) A2 on A2.user_code=A1.empid and A2.stat_date=rptdate
group by A1.rptdate,A1.buname,A1.partname) total
group by total.buname,total.partname
