select * from  data_dictionary
select * from Line_Downtime
select * from Line_Productivity
select * from Products
select * from Downtine_factors



--Production Analysis:
--What is the total number of batches produced per product and flavor?
select flavor,p.product,count(batch)as Batch from Line_Productivity lp
inner join Products p on lp.Product=p.Product
group by Flavor,p.Product
order by batch desc


--Which product size has the highest and lowest production volume?

with cte as 
(select top 1 Line_Productivity.Product,
'highest production volume' as production,
count(Line_Productivity.Batch) as cnt,products.[size] from Products
inner join Line_Productivity on Products.Product= Line_Productivity.Product
group by Line_Productivity.Product,products.[Size]
order by cnt desc),

cte2 as 
(select top 1 Line_Productivity.Product,
'lowest production volume' as production,
count(Line_Productivity.Batch) as cnt,products.[size] from Products
inner join Line_Productivity on Products.Product = Line_Productivity.Product
group by Line_Productivity.Product,products.[Size] 
order by cnt asc)

select * from cte
union all 
select * from cte2







--Efficiency Check:
--Calculate the average production time per product and compare it with the minimum batch time
select product,min_batch_time,avg_pro_time,(avg_pro_time-Min_batch_time) as compared_minutes

from
(select Line_Productivity.Product as product,min_batch_time, 
     avg(DATEDIFF(minute,Start_Time,End_Time))  as avg_pro_time 
	 from Products
 right join Line_Productivity on Products.Product=Line_Productivity.Product
 where End_Time > Start_Time
 group by Line_Productivity.Product,Min_batch_time ) as diff
 
 


 
--Identify batches that exceeded the minimum required production time and compute the percentage of inefficient batches
with production as (
select batch,lp.Product,
       DATEDIFF(minute,start_time,End_Time) as production_time,Min_batch_time  
from Products p
right join  Line_Productivity lp  on P.Product=Lp.Product
where End_Time > Start_Time),


inefficient_batches as (
select * from   production
where Min_batch_time <production_time)


select count(distinct ib.Batch)  * 100.0 / count(distinct p.Batch),
count(distinct ib.Batch) as inefficient_batches, count(distinct p.Batch) as production

from production p
left join inefficient_batches ib on p.batch = ib.Batch

select * from Line_Downtime
UPDATE Line_Downtime
SET column1 = COALESCE(column1, 0),
    column2 = COALESCE(column2, 0),
    column3 = COALESCE(column3, 0),
    column4 = COALESCE(column4, 0),
    column5 = COALESCE(column5, 0),
    column6 = COALESCE(column6, 0),
    column7 = COALESCE(column7, 0),
    column8 = COALESCE(column8, 0),
    column9 = COALESCE(column9, 0),
    column10 = COALESCE(column10, 0),
    column11 = COALESCE(column11, 0),
    column12 = COALESCE(column12, 0),
    column13 = COALESCE(column13, 0)
WHERE column1 IS NULL 
   OR column2 IS NULL 
   OR column3 IS NULL 
   OR column4 IS NULL 
   OR column5 IS NULL 
   OR column6 IS NULL 
   OR column7 IS NULL 
   OR column8 IS NULL 
   OR column9 IS NULL 
   OR column10 IS NULL 
   OR column11 IS NULL 
   OR column12 IS NULL 
   OR column13 IS NULL;



EXEC sp_rename 'Line_Downtime.column1', 'Batch', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column2', 'Downtime_Factor1', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column3', 'Downtime_Factor2', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column4', 'Downtime_Factor3', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column5', 'Downtime_Factor4', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column6', 'Downtime_Factor5', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column7', 'Downtime_Factor6', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column8', 'Downtime_Factor7', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column9', 'Downtime_Factor8', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column10', 'Downtime_Factor9', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column11', 'Downtime_Factor10', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column12', 'Downtime_Factor11', 'COLUMN';
EXEC sp_rename 'Line_Downtime.column13', 'Downtime_Factor12', 'COLUMN';

select * from Line_Downtime

select * from Line_Downtime
--Downtime Analysis:
--What are the top three most common downtime factors?
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
select 12, sum(case when downtime_factor12>0 then Downtime_Factor12 end ) from line_downtime



select * from cte ct
join Line_Productivity lp on ct.factor= cast(lp.factor as int)
order by total_downtime desc



 



--What percentage of total downtime is attributed to operator errors?


with operator_error as (
select factor from data_dictionary
where Operator_Error=1 ),

downtime as 
(
select 1 AS factor, count(case when downtime_factor1>0 then downtime_factor1  end ) as total_Downtime,sum(case when downtime_factor1>0 then downtime_factor1 end) as total_minute from line_downtime
union all
select 2 , count(case when downtime_factor2>0 then downtime_factor2 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor2 end)
union all
select 3 , count(case when downtime_factor3>0 then Downtime_Factor3 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor3 end)
union all
select 4 , count(case when downtime_factor4>0 then Downtime_Factor4 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor4 end)
union all
select 5, count(case when downtime_factor5>0 then Downtime_Factor5 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor5 end)
union all
select 6, count(case when downtime_factor6>0 then Downtime_Factor6  end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor6 end)
union all
select 7, count(case when downtime_factor7>0 then Downtime_Factor7  end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor7 end)
union all
select 8, count(case when downtime_factor8>0 then Downtime_Factor8 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor8 end)
union all
select 9, count(case when downtime_factor9>0 then Downtime_Factor9 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor9 end)
union all
select 10, count(case when downtime_factor10>0 then Downtime_Factor10 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor10 end)
union all
select 11, count(case when downtime_factor11>0 then Downtime_Factor11 end ) from line_downtime,sum(case when downtime_factor1>0 then downtime_factor11 end)
union all
select 12, count(case when downtime_factor12>0 then Downtime_Factor12 end ) from line_downtime),sum(case when downtime_factor1>0 then downtime_factor12 end),

operator_cnt as (
select d.factor,sum(total_downtime) as count_downtime from downtime d
inner join operator_error o on d.factor = o.factor
group by d.factor)

select sum(count_downtime) *100.0/ sum(total_downtime) as [%operator]
from operator_cnt c
right join downtime d on c.factor = d.factor



--Identify the operators with the highest and lowest total downtime in their batches

with cte as (
select Operator, sum(case when downtime_factor1>0 then downtime_factor1 else 0 end) + 
                 sum(case when downtime_factor2>0 then downtime_factor2 else 0 end )+
                 sum(case when downtime_factor3>0 then Downtime_Factor3 else 0 end )+
				  sum(case when downtime_factor4>0 then Downtime_Factor4 else 0 end )+
				  sum(case when downtime_factor5>0 then Downtime_Factor5 else 0 end )+
				  sum(case when downtime_factor6>0 then Downtime_Factor6 else 0  end )+
				  sum(case when downtime_factor7>0 then Downtime_Factor7 else 0  end )+
				  sum(case when downtime_factor8>0 then Downtime_Factor8 else 0 end )+
				  sum(case when downtime_factor9>0 then Downtime_Factor9 else 0 end )+
				  sum(case when downtime_factor10>0 then Downtime_Factor10 else 0 end )+
				  sum(case when downtime_factor11>0 then Downtime_Factor11 else 0 end )+
				  sum(case when downtime_factor11>0 then Downtime_Factor11 else 0 end ) as total_downtime


from line_productivity lp
join line_downtime ld on lp.Batch = ld.Batch
group by operator),
 cte2 as (
select  operator,total_downtime
from cte
)

select 'min_downtime'as downtime, operator,total_downtime from (

select top 1   operator,total_downtime from cte2
order by total_downtime asc) as min_downtime
union all
select 'max_downtime'as max_downtime,  operator,total_downtime from (
select top 1  operator,total_downtime from cte2
order by total_downtime desc) as max_downtime












--Performance Comparison:
--Compare total production time for different operators and rank them based on efficiency


with cte as (
select operator,datediff(minute,Start_Time,end_time) as date from Line_Productivity
where end_time >start_time
group by batch,Operator,datediff(minute,Start_Time,end_time)
)

select operator,sum(date)as total_time
from cte 
group by operator






--Find the operator with the highest number of batches that exceeded the minimum batch time

select top 1 with ties operator,count(batch) from Line_Productivity
where datediff(minute,Start_Time,End_Time) >
(select top 1 datediff(minute,Start_Time,End_Time) as newdate from Line_Productivity
where end_time>start_time
order by newdate)
group by Operator
order by count(batch) desc

select * from Line_Productivity

select * ,row_number() over ( partition by operator order by date desc) from line_productivity




select * ,count(Product) over ( partition by operator order by date desc) from line_productivity


select operator,count(product),Start_Time,end_time,date from Line_Productivity
group by operator,date,Start_Time,End_Time
order by operator, Date desc


select * ,min(date) over ( partition by operator order by date desc) from line_productivity



