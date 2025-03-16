# Operational-analytics-for-manufacturing-optimization
BatchPro Systems, a beverage manufacturing company wants to streamline its operations by analyzing production and downtime data. They aim to understand the relationship between different products, production times, operator performance, and downtime factors to improve their processes. The company seeks to reduce inefficiencies, minimize the impact of downtime, and improve product consistency.

## Manufacturing Optimisation with SQL: Lowering Downtime and Improving Effectiveness


## Introductions

Using SQL, BatchPro Systems,a beverage manufacturing company did a thorough study of production downtime in order to pinpoint inefficiencies and maximise operations. By tackling important industrial process bottlenecks, one aimed to reduce production interruptions, improve efficiency, and recoup lost output.

### Key Findings
1.	Production Loss Due to Downtime: A total of 17 batches were lost due to various downtime incidents, significantly affecting overall productivity.
2.	Primary Downtime Contributors: 
o	CO-600 (34.82% of total downtime, 8 hours lost) – Machine failures caused by frequent adjustments, setup errors, product spills, and inventory shortages.
o	CO-2L (20.04% of total downtime, 5 hours lost) – Larger batch size required frequent machine adjustments, leading to recurring delays.
o	RB-600 (19.60% of total downtime, 4 hours lost) – Calibration and coding errors contributed to frequent machine reconfigurations.
3.	Potential Recovery: Addressing these inefficiencies could result in 8 hours of recovered production time and 7 additional batches, directly improving output and operational performance.
Business problem
Regular equipment failures, batch processing inefficiencies, and operator induced delays add to too much production downtime. These difficulties lower manufacturing capacity, raise prices, and make it more difficult to reach production goals.

### Data and some SQL Queries used: Dataset Cleaning & Preparation
To make the line_downtime table clean for analysis, we cleaned and unpivoted the data:
```sql
WITH cleaned_data AS (
    SELECT 
        Batch,
        COALESCE("Factor1", 0) AS "1",
        COALESCE("Factor2", 0) AS "2",
        COALESCE("Factor3", 0) AS "3",
        COALESCE("Factor4", 0) AS "4",
        COALESCE("Factor5", 0) AS "5",
        COALESCE("Factor6", 0) AS "6",
        COALESCE("Factor7", 0) AS "7",
        COALESCE("Factor8", 0) AS "8",
        COALESCE("Factor9", 0) AS "9",
        COALESCE("Factor10", 0) AS "10",
        COALESCE("Factor11", 0) AS "11",
        COALESCE("Factor12", 0) AS "12"
    FROM line_downtime
)

SELECT 
    Batch,
    Factor_ID,
    Downtime_Minutes
FROM cleaned_data
UNPIVOT (Downtime_Minutes FOR Factor_ID IN ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
) AS unpivoted_data;

````
### Calculating Total Downtime Per Product
```sql
SELECT lp.Product, df.description, 
       SUM(ld.Downtime_Mins) AS total_downtime,
       RANK() OVER (PARTITION BY lp.Product ORDER BY SUM(ld.Downtime_Mins) DESC) AS downtime_cause
FROM line_downtime1 ld
JOIN Line_Productivity lp ON ld.Batch = lp.Batch
LEFT JOIN Downtime_Factors df ON ld.Factor = df.Factor
GROUP BY lp.Product, df.description;

```
CO-600 had the highest downtime (35.59%) CO-2L and RB-600 had 100% batch failure rates due to excessive adjustments

---------
### Major Downtime Causes Per Product
```sql
SELECT lp.Product, df.description, 
       SUM(ld.Downtime_Mins) AS total_downtime,
       RANK() OVER (PARTITION BY lp.Product ORDER BY SUM(ld.Downtime_Mins) DESC) AS downtime_cause
FROM line_downtime1 ld
JOIN Line_Productivity lp ON ld.Batch = lp.Batch
LEFT JOIN Downtime_Factors df ON ld.Factor = df.Factor
GROUP BY lp.Product, df.description;
```
🔹 Machine adjustments are leading to frequent breakdowns.
>
🔹 CO-600 is the biggest bottleneck, followed by CO-2L and RB-600

-----------
### Batches Affected By Downtime
```sql
SELECT lp.product, 
       COUNT(DISTINCT lp.Batch) AS affected_batches 
FROM line_downtime1 ld
LEFT JOIN line_productivity lp ON ld.batch = lp.batch
WHERE Downtime_Mins > 0
GROUP BY lp.Product;
```

----
## Data Analysis & Key Finding
 *Downtime Breakdown*
|   Issues           | Total Downtime (Mins) | % of Total Downtime|
| ---------------   | --------------------- | ------------------ |
| Machine Failures   |    569 mins           |   42%        |
| Machine Adjustments |   534 mins           |   40%        |
| Batch Change        |   269 mins           |   18%        |

🚨 Machine adjustments are often causing machine failures, creating a vicious cycle of inefficiency

------
#### *Most Affected Products*
|     Product     | Total Downtime (mins)|  % of Total Downtim | Batch Failure Rate % |  Primary Issues |
| ----------------| ---------------------| ------------------- | ------------------ | ---------------|
|  CO-600         |     469 mins                 |      34.81%        |          86.67%           |    Machine failure (caused by adjustments)            |                      
|  CO-2L          |     270 mins                 |      20.04%        |          100%           |    Machine adjustments            |                      
|  RB-600         |     264 mins                 |       19.6%       |           85.71%         |    Machine adjustments             |                      
|  LE-600         |     169 mins                 |       12.6%       |           83.33%          |    Batch change delays              |                      
                                                                                    


#### *Batches Lost & Recovery Potential*
| Product | Batches Lost  | Expected Batches Recovered |
| -------- | ------------- | ------------------------- |
| CO-600         |   7            |  4                         |
| CO-2L        |     2         |     1                      |
| RB-600         |   4            |  2                         |
| Total         |    13           |    7                       |

By implementing our recommended fixes, we can recover 7 batches and save 8 hours of production time.

----------
### Dashboard
![drinks](https://github.com/user-attachments/assets/54789ca9-c13f-4e60-9b7d-b4a6b2e6795f)


---------
### Recommendations
•	Use Preventive Maintenance (High Impact) to strengthen machine maintenance procedures so as to lower unplanned failures.

•	Optimise CO-2L Machine Settings (High Impact) – Change machine settings to reduce the demand for regular reconfigurations.

•	Improve Downtime Monitoring (Medium Impact) - Track downtime constantly to proactively find and fix reoccurring problems.

•	Medium impact operator training and standardising will help to improve machine handling and lower operator-induced inefficiencies.

•	Low Impact Batch Changeovers: Simplify batch transition procedures to lower the downtime between production cycles.

### Expected Business Impact
By implementing these strategies, BatchPro Systems can achieve:

•	Up to 20% increase in manufacturing efficiency will help to enable more output without further capital expenditure.

•	Less failed batches mean less waste and better product consistency.

•	Savings from less machine breakdowns, so minimising maintenance and repair costs.

•	Higher operational efficiency lets one better use resources and organise production.

By means of this data-driven strategy, BatchPro Systems may improve general manufacturing performance, maximise operational decisions, and streamline production processes.

# Conclusion

Through SQL analysis, we determined that machine failures and frequent adjustments are responsible for 74% of downtime.
By introducing preventive maintenance, optimizing machine performance, and providing operator training, we can significantly cut downtime, enhance efficiency, and boost production output.

This initiative is expected to:

Reduce downtime by 50% (saving over 8 hours)

Recover 7 additional batches

Increase efficiency, lower costs, and improve overall output

