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
IF object_id(N'tempdb..#annual') IS NOT NULL
	DROP TABLE #annual


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

--SELECT ID, _2009, _2010, _2011, _2012 --(Cast([_2009] as nvarchar) + cast([_2010] as nvarchar)) as average
--FROM _Input_Annual_Vectors_Autonomy1
	

--INSERT INTO #annual2
--	(ID,Year,Val)
SELECT 'yr_' + ID as ID, right(Year, len(Year)-1) as Year, Val
INTO #annual
FROM 
	(SELECT ID, 
			_2010,
			_2011,_2012,_2013,_2014,_2015,_2016,_2017,_2018,_2019,_2020,
			_2021,_2022,_2023,_2024,_2025,_2026,_2027,_2028,_2029,_2030,
			_2031,_2032,_2033,_2034,_2035,_2036,_2037,_2038,_2039,_2040,
			_2041,_2042,_2043,_2044,_2045,_2046,_2047,_2048,_2049,_2050,
			_2051,_2052,_2053
	FROM [_Input_Annual_Vectors_Autonomy1] where ID like '%DSM%') p
UNPIVOT
	(Val FOR Year IN 
			(_2010,
			_2011,_2012,_2013,_2014,_2015,_2016,_2017,_2018,_2019,_2020,
			_2021,_2022,_2023,_2024,_2025,_2026,_2027,_2028,_2029,_2030,
			_2031,_2032,_2033,_2034,_2035,_2036,_2037,_2038,_2039,_2040,
			_2041,_2042,_2043,_2044,_2045,_2046,_2047,_2048,_2049,_2050,
			_2051,_2052,_2053)
)AS unpvt

SELECT ID, Avg(Val)
FROM #annual
Group By ID	


/*
SELECT *
FROM #temp3
order by capacity
*/