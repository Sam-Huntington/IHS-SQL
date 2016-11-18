/*
Notes:
	!!! = internal tag for notes to self (follow up items)

Parameters:
	@dbname
	@resource_tbl
	@east_tbl
	@west_tbl
	@ercot_tbl
	@annual_vector_tbl
*/


USE [a_VER_H22015]
IF object_id(N'tempdb..#resources') IS NOT NULL
	DROP TABLE #resources
IF object_id(N'tempdb..#temp2') IS NOT NULL
	DROP TABLE #temp2
IF object_id(N'tempdb..#temp3') IS NOT NULL
	DROP TABLE #temp3
IF object_id(N'tempdb..#relevant_yr_vect') IS NOT NULL
	DROP TABLE #relevant_yr_vect
IF object_id(N'tempdb..#annual') IS NOT NULL
	DROP TABLE #annual
IF object_id(N'tempdb..#month') IS NOT NULL
	DROP TABLE #month
IF object_id(N'tempdb..#relevant_mn_vect') IS NOT NULL
	DROP TABLE #relevant_mn_vect
	


--Combine RMT and Resource tables into #temp
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
INTO #resources
FROM _Input_Resources_AUT1 --!!! replace with variable table reference

INSERT INTO #resources
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_WEST_AUT1 --!!! replace with variable table reference

INSERT INTO #resources
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_EAST_AUT1 --!!! replace with variable table reference

INSERT INTO #resources
SELECT ID, Name, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_ERCOT_AUT1 --!!! replace with variable table reference

--------------
--Replace heat rate vectors with scalar values (simple average)
--------------
SELECT ('hrd_' + h.ID) as region, avg(cast(h.[Heat_Rate] as float)) as Avg_HeatRate
INTO #temp2
FROM #resources as r
INNER JOIN _Input_HeatRate_IHS1 as h on r.[Heat_Rate] = ('hrd_' + h.ID)
GROUP BY h.ID

SELECT t1.[ID],t1.[Name],t1.[Capacity],t1.[Fuel],t1.[Area],t1.[Peak_Credit],
	CASE WHEN LEFT(t1.[Heat_Rate],3) = 'hrd' THEN CAST(t2.Avg_HeatRate as varchar) ELSE CAST(t1.[Heat_Rate] as varchar) END AS Heat_Rate
INTO #temp3
FROM #resources as t1
LEFT JOIN #temp2 as t2 on t2.region = t1.[Heat_Rate]

---------------
--Replace annual capacity vectors with scalars (simple average)
---------------

--unique list of annual vectors (operating on only neccessary subset reduces computation time)
SELECT * 
INTO #relevant_yr_vect
FROM (
	SELECT Capacity as VectorName
	FROM #resources as r
	WHERE LEFT(r.Capacity,3) = 'yr_'
	) a
JOIN [_Input_Annual_Vectors_Autonomy1] as i1 on 'yr_' + i1.ID = a.VectorName
--!!! replace with variable table reference

--unpack annual vectors
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
	FROM [_Input_Annual_Vectors_Autonomy1]) p --#relevant_yr_vect
UNPIVOT
	(Val FOR Year IN 
			(_2010,
			_2011,_2012,_2013,_2014,_2015,_2016,_2017,_2018,_2019,_2020,
			_2021,_2022,_2023,_2024,_2025,_2026,_2027,_2028,_2029,_2030,
			_2031,_2032,_2033,_2034,_2035,_2036,_2037,_2038,_2039,_2040,
			_2041,_2042,_2043,_2044,_2045,_2046,_2047,_2048,_2049,_2050,
			_2051,_2052,_2053)
)AS unpvt

--check for monthly vectors
IF (SELECT COUNT(*) FROM #annual WHERE left(Val,3) = 'mn_') > 0
	--1. identify relevant monthly vectors
	SELECT * 
		INTO #relevant_mn_vect
		FROM 
			(SELECT Val as VectorName
			FROM #annual as a
			WHERE LEFT(a.Val,3) = 'mn_') a
		JOIN [_Input_Monthly_Vectors_Autonomy1] as i1 on 'mn_' + i1.ID = a.VectorName
		--!!! replace with variable table reference
	--2. unpack monthly vectors
	SELECT 'mn_' + ID as ID, right(Month, len(Month)-1) as Month, Val
	INTO #month
	FROM 
		(SELECT ID, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12
		FROM #relevant_mn_vect) p
	UNPIVOT 
		(Val FOR Month IN
			(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)
		) AS unpvt
	--check for weekly vectors
	IF (SELECT COUNT(*) FROM #month WHERE left(Val,3) = 'wk_') > 0


	ELSE
	--3. avg vectors
		SELECT ID, Month, Val --Avg(Cast(Val as float))
		FROM #month
		--Group By ID
	--4. insert values back into annual table
	
ELSE
--3. avg vectors
--4. insert values back into resources table



SELECT *
FROM #relevant_mn_vect


SELECT ID, Avg(Cast(Val as float))
FROM #annual
Group By ID	




/*
SELECT *
FROM #temp3
order by capacity
*/