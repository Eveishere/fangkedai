select
A1.month as `月份`,
A1.partname as `成交大区`,
A1.case_no as `案源编号`,
round(A2.build_area,2)  as `面积`,
A2.stat_function as `物业类型`,
A2.level as `房源等级`,
A1.order_date as `转定日期`,
round(A1.order_price,2) as `转定价`,
A2.creator_time as `录入日期`,
round(A2.total_price,2) as `挂牌价格`,
case when A1.order_price>A2.total_price then '涨价' when A1.order_price<A2.total_price then '降价' else '不变' end as `调价情况`,
A4.circlename as `房源所在商圈`,
A5.company25 as `楼盘宫格`
from
(select 
month(order_date) as month,partname,case_no,housedelcode,order_price,order_date
from ods.ods_dooioodw_meacasedetail_da 
where pt=20180402000000 and casecompany='德佑' and trading_type='二手' and year(order_date)=2018) A1
inner join 
(select housedel_id,build_area,stat_function,total_price/10000 as total_price,creator_time,hdic_house_id,
case when house_rank='201000000001' then 'A' when house_rank='201000000002' then 'B' else 'C' end as level
 from dw.dw_housedel_housedel_all_info_branch_da where pt=20180402000000) A2 on A2.housedel_id=A1.housedelcode
inner join 
(select house_id,building_id,resblock_id from dw.dw_house_house_da where pt=20180402000000) A3 on A3.house_id=A2.hdic_house_id
left join 
(select buildingid,circlename from ods.ods_dooioodw_dimmapareadrawunit_da where pt=20180402000000) A4 
on A4.buildingid=A3.building_id
left join
(select resblockid,company25 from ods.ods_dooioodw_dimfocalestatebak_da 
 where pt=20180402000000 and bakdate='2018-01-29 18:45:30') A5 on A5.resblockid=A3.resblock_id