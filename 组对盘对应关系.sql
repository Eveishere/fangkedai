select 
distinct
A3.resblock_name as `楼盘`,
A3.resblock_id as `楼盘ID`,
A4.team_name as `责任分行`,
A4.shop_name as `责任门店`,
A4.marketing_name as `责任大区`,
A4.region_name as `责任事业部`
from
(select 
team_code,
entity_id
from dw.dw_house_groupdiv_da
where pt='20180223000000' and is_valid='1' and div_type_code='110030001' and city_code='310000') A1
inner join (
select building_id,resblock_id 
from dw.dw_house_building_da     ----匹配楼盘 
where pt='20180223000000'
)A2 on A2.building_id=A1.entity_id
left join (
select resblock_id,	resblock_name 
from dw.dw_house_resblock_da   ---找到楼盘名
where pt='20180223000000'
) A3 on A2.resblock_id=A3.resblock_id
inner join (
select distinct region_name,marketing_name,team_code,team_name,shop_name
 from dw.dw_uc_agent_all_info_branch_da  
where pt='20180223000000'
and corp_code='SH8888'
)A4 on A1.team_code=A4.team_code
order by 
A4.region_name,A4.marketing_name,A4.shop_name,A4.team_name

