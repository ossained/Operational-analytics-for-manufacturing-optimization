
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


---TOTAL PRODUCTION TIME---
drop view Drinks

create view drinks as 
with production_min as (
select product,sum(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))) as total_production_min
			from line_productivity
			group by  product),
----AVERAGE PRODUCTION TIME FOR EACH PRODUCT---
avg_time as (
select product,avg(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))) as avg_production_min
			from line_productivity
			group by product),

--TOTAL DOWNTIME FOR EACH BATCH---
total_downtime as (
select ld.batch,sum(downtime_minutes) as total_downtime from line_downtime1 ld
group by ld.batch),

--OVERALL DOWNTIME----
 total as (
 select sum(downtime_minutes)as overall from line_downtime1),

 ---TOTAL DOWNTIME BY PRODUCT--
product_downtime as (
select lp.Product,sum(downtime_minutes) as total_downtime_min from Line_Productivity lp
 join line_downtime1 ld on lp.Batch = ld.batch
 group by product),

 --COUNT OF DOWNTIME---
 downtime_cnt as (
 select product,count(ld.batch) as cnt_batchdowntime from line_downtime1 ld
 join Line_Productivity lp on ld.batch = lp.Batch
 where downtime_minutes >0
 group by product),

 
 ----COUNT OF BATCHES--
 total_batch as (
 select product,count(batch) as total_batch from Line_Productivity
 group by Product),

 --CAUSE OF DOWNTIME---
 major_factor as (
 select lp.Product,description,sum(downtime_minutes)as total_downtime,rank()  over (partition by product order by sum(downtime_minutes) desc) as downtime_cause from line_downtime1 ld
 inner join Line_Productivity lp on ld.batch = lp.Batch
 left join Downtine_Factors df  on ld.factor = df.Factor
 group by lp.Product,description),

 downtime_cause as (
 select product,description,total_downtime from major_factor
 where downtime_cause =1),

--AFFECTED BATCHES----
 affected_batches as (
 select product, count(distinct lp.Batch)as affected_batches from line_downtime1 ld
 left join line_productivity lp on ld.batch = lp.batch
 where downtime_minutes>0
 group by Product)

 
-----MAIN INSIGHT----
--main_insight as (
select pd.product as product ,pd.total_downtime_min as total_downtime_min,
(pd.total_downtime_min * 100.0) / nullif(t.overall,0) as percentage_of_totaldowntime,pm.total_production_min,
at.avg_production_min,dc.cnt_batchdowntime,tb.total_batch,round(cast(ab.affected_batches as float)* 100.0 /nullif(tb.total_batch,0 ),2)as batch_failure_rate,
de.description ,affected_batches,round(cast(affected_batches as float)*100.0 /tb.total_batch,2) as percentage_affected_batches
from product_downtime pd
cross join total t 
left join production_min pm on pd.product = pm.product 
left join avg_time at on at.product =pm.product 
left join downtime_cnt dc on dc.product = pd.product
left join total_batch tb on pm.product = tb.product
left join downtime_cause de on pd.product =de.product 
left join affected_batches ab on pd.product =ab.product
order by total_downtime_min desc


select distinct* from drinks
),



--time_diff as (
select ms.Product,sum(total_downtime_min) as total_downtime_min,sum(Min_batch_time) as Min_batch_time,
 sum(total_downtime_min) / sum(Min_batch_time) as total_batchloss
 from main_insight ms
left join Products p on ms.product = p.Product
where ms.product in ('co-600','rb-600','co-2l')
group by ms.product),

percentage_3products as (
select sum(total_downtime_min)* 100.0 / (
 select sum(downtime_minutes)as overall from line_downtime1) as percentage_3proda ucts  from time_diff),

 select sum(total_downtime_min) from time_diff

 select * from Products


select lp.Batch,Start_Time,End_Time,Description,Operator_Error from line_downtime1 ld
join Line_Productivity lp on ld.batch = lp.Batch
join Downtine_Factors df on ld.factor = df.Factor
where Description in ('machine failure' , 'machine adjustment') 

with production_loss as (
select lp.Product,sum(downtime_minutes) as total_downtime_min 
from Line_Productivity lp
 join line_downtime1 ld on lp.Batch = ld.batch
 group by lp.product),

 gain as (
 select pl.Product,total_downtime_min,min_batch_time, total_downtime_min /min_batch_time as losses from production_loss pl
 left join products p on pl.product = p.product
 ),
 overall_gain as (
select lp.Product,sum(DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))) as total_production_min,
			g.total_downtime_min,g.total_downtime_min * 0.2 as min_gain,min_batch_time
			from line_productivity lp
			inner join gain g on lp.Product =g.product
			group by lp.Product ,g.total_downtime_min,Min_batch_time)


			select sum(min_gain) /avg(min_batch_time) from overall_gain