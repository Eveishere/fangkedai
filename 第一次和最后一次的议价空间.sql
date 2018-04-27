select 
total.partname as `大区`
,avg(total.order_price) as `成交均价`
,avg(total.gpj) as `成交前最后一次挂牌均价`
,avg(total.total_price) as `成交前第一次挂牌均价`
FROM
(select 
A4.partname
,A1.orderid
,A1.order_price
,A2.total_price as gpj
,A5.from_date
,A5.end_date
,A5.total_price
,row_number()over(partition by A1.orderid order by A5.from_date) as zx
from 
(select 
order_date,housedelcode,branchid,orderid,order_price
from ods.ods_dooioodw_meacasedetail_da
where pt=20180422000000 and trading_type='二手' and casecompany='德佑' and order_date between '2018-02-01' and '2018-04-01') A1
inner join
(select housedel_id,total_price,creator_time
 from dw.dw_housedel_housedel_all_info_branch_da where pt=20180422000000) A2 on A2.housedel_id=A1.housedelcode
inner join
(select rpt_date,branchid,storeid from ods.ods_dooioodw_dimbranchbak_da where pt=20180422000000) A3 on A3.branchid=A1.branchid
and A3.rpt_date=A1.order_date
inner join
(select partname,buname,storeid from ods.ods_dooioodw_dimstore_da where pt=20180422000000) A4 on A4.storeid=A3.storeid
left join
(select 
housedel_id,from_date,end_date,total_price
from olap.olap_house_SCD_di  -- iseedeadpeople
where from_date<='2018-04-01' and end_date>='2018-01-01') A5 on A5.housedel_id=A1.housedelcode and A1.order_price<>A5.total_price
and A5.from_date<=date_add(A1.order_date,1) and to_date(A5.end_date)>=to_date(A2.creator_time)) total
where total.zx=1
group by total.partname
