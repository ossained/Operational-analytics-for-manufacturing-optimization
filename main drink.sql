
/*Downtime Causes (Identifying Reasons for Delays)
Goal: Identify downtime factors and their impacts on production efficiency.
What are the main downtime factors (operator error, equipment failure, etc.)?
Which downtime factors are most frequent across products?
How does downtime affect the overall production timeline for each product?
What is the average downtime per batch for each downtime factor?
Which downtime factors lead to the longest delays in production?*/

select * from data_dictionary
select * from Downtine_Factors
select * from Line_Downtime
select * from Line_Productivity
select * from Products



--1. Identify downtime factors and their impacts on production efficiency.
with cte as 
(select 1 AS factor, sum(case when downtime_factor1>0 then downtime_factor1 else 0 end ) as total_Downtime from line_downtime
union all
select 2 , sum(case when downtime_factor2>0 then downtime_factor2 end ) from line_downtime
union all
select 3 , sum(case when downtime_factor3>0 then Downtime_Factor3 end ) from line_downtime
union all
select 4 , sum(case when downtime_factor4>0 then Downtime_Factor4 end ) from line_downtime
union all
select 5, sum(case when downtime_factor5>0 then Downtime_Factor5 end ) from line_downtime
union all
select 6, sum(case when downtime_factor6>0 then Downtime_Factor6  end ) from line_downtime
union all
select 7, sum(case when downtime_factor7>0 then Downtime_Factor7  end ) from line_downtime
union all
select 8, sum(case when downtime_factor8>0 then Downtime_Factor8 end ) from line_downtime
union all
select 9, sum(case when downtime_factor9>0 then Downtime_Factor9 end ) from line_downtime
union all
select 10, sum(case when downtime_factor10>0 then Downtime_Factor10 end ) from line_downtime
union all
select 11, sum(case when downtime_factor11>0 then Downtime_Factor11 end ) from line_downtime
union all
select 12, sum(case when downtime_factor12>0 then Downtime_Factor12 end ) from line_downtime)



select * from cte ct
join Downtine_Factors df on ct.factor= cast(df.factor as int)
order by total_downtime desc


--2.What are the main downtime factors (operator error, equipment failure, etc.)?
with count_no as (
select 1 AS factor, count(case when downtime_factor1 >0 then downtime_factor1  end ) as total_Downtime from Line_Downtime
union all
select 2 , count(case when downtime_factor2>0 then downtime_factor2 end ) from line_downtime
union all
select 3 , count(case when downtime_factor3>0 then Downtime_Factor3 end ) from line_downtime
union all
select 4 , count(case when downtime_factor4>0 then Downtime_Factor4 end ) from line_downtime
union all
select 5, count(case when downtime_factor5>0 then Downtime_Factor5 end ) from line_downtime
union all
select 6, count(case when downtime_factor6>0 then Downtime_Factor6  end ) from line_downtime
union all
select 7, count(case when downtime_factor7>0 then Downtime_Factor7  end ) from line_downtime
union all
select 8, count(case when downtime_factor8>0 then Downtime_Factor8 end ) from line_downtime
union all
select 9, count(case when downtime_factor9>0 then Downtime_Factor9 end ) from line_downtime
union all
select 10, count(case when downtime_factor10>0 then Downtime_Factor10 end ) from line_downtime
union all
select 11, count(case when downtime_factor11>0 then Downtime_Factor11 end ) from line_downtime
union all
select 12, count(case when downtime_factor12>0 then Downtime_Factor12 end ) from line_downtime)



select * from count_no cn
join Downtine_Factors df on cn.factor= cast(df.factor as int)
order by total_downtime desc






--3.Which downtime factors are most frequent across products?

WITH cleaned_data AS (
    SELECT 
        Batch,
        cast(downtime_Factor1 as float) AS "1",
        cast(downtime_Factor2 as float) AS "2",
        cast(downtime_Factor3 as float) AS "3",
         cast(downtime_Factor4 as float) AS "4",
        cast(downtime_Factor5 as float) AS "5",
         cast(Downtime_Factor6 as float) AS "6",
         cast(Downtime_Factor7 as float) AS "7",
         cast(Downtime_Factor8 as float) AS "8",
         cast(Downtime_Factor9 as float) AS "9",
         cast(Downtime_Factor10 as float) AS "10",
       cast(Downtime_Factor11 as float) AS "11",
         cast(Downtime_Factor11 as float) AS "12"
    FROM line_downtime
	)

SELECT 
    Batch,
    Factor,
    Downtime_Minutes
FROM cleaned_data
UNPIVOT (Downtime_Minutes FOR Factor IN ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
) AS unpivoted_data

create table line_downtime1(batch int,
                            factor tinyint,
							downtime_minutes int)
insert into line_downtime1(batch,factor,downtime_minutes)
select batch,factor,downtime_minutes from (

    SELECT 
        Batch,
        cast(downtime_Factor1 as float) AS "1",
        cast(downtime_Factor2 as float) AS "2",
        cast(downtime_Factor3 as float) AS "3",
         cast(downtime_Factor4 as float) AS "4",
        cast(downtime_Factor5 as float) AS "5",
         cast(Downtime_Factor6 as float) AS "6",
         cast(Downtime_Factor7 as float) AS "7",
         cast(Downtime_Factor8 as float) AS "8",
         cast(Downtime_Factor9 as float) AS "9",
         cast(Downtime_Factor10 as float) AS "10",
       cast(Downtime_Factor11 as float) AS "11",
         cast(Downtime_Factor11 as float) AS "12"
    FROM line_downtime
	) as cleaned_data

UNPIVOT (Downtime_Minutes FOR Factor IN ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
) AS unpivoted_data
with product_downtime as (

select lp.product,sum(downtime_minutes )as total_downtime from line_downtime1 ld
left join Line_Productivity lp on ld.batch = lp.Batch
group by lp.product
),


total_minute as (
select sum(downtime_minutes) as total_minute from line_downtime1)

select product, (total_downtime *100.0)/total_minute as percentage
from total_minute,product_downtime 
order by percentage desc


select df.Description,sum(ld.downtime_minutes)as totalminute from Line_Productivity lp
inner join line_downtime1 ld on lp.Batch = ld.batch
inner join Downtine_Factors df on ld.factor = df.Factor
where Product = 'co-600'
group by df.Description
order by totalminute desc






select column_name, data_type from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME ='line_productivity' and COLUMN_NAME= 'batch'


select product,avg(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME))))
			from line_productivity
			where Product= 'co-600'
			group by product


select product,sum(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME))))
			from line_productivity
			where Product= 'co-600'
			group by product    



with production_min as (
select product,sum(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))) as total_production_min
			from line_productivity
			group by product),

avg_time as (
select product,avg(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))) as avg_production_min
			from line_productivity
			group by product),
total_downtime as (

select ld.batch,sum(downtime_minutes) as total_downtime from line_downtime1 ld
group by ld.batch),
 total as (
 select sum(downtime_minutes)as overall from line_downtime1),
product_downtime as (


 select Product,sum(downtime_minutes) as total_downtime_min from Line_Productivity lp
 join line_downtime1 ld on lp.Batch = ld.batch
 group by product),

 downtime_cnt as (
 select product,count(ld.batch) as cnt_batchdowntime from line_downtime1 ld
 join Line_Productivity lp on ld.batch = lp.Batch
 where downtime_minutes >0
 group by product),

 total_batch as (
 select product,count(batch) as total_batch from Line_Productivity
 group by Product),

 major_factor as (
 select lp.Product,description,(sum(downtime_minutes)  over (partition by product,description order by downtime_minutes desc)) as dowmtime_cause from line_downtime1 ld
 inner join Line_Productivity lp on ld.batch = lp.Batch
 left join Downtine_Factors df  on ld.factor = df.Factor
 group by lp.Product,description


select pd.product,total_downtime_min,
(total_downtime_min * 100.0) / t.overall as percentage,total_production_min,
avg_production_min,cnt_batchdowntime,total_batch,round(cast(total_batch as float )* 100.0 /nullif(cnt_batchdowntime,0),2)as batch_failure_rate
from product_downtime pd
cross join total t left join production_min pm on pd.product = pm.product 
left join avg_time at on at.product =pm.product 
left join downtime_cnt dc on dc.product = pd.product
left join total_batch tb on pm.product = tb.product
order by cnt_batchdowntime desc












