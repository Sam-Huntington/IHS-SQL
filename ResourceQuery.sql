/*
Parameters:
	@dbname
	@resource_tbl
	@east_tbl
	@west_tbl
	@ercot_tbl
	@annual_vector_tbl
*/


USE [a_VER_H22015]
IF object_id(N'tempdb..#temp1') IS NOT NULL
	DROP TABLE #temp1
IF object_id(N'tempdb..#temp2') IS NOT NULL
	DROP TABLE #temp2
IF object_id(N'tempdb..#temp3') IS NOT NULL
	DROP TABLE #temp3


--Combine RMT and Resource tables into #temp
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
INTO #temp1
FROM _Input_Resources_AUT1

INSERT INTO #temp1
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_WEST_AUT1

INSERT INTO #temp1
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_EAST_AUT1

INSERT INTO #temp1
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_ERCOT_AUT1

--------------
--Replace heat rate vectors with scalar values (simple average)
--------------
SELECT ('hrd_' + h.ID) as region, avg(cast(h.[Heat_Rate] as float)) as Avg_HeatRate
INTO #temp2
FROM #temp1 as r
INNER JOIN _Input_HeatRate_IHS1 as h on r.[Heat_Rate] = ('hrd_' + h.ID)
GROUP BY h.ID

SELECT t1.[ID],t1.[Name],t1.[Capacity],t1.[Fuel],t1.[Area],t1.[Peak_Credit],
	CASE WHEN left(t1.[Heat_Rate],3) = 'hrd' THEN CAST(t2.Avg_HeatRate as varchar) ELSE CAST(t1.[Heat_Rate] as varchar) END AS Heat_Rate
INTO #temp3
FROM #temp1 as t1
LEFT JOIN #temp2 as t2 on t2.region = t1.[Heat_Rate]

---------------
--Replace annual capacity vectors with scalars (simple average)
---------------

SELECT ID, _2009, _2010, _2011, _2012 --(Cast([_2009] as nvarchar) + cast([_2010] as nvarchar)) as average
FROM _Input_Annual_Vectors_Autonomy1
	
	

/*
SELECT *
FROM #temp3
order by capacity
*/