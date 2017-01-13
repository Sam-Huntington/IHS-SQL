/*
Notes:
	!!! = internal tag for notes to self (follow up items)

Parameters:
	@dbname
	@resource_tbl
	@east_tbl
	@west_tbl
	@ercot_tbl


DECLARE @scenlong nvarchar(10)
IF @scen = 'RIV' BEGIN set @scenlong = 'Rivalry' END
IF @scen = 'AUT' BEGIN set @scenlong = 'Autonomy' END
IF @scen = 'VER' BEGIN set @scenlong = 'Vertigo' END
*/

USE [a_AUT_H22015]
IF object_id(N'tempdb..#resources') IS NOT NULL
	DROP TABLE #resources
IF object_id(N'tempdb..#relevant_yr_vect') IS NOT NULL
	DROP TABLE #relevant_yr_vect
IF object_id(N'tempdb..#annual') IS NOT NULL
	DROP TABLE #annual
IF object_id(N'tempdb..#month') IS NOT NULL
	DROP TABLE #month
IF object_id(N'tempdb..#relevant_mn_vect') IS NOT NULL
	DROP TABLE #relevant_mn_vect
IF object_id(N'tempdb..#week') IS NOT NULL
	DROP TABLE #week
IF object_id(N'tempdb..#relevant_wk_vect') IS NOT NULL
	DROP TABLE #relevant_wk_vect


--1.0 Combine RMT and Resource tables into #temp
SELECT ID, Name, CONVERT(date,Resource_Begin_Date,101) as RBD, Convert(date,Resource_End_Date,101) as RED, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
INTO #resources
FROM _Input_Resources_AUT1 --!!! replace with variable table reference

INSERT INTO #resources
SELECT ID, Name,CONVERT(date,Resource_Begin_Date,101) as RBD, Convert(date,Resource_End_Date,101) as RED, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_WEST_AUT1 --!!! replace with variable table reference

INSERT INTO #resources
SELECT ID, Name, CONVERT(date,Resource_Begin_Date,101) as RBD, Convert(date,Resource_End_Date,101) as RED,Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_EAST_AUT1 --!!! replace with variable table reference

INSERT INTO #resources
SELECT ID, Name, CONVERT(date,Resource_Begin_Date,101) as RBD, Convert(date,Resource_End_Date,101) as RED, Capacity, Heat_Rate, Fuel, Area, Peak_Credit
FROM _Input_RMT_ERCOT_AUT1 --!!! replace with variable table reference

--------------
--2.0 Replace heat rate vectors with scalar values (simple average)
--------------

UPDATE #resources
SET #resources.Heat_Rate = 
	(CASE WHEN LEFT(#resources.Heat_Rate,3) = 'hrd' THEN CAST(a.Avg_HeatRate as varchar) ELSE CAST(#resources.[Heat_Rate] as varchar) END)
FROM
	(SELECT ('hrd_' + h.ID) as region, avg(cast(h.[Heat_Rate] as float)) as Avg_HeatRate
	FROM #resources as r
	INNER JOIN _Input_HeatRate_IHS1 as h on r.[Heat_Rate] = ('hrd_' + h.ID)
	GROUP BY h.ID) a

---------------
--3.0 Replace annual capacity vectors with scalars (simple average)
---------------

--3.1 identify unique list of annual vectors (operating on subset reduces computation time)
SELECT * 
INTO #relevant_yr_vect
FROM (
	SELECT Capacity as VectorName
	FROM #resources as r
	WHERE LEFT(r.Capacity,3) = 'yr_') a
JOIN [_Input_Annual_Vectors_Autonomy1] as i1 on 'yr_' + i1.ID = a.VectorName
INSERT INTO #relevant_yr_vect
SELECT * 
FROM (
	--sometimes heat_rate is also based on a yearly vector
	SELECT Heat_Rate as VectorName
	FROM #resources as r
	WHERE LEFT(r.Heat_Rate,3) = 'yr_') a
JOIN [_Input_Annual_Vectors_Autonomy1] as i1 on 'yr_' + i1.ID = a.VectorName


--3.2 unpack annual vectors
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
	FROM [_Input_Annual_Vectors_Autonomy1]) p --#relevant_yr_vect  --for testing
UNPIVOT
	(Val FOR Year IN 
			(_2010,
			_2011,_2012,_2013,_2014,_2015,_2016,_2017,_2018,_2019,_2020,
			_2021,_2022,_2023,_2024,_2025,_2026,_2027,_2028,_2029,_2030,
			_2031,_2032,_2033,_2034,_2035,_2036,_2037,_2038,_2039,_2040,
			_2041,_2042,_2043,_2044,_2045,_2046,_2047,_2048,_2049,_2050,
			_2051,_2052,_2053)
)AS unpvt

IF (SELECT COUNT(*) FROM #annual WHERE left(Val,3) = 'mn_') > 0				--3.3 check for monthly vectors
	BEGIN																	--3.3.1 identify relevant monthly vectors
		SELECT * 
		INTO #relevant_mn_vect
		FROM 
			(SELECT Val as VectorName
			FROM #annual as a
			WHERE LEFT(a.Val,3) = 'mn_') a
		JOIN [_Input_Monthly_Vectors_Autonomy1] as i1 on 'mn_' + i1.ID = a.VectorName
			--!!! replace with variable table reference

		SELECT 'mn_' + ID as ID, right(Month, len(Month)-1) as Month, Val	--3.3.2 unpack monthly vectors
		INTO #month
		FROM 
			(SELECT ID, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12
			FROM #relevant_mn_vect) p
		UNPIVOT 
			(Val FOR Month IN
				(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)
			) AS unpvt
		
		IF (SELECT COUNT(*) FROM #month WHERE left(Val,3) = 'wk_') > 0		--3.3.3 check for weekly vectors
			BEGIN  															--3.3.3.1 identify relevant weekly vectors
				SELECT * 
				INTO #relevant_wk_vect
				FROM 
					(SELECT Val as VectorName
					FROM #month as a
					WHERE LEFT(a.Val,3) = 'wk_') a
				JOIN [_Input_Weekly_Vectors_Autonomy1] as i1 on 'wk_' + i1.ID = a.VectorName
				--!!! replace with variable table reference
				
				SELECT 'wk_' + ID as ID, right(Week, len(Week)-1) as Month, Val	--3.3.3.2 unpack weekly vectors
				INTO #week
				FROM 
					(SELECT ID,  _1, _2, _3, _4, _5, _6, _7, _8, _9,_10,
				   _11, _12, _13, _14, _15, _16, _17, _18, _19,_20,
				   _21, _22, _23, _24, _25, _26, _27, _28, _29,_30,
				   _31, _32, _33, _34, _35, _36, _37, _38, _39,_40,
				   _51, _52, _53, _54, _55, _56, _57, _58, _59,_50,
				   _61, _62, _63, _64, _65, _66, _67, _68, _69,_70,
				   _71, _72, _73, _74, _75, _76, _77, _78, _79,_80,
				   _81, _82, _83, _84, _85, _86, _87, _88, _89,_90,
				   _91, _92, _93, _94, _95, _96, _97, _98, _99,_100,
				   _101, _102, _103, _104, _105, _106, _107, _108, _109,_110,
				   _111, _112, _113, _114, _115, _116, _117, _118, _119,_120,
				   _121, _122, _123, _124, _125, _126, _127, _128, _129,_130,
				   _131, _132, _133, _134, _135, _136, _137, _138, _139,_140,
				   _141, _142, _143, _144, _145, _146, _147, _148, _149,_150,
				   _151, _152, _153, _154, _155, _156, _157, _158, _159,_160,
				   _161, _162, _163, _164, _165, _166, _167, _168
					FROM #relevant_wk_vect) p
				UNPIVOT 
					(Val FOR Week IN
						( _1, _2, _3, _4, _5, _6, _7, _8, _9,_10,
				   _11, _12, _13, _14, _15, _16, _17, _18, _19,_20,
				   _21, _22, _23, _24, _25, _26, _27, _28, _29,_30,
				   _31, _32, _33, _34, _35, _36, _37, _38, _39,_40,
				   _51, _52, _53, _54, _55, _56, _57, _58, _59,_50,
				   _61, _62, _63, _64, _65, _66, _67, _68, _69,_70,
				   _71, _72, _73, _74, _75, _76, _77, _78, _79,_80,
				   _81, _82, _83, _84, _85, _86, _87, _88, _89,_90,
				   _91, _92, _93, _94, _95, _96, _97, _98, _99,_100,
				   _101, _102, _103, _104, _105, _106, _107, _108, _109,_110,
				   _111, _112, _113, _114, _115, _116, _117, _118, _119,_120,
				   _121, _122, _123, _124, _125, _126, _127, _128, _129,_130,
				   _131, _132, _133, _134, _135, _136, _137, _138, _139,_140,
				   _141, _142, _143, _144, _145, _146, _147, _148, _149,_150,
				   _151, _152, _153, _154, _155, _156, _157, _158, _159,_160,
				   _161, _162, _163, _164, _165, _166, _167, _168)
					) AS unpvt
				--!!! take average and replace values in #month
				
				UPDATE #month														--3.3.4 update month table
				SET #month.Val = (CASE WHEN LEFT(#month.Val,3) = 'wk_' THEN w.Val ELSE #month.Val END)
				FROM																--from table of weekly averages
					(SELECT ID, Avg(Cast(Val as float)) as Val
					FROM #week
					Group By ID) w
			END

		--had to add this in to get around special case varchars that pass ISNUMERIC by cannot be cast to float (i.e., $x,xxx)
		UPDATE #annual	
		SET #annual.Val = (CASE WHEN ISNUMERIC(#annual.Val) <>1 AND NOT LEFT(#annual.Val,3) = 'mn_' THEN '0' ELSE #annual.Val END)
		
		UPDATE #annual														--3.4 update annual table
		SET #annual.Val = (CASE WHEN LEFT(#annual.Val,3) = 'mn_' THEN CAST(m.avgVal as varchar) ELSE #annual.Val END)
		FROM																--from table of monthly averages
			(SELECT ID, Avg(Cast(Val as float)) as avgVal
			FROM #month
			Group By ID) m
		
		UPDATE #annual	
		SET #annual.Val = TRY_CONVERT(numeric, #annual.Val) 

	END
ELSE

UPDATE #resources															--3.5 update resources table
SET #resources.Capacity = (CASE WHEN LEFT(#resources.Capacity,3) = 'yr_' THEN Cast(a.Val as varchar) ELSE #resources.Capacity END)
FROM 
	(SELECT ID, Avg(Cast(Val as float)) as Val
	FROM #annual
	Group By ID) a

UPDATE #resources 
SET #resources.Heat_Rate = (CASE WHEN LEFT(#resources.Heat_Rate,3) = 'yr_' THEN a.Val ELSE #resources.Heat_Rate END)
FROM 
	(SELECT ID, Avg(Cast(Val as float)) as Val
	FROM #annual
	Group By ID) a


----
--Add custom tags
---

ALTER TABLE #resources ADD SummerOnlineYear varchar(4) NULL
UPDATE #resources SET SummerOnlineYear = (CASE WHEN datepart(month, RBD)>6 THEN datepart(year, RBD)+1 ELSE datepart(year, RBD) END)

ALTER TABLE #resources ADD SummerOfflineYear varchar(4) NULL
UPDATE #resources SET SummerOfflineYear = (CASE WHEN datepart(month, RED)>6 THEN datepart(year, RED)+1 ELSE datepart(year, RED) END)

ALTER TABLE #resources ADD AddType varchar(40) NULL
UPDATE #resources SET AddType = (CASE 
									WHEN Name LIKE '%CERA D%' THEN 'CERA Dispatch'  
									WHEN Name LIKE '%demand%' THEN 'Demand Side Aurora'
									WHEN Name LIKE '%ExpansionTK%' THEN 'manual/model'
									WHEN Name LIKE '%GM%' THEN 'manual/model'
									WHEN Name LIKE '%New Resource%' THEN 'Aurora'
									ELSE 'Existing'
								END)

--for viewing/checking results
--SELECT (datepart(month, RBD)+1) as yr FROM #resources 
SELECT * FROM #resources
--ORDER BY Capacity

