DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log(
    dt              varchar(255)
  , order_id        integer
  , user_id         varchar(255)
  , purchase_amount integer
);

INSERT INTO purchase_log
VALUES
    ('2014-01-01',  1, 'rhwpvvitou', 13900)
  , ('2014-01-01',  2, 'hqnwoamzic', 10616)
  , ('2014-01-02',  3, 'tzlmqryunr', 21156)
  , ('2014-01-02',  4, 'wkmqqwbyai', 14893)
  , ('2014-01-03',  5, 'ciecbedwbq', 13054)
  , ('2014-01-03',  6, 'svgnbqsagx', 24384)
  , ('2014-01-03',  7, 'dfgqftdocu', 15591)
  , ('2014-01-04',  8, 'sbgqlzkvyn',  3025)
  , ('2014-01-04',  9, 'lbedmngbol', 24215)
  , ('2014-01-04', 10, 'itlvssbsgx',  2059)
  , ('2014-01-05', 11, 'jqcmmguhik',  4235)
  , ('2014-01-05', 12, 'jgotcrfeyn', 28013)
  , ('2014-01-05', 13, 'pgeojzoshx', 16008)
  , ('2014-01-06', 14, 'msjberhxnx',  1980)
  , ('2014-01-06', 15, 'tlhbolohte', 23494)
  , ('2014-01-06', 16, 'gbchhkcotf',  3966)
  , ('2014-01-07', 17, 'zfmbpvpzvu', 28159)
  , ('2014-01-07', 18, 'yauwzpaxtx',  8715)
  , ('2014-01-07', 19, 'uyqboqfgex', 10805)
  , ('2014-01-08', 20, 'hiqdkrzcpq',  3462)
  , ('2014-01-08', 21, 'zosbvlylpv', 13999)
  , ('2014-01-08', 22, 'bwfbchzgnl',  2299)
  , ('2014-01-09', 23, 'zzgauelgrt', 16475)
  , ('2014-01-09', 24, 'qrzfcwecge',  6469)
  , ('2014-01-10', 25, 'njbpsrvvcq', 16584)
  , ('2014-01-10', 26, 'cyxfgumkst', 11339)
;

select dt 
	 , count(*) as order
	 , sum(purchase_amount ) as amt
	 , round(avg(purchase_amount ),1) as avg_amt
	 , round(avg(sum(purchase_amount)) over (order by dt rows between 6 preceding and current row),1)  -- 최근 7일 동안의 이동평균
	 , ROUND(case when 7=count(*) over  (order by dt rows between 6 preceding and current row)
	 		then avg(sum(purchase_amount)) over (order by dt rows between 6 preceding and current row) end,1) as SEVEN_DAY_AVG   -- 정확한 최근 7일동안 이동평균
from purchase_log a
group by 1 
order by 1 



select dt 	
	  , SUBSTR(DT,1,7) as year
	  , SUM(purchase_amount ) as AMT
	  , SUM(SUM(purchase_amount )) over (partition by SUBSTR(DT,1,7) order by dt rows unbounded PRECEDING)
From purchase_log A
group by 1,2

select dt 	
	  , substr(dt,1,4) as year
	  , substr(dt,6,2) as month
	  , substr(dt,9,2) as dd
	  , sum(purchase_amount ) as amt
	  , count(distinct order_id ) as orders
from purchase_log a
group by 1,2,3,4
order by 1,2,3,4


select dt 
	 , substr(dt,1,7) as year_month
	 , sum(purchase_amount ) as amt
	 , sum(sum(purchase_amount )) over (partition by substr(dt,1,7) order by dt rows unbounded preceding ) as agg_amt
from purchase_log  a
group by 1,2
order by 1,2


with daily_purchase as (select dt 	
	  , substr(dt,1,4) as year
	  , substr(dt,6,2) as month
	  , substr(dt,9,2) as dd
	  , sum(purchase_amount ) as amt
	  , count(distinct order_id ) as orders
from purchase_log a
group by 1,2,3,4
order by 1,2,3,4)
select month 
	 , sum(case year when '2014' then amt end) as amt_2014
	 , sum(case year when '2015' then amt end) as amt_2015
from daily_purchase
group by 1 
order by 1


with daily_purchase as (select dt 	
	  , substr(dt,1,4) as year
	  , substr(dt,6,2) as month
	  , substr(dt,9,2) as dd
	  , sum(purchase_amount ) as amt
	  , count( order_id ) as orders
from purchase_log a
group by 1,2,3,4
order by 1,2,3,4)
select substr(dt,1,7) as month 
	 , avg(amt) as avg_amt
from daily_purchase 
group by 1 
order by 1


DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log(
    dt           varchar(255)
  , order_id     integer
  , user_id      varchar(255)
  , item_id      varchar(255)
  , price        integer
  , category     varchar(255)
  , sub_category varchar(255)
);

INSERT INTO purchase_detail_log
VALUES
    ('2017-01-18', 48291, 'usr33395', 'lad533', 37300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48291, 'usr33395', 'lad329', 97300,  'ladys_fashion', 'jacket')
  , ('2017-01-18', 48291, 'usr33395', 'lad102', 114600, 'ladys_fashion', 'jacket')
  , ('2017-01-18', 48291, 'usr33395', 'lad886', 33300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48292, 'usr52832', 'dvd871', 32800,  'dvd'          , 'documentary')
  , ('2017-01-18', 48292, 'usr52832', 'gam167', 26000,  'game'         , 'accessories')
  , ('2017-01-18', 48292, 'usr52832', 'lad289', 57300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48293, 'usr28891', 'out977', 28600,  'outdoor'      , 'camp')
  , ('2017-01-18', 48293, 'usr28891', 'boo256', 22500,  'book'         , 'business')
  , ('2017-01-18', 48293, 'usr28891', 'lad125', 61500,  'ladys_fashion', 'jacket')
  , ('2017-01-18', 48294, 'usr33604', 'mem233', 116300, 'mens_fashion' , 'jacket')
  , ('2017-01-18', 48294, 'usr33604', 'cd477' , 25800,  'cd'           , 'classic')
  , ('2017-01-18', 48294, 'usr33604', 'boo468', 31000,  'book'         , 'business')
  , ('2017-01-18', 48294, 'usr33604', 'foo402', 48700,  'food'         , 'meats')
  , ('2017-01-18', 48295, 'usr38013', 'foo134', 32000,  'food'         , 'fish')
  , ('2017-01-18', 48295, 'usr38013', 'lad147', 96100,  'ladys_fashion', 'jacket')
 ;


--ROLLUP을 사용해서 카테고리별 매출과 소계를 동시에 구하는 쿼리

select coalesce(category, 'all') as category
	 , coalesce(sub_category,'all') as sub_category
	 , sum(price) as amount
from purchase_detail_log
group by rollup(category, sub_category`)


DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log(
    dt           varchar(255)
  , order_id     integer
  , user_id      varchar(255)
  , item_id      varchar(255)
  , price        integer
  , category     varchar(255)
  , sub_category varchar(255)
);

INSERT INTO purchase_detail_log
VALUES
    ('2017-01-18', 48291, 'usr33395', 'lad533', 37300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48291, 'usr33395', 'lad329', 97300,  'ladys_fashion', 'jacket')
  , ('2017-01-18', 48291, 'usr33395', 'lad102', 114600, 'ladys_fashion', 'jacket')
  , ('2017-01-18', 48291, 'usr33395', 'lad886', 33300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48292, 'usr52832', 'dvd871', 32800,  'dvd'          , 'documentary')
  , ('2017-01-18', 48292, 'usr52832', 'gam167', 26000,  'game'         , 'accessories')
  , ('2017-01-18', 48292, 'usr52832', 'lad289', 57300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48293, 'usr28891', 'out977', 28600,  'outdoor'      , 'camp')
  , ('2017-01-18', 48293, 'usr28891', 'boo256', 22500,  'book'         , 'business')
  , ('2017-01-18', 48293, 'usr28891', 'lad125', 61500,  'ladys_fashion', 'jacket')
  , ('2017-01-18', 48294, 'usr33604', 'mem233', 116300, 'mens_fashion' , 'jacket')
  , ('2017-01-18', 48294, 'usr33604', 'cd477' , 25800,  'cd'           , 'classic')
  , ('2017-01-18', 48294, 'usr33604', 'boo468', 31000,  'book'         , 'business')
  , ('2017-01-18', 48294, 'usr33604', 'foo402', 48700,  'food'         , 'meats')
  , ('2017-01-18', 48295, 'usr38013', 'foo134', 32000,  'food'         , 'fish')
  , ('2017-01-18', 48295, 'usr38013', 'lad147', 96100,  'ladys_fashion', 'jacket')
 ;






--ABC 분석
with temp as 
(select category
	 , sum(price) as amt
from purchase_detail_log
group by 1 order by 1 )  
,temp2 as 
(select * 
	 , 100*amt/sum(amt) over () as ratio
	 , (sum(amt) over (order by amt desc rows between unbounded preceding and current row)/sum(amt) over())*100 as com_ratio
from temp)
select *
	 , case when com_ration 
from temp2


-- 팬 차트로 상품의 매출 증가율 확인하기

DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log(
    dt           varchar(255)
  , order_id     integer
  , user_id      varchar(255)
  , item_id      varchar(255)
  , price        integer
  , category     varchar(255)
  , sub_category varchar(255)
);

INSERT INTO purchase_detail_log
VALUES
    ('2017-01-18', 48291, 'usr33395', 'lad533', 37300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48291, 'usr33395', 'lad329', 97300,  'ladys_fashion', 'jacket')
  , ('2017-01-18', 48291, 'usr33395', 'lad102', 114600, 'ladys_fashion', 'jacket')
  , ('2017-01-18', 48291, 'usr33395', 'lad886', 33300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48292, 'usr52832', 'dvd871', 32800,  'dvd'          , 'documentary')
  , ('2017-01-18', 48292, 'usr52832', 'gam167', 26000,  'game'         , 'accessories')
  , ('2017-01-18', 48292, 'usr52832', 'lad289', 57300,  'ladys_fashion', 'bag')
  , ('2017-01-18', 48293, 'usr28891', 'out977', 28600,  'outdoor'      , 'camp')
  , ('2017-01-18', 48293, 'usr28891', 'boo256', 22500,  'book'         , 'business')
  , ('2017-01-18', 48293, 'usr28891', 'lad125', 61500,  'ladys_fashion', 'jacket')
  , ('2017-01-18', 48294, 'usr33604', 'mem233', 116300, 'mens_fashion' , 'jacket')
  , ('2017-01-18', 48294, 'usr33604', 'cd477' , 25800,  'cd'           , 'classic')
  , ('2017-01-18', 48294, 'usr33604', 'boo468', 31000,  'book'         , 'business')
  , ('2017-01-18', 48294, 'usr33604', 'foo402', 48700,  'food'         , 'meats')
  , ('2017-01-18', 48295, 'usr38013', 'foo134', 32000,  'food'         , 'fish')
  , ('2017-01-18', 48295, 'usr38013', 'lad147', 96100,  'ladys_fashion', 'jacket')
  ,    ('2017-02-18', 48291, 'usr33395', 'lad533', 45000,  'ladys_fashion', 'bag')
  , ('2017-02-18', 48291, 'usr33395', 'lad329', 99000,  'ladys_fashion', 'jacket')
  , ('2017-02-18', 48291, 'usr33395', 'lad102', 150000, 'ladys_fashion', 'jacket')
  , ('2017-02-18', 48291, 'usr33395', 'lad886', 40000,  'ladys_fashion', 'bag')
  , ('2017-02-18', 48292, 'usr52832', 'dvd871', 71000,  'dvd'          , 'documentary')
  , ('2017-02-18', 48292, 'usr52832', 'gam167', 30000,  'game'         , 'accessories')
  , ('2017-02-18', 48292, 'usr52832', 'lad289', 59300,  'ladys_fashion', 'bag')
  , ('2017-02-18', 48293, 'usr28891', 'out977', 59900,  'outdoor'      , 'camp')
  , ('2017-02-18', 48293, 'usr28891', 'boo256', 33400,  'book'         , 'business')
  , ('2017-02-18', 48293, 'usr28891', 'lad125', 67700,  'ladys_fashion', 'jacket')
  , ('2017-02-18', 48294, 'usr33604', 'mem233', 117600, 'mens_fashion' , 'jacket')
  , ('2017-02-18', 48294, 'usr33604', 'cd477' , 27800,  'cd'           , 'classic')
  , ('2017-02-18', 48294, 'usr33604', 'boo468', 37000,  'book'         , 'business')
  , ('2017-02-18', 48294, 'usr33604', 'foo402', 49900,  'food'         , 'meats')
  , ('2017-02-18', 48295, 'usr38013', 'foo134', 37000,  'food'         , 'fish')
  , ('2017-02-18', 48295, 'usr38013', 'lad147', 99700,  'ladys_fashion', 'jacket')
 ;

select * 
from purchase_detail_log a

with temp as 
(select substr(dt,1,7) as year_month
	 , 	category 
	 ,  sum(price) as amt
from purchase_detail_log a
group by 1,2 
order by 1,2)
select *
	 , first_value(amt) over (partition by category order by year_month,category rows unbounded preceding ) as base_amt
	 , round((amt/first_value(amt) over (partition by category order by year_month,category rows unbounded preceding ))*100.0,2) as rate
from temp 



