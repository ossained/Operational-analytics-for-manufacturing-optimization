SELECT 
    ld.batch, 
    lp.product,
   df.description,
    SUM(
        COALESCE(ld.downtime_factor1, 0) +
        COALESCE(ld.downtime_factor2, 0) +
        COALESCE(ld.downtime_factor3, 0) +
        COALESCE(ld.downtime_factor4, 0) +
        COALESCE(ld.downtime_factor5, 0) +
        COALESCE(ld.downtime_factor6, 0) +
        COALESCE(ld.downtime_factor7, 0) +
        COALESCE(ld.downtime_factor8, 0) +
        COALESCE(ld.downtime_factor9, 0)+
        COALESCE(ld.downtime_factor10, 0) +
        COALESCE(ld.downtime_factor11, 0) +
        COALESCE(ld.downtime_factor12, 0)
    ) AS total_downtime
FROM 
    line_downtime ld
	
left JOIN 
    line_productivity lp ON lp.batch = ld.batch

inner  JOIN 
    Downtine_Factors df 
    ON CAST(df.factor AS INT) IN (
        CAST(ld.downtime_factor1 AS INT),
        CAST(ld.downtime_factor2 AS INT),
        CAST(ld.downtime_factor3 AS INT),
        CAST(ld.downtime_factor4 AS INT),
		CAST(ld.downtime_factor5 AS INT),
        CAST(ld.downtime_factor6 AS INT),
        CAST(ld.downtime_factor7 AS INT),
        CAST(ld.downtime_factor8 AS INT),
        CAST(ld.downtime_factor9 AS INT),
        CAST(ld.downtime_factor10 AS INT),
        CAST(ld.downtime_factor11 AS INT),
        CAST(ld.downtime_factor12 AS INT)
    )
GROUP BY 
    ld.batch, lp.product, df.description
ORDER BY 
    ld.batch, lp.product;


	SELECT batch, COUNT(downtime_mins) FROM Line_Downtime1 GROUP BY batch


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


SELECT 
    Description,
    mins, 
    ROUND((mins * 100.0) / SUM(mins) OVER (), 2) AS percentage_contribution 
FROM (
    SELECT 
        df.Description, 
        SUM(ld.Downtime_Mins) AS mins
    FROM Line_Downtime1 ld 
    JOIN Downtine_Factors df ON df.Factor = ld.Factor
    GROUP BY df.Description
) t 
ORDER BY mins DESC;

WITH Downtime_Summary AS (
    SELECT 
        df.Description, 
        SUM(ld.Downtime_Mins) AS total_mins
    FROM Line_Downtime1 ld
    JOIN Downtine_Factors df ON df.Factor = ld.Factor
    GROUP BY df.Description
), Total AS (
    SELECT SUM(total_mins) AS grand_total FROM Downtime_Summary
)
SELECT 
    ds.Description, 
    ds.total_mins, 
    ROUND((ds.total_mins * 100.0) / t.grand_total, 2) AS percentage_contribution
FROM Downtime_Summary ds
CROSS JOIN Total t
ORDER BY ds.total_mins DESC;


WITH Downtime_Summary AS (
    SELECT 
        df.Description, 
        SUM(ld.Downtime_Mins) AS total_mins
    FROM Line_Downtime1 ld
    JOIN Downtine_Factors df ON df.Factor = ld.Factor
    GROUP BY df.Description
)
SELECT 
    ds.Description, 
    ds.total_mins, 
    CAST(ROUND((ds.total_mins * 100.0) / (SELECT SUM(total_mins) FROM Downtime_Summary), 2) AS DECIMAL(5,2)) AS percentage_contribution
FROM Downtime_Summary ds
ORDER BY ds.total_mins DESC;






SELECT * FROM Line_productivity
UNION ALL
SELECT * FROM Products;

SELECT AVG(Avg_Production_Time) FROM(
SELECT 
    batch, 
    --Operator,
    DATEDIFF(MINUTE, Start_Time, End_Time) AS Avg_Production_Time
FROM Line_productivity
--WHERE End_Time > Start_Time
--GROUP BY batch--, Operator
) t;

SELECT * FROM Line_Productivity
WHERE batch = '422148'

SELECT 
    Batch, 
    Start_Time, 
    End_Time,
    CASE 
        WHEN End_Time < Start_Time 
        THEN DATEDIFF(MINUTE, Start_Time, DATEADD(DAY, 1, End_Time)) 
        ELSE DATEDIFF(MINUTE, Start_Time, End_Time) 
    END AS Production_Time
FROM Line_Productivity
WHERE batch = '422148';



SELECT DISTINCT ld.Batch, ld.Downtime_Mins,ld.factor, Description, DATEDIFF(MINUTE, Start_Time, End_Time) FROM Line_productivity lp JOIN Line_Downtime1 ld ON lp.Batch = ld.Batch
JOIN Downtine_Factors df ON df.Factor = ld.Factor
WHERE Product = 'CO-2L' AND End_Time > Start_Time AND Downtime_Mins > 0

SELECT AVG(Avg_Production_Time) FROM (
SELECT 
    Product, 
    Operator,
    AVG(DATEDIFF(MINUTE, Start_Time, End_Time)) AS Avg_Production_Time
FROM Line_productivity
WHERE End_Time > Start_Time
GROUP BY Product, Operator
ORDER BY Avg_Production_Time DESC
) R

SELECT SUM(downtime_mins) FROM line_downtime1

SELECT 
    CASE 
        WHEN Products.Product LIKE '%2L%' THEN '2L'
        WHEN Products.Product LIKE '%600%' THEN '600ml'
        ELSE 'Other'
    END AS Bottle_Size,
    AVG(DATEDIFF(SECOND, Start_Time, End_Time)) / 60.0 AS Avg_Production_Time
FROM Line_Productivity
JOIN Products ON Line_Productivity.Product = Products.Product
WHERE End_Time > Start_Time
GROUP BY 
    CASE 
        WHEN Products.Product LIKE '%2L%' THEN '2L'
        WHEN Products.Product LIKE '%600%' THEN '600ml'
        ELSE 'Other'
    END
ORDER BY Avg_Production_Time DESC;




SELECT 
    Batch, 
    Start_Time, 
    End_Time,
    CASE 
        WHEN End_Time < Start_Time 
        THEN DATEDIFF(MINUTE, Start_Time, DATEADD(DAY, 1, End_Time)) 
        ELSE DATEDIFF(MINUTE, Start_Time, End_Time) 
    END AS Production_Time
FROM Line_Productivity;

WITH production_time AS (
SELECT 
    Batch, 
    DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME))) 
    AS Production_Time
FROM Line_Productivity),

Avg_Time AS (
    SELECT AVG(Production_Time) AS Avg_Production_Time FROM production_time
),
Downtime_Reduction AS (
    SELECT SUM(Downtime_mins) * 0.2 AS Saved_Time FROM Line_Downtime1
)
SELECT 
    Saved_Time / Avg_Production_Time AS Additional_Batches
FROM Downtime_Reduction, Avg_Time;



WITH production_time AS (
SELECT 
    Batch, 
    DATEDIFF(MINUTE, CAST(Start_Time AS DATETIME), 
                     DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME))) 
    AS Production_Time
FROM Line_Productivity)

SELECT 
    bp.Operator,
    COUNT(bp.Batch) AS Total_Batches,
    AVG(DATEDIFF(MINUTE, 
                 CAST(Start_Time AS DATETIME), 
                 DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))
       ) AS Avg_Production_Time,
    COALESCE(SUM(dd.Downtime_Mins), 0) AS Total_Downtime,
    ROUND((1 - (COALESCE(SUM(dd.Downtime_Mins), 0) / NULLIF(SUM(DATEDIFF(MINUTE, 
                 CAST(Start_Time AS DATETIME), 
                 DATEADD(DAY, CASE WHEN End_Time < Start_Time THEN 1 ELSE 0 END, CAST(End_Time AS DATETIME)))
       ), 0))) * 100, 2) AS Efficiency_Score
FROM Line_Productivity bp
LEFT JOIN Line_Downtime1 dd ON bp.Batch = dd.Batch
GROUP BY bp.Operator
ORDER BY Efficiency_Score DESC;

SELECT 
    operator, 
    ROUND((total_batches * 100.0) / NULLIF(total_downtime, 0), 2) AS Efficiency_Score
FROM (
    SELECT 
        lp.operator, 
        COUNT(lp.batch) AS total_batches, 
        COALESCE(SUM(ld.downtime_mins), 0) AS total_downtime
    FROM Line_Productivity lp 
    LEFT JOIN Line_Downtime1 ld ON lp.Batch = ld.Batch
    GROUP BY lp.operator
) t
ORDER BY Efficiency_Score DESC;










