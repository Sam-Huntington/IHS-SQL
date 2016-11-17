/****** Script for SelectTopNRows command from SSMS  ******/

USE [a_VER_H22015]
IF object_id(N'tempdb..#temp') IS NOT NULL
	DROP TABLE #temp
IF object_id(N'tempdb..#temp2') IS NOT NULL
	DROP TABLE #temp2
IF object_id(N'tempdb..#temp3') IS NOT NULL
	DROP TABLE #temp3

--
SELECT DISTINCT lkup
INTO #temp
FROM (
	SELECT [ID],
		CASE WHEN left(Heat_Rate,3) = 'hrd' THEN right(Heat_Rate, len(Heat_Rate)-4) END as lkup
	FROM _Input_Resources_RIV1) a
WHERE lkup IS NOT NULL

SELECT ('hrd_' + ID) as region, avg(cast(Heat_Rate as float)) as Avg_HeatRate
INTO #temp2
FROM #temp as i
INNER JOIN _Input_HeatRate_IHS1 as k on i.lkup = k.ID
GROUP BY ID

SELECT j.[ID],j.[Name],j.[Heat_Rate],j.[Capacity],j.[Fuel],j.[Area],j.[Peak_Credit],t.Avg_HeatRate
INTO #temp3
FROM _Input_Resources_RIV1 as j
LEFT JOIN #temp2 as t on t.region = j.heat_rate

SELECT ID, Name, Capacity, Fuel, Area, Peak_Credit, Heat_Rate, Avg_HeatRate,
	CASE WHEN left([Heat_Rate],3) = 'hrd' THEN Avg_HeatRate ELSE [Heat_Rate] END AS HR
FROM #temp3
ORDER BY Fuel