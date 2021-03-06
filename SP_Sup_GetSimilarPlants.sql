USE [AURORA]
GO
/****** Object:  StoredProcedure [dbo].[SP_Sup_GetSimilarPlants]    Script Date: 1/13/2017 8:36:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Sup_GetSimilarPlants]
/* 
   ! >>Parameters: 
   ! 1) Database Name
   ! 2) Scenario
   ! 3) fuel
   ! 4) prime mover
   ! 5) state
   ! 6) year
   ! 7) nerc sub region
   !	
   ! >>Input: resource parameters
   ! >>Output: a table of similar plants sorted by most similar attributes
   !
*/
    @dbname		nvarchar(50),
	@scen		nvarchar(10),
	@fuel		nvarchar(10),
	@primemover	nvarchar(10),
	@state		nvarchar(10),
	@year		nvarchar(10),
	@nercsub	nvarchar(10)

AS
    SET NOCOUNT ON
    SET XACT_ABORT ON

	/*Validate the database name exists*/
    IF DB_ID(@dbname) IS NULL  
       BEGIN
       RAISERROR('Invalid Database Name passed',16,1)
       RETURN
       END


    DECLARE @dynsql nvarchar(max)  
	DECLARE @resourceTbl nvarchar(30)  

	IF @scen = 'RIV' BEGIN SET @resourceTbl = '_Input_Resources_RIV1' END
	IF @scen = 'AUT' BEGIN SET @resourceTbl = '_Input_Resources_AUT1' END
	IF @scen = 'VER' BEGIN SET @resourceTbl = '_Input_Resources_VER1' END
	IF @primemover = 'PV' BEGIN SET @fuel = 'SUN' END
	IF @primemover = 'WT' BEGIN SET @fuel = 'WND' END

	/*Body of the query*/
	SET @dynsql = N'USE '+ QUOTENAME(@dbname) + N'
	SELECT Name, zREM_Plant_State, [zREM_NERC_Sub-region], zREM_Prime_Mover_Code, zREM_EV_Fuel_Code, 
		Capacity, zREM_Online_Year, Heat_rate, Fuel, [Variable_O&M], [Fixed_O&M], 
		Forced_Outage, Non_Cycling, Minimum_Capacity, Heat_Rate_Scalar
	INTO #temp
	FROM '+@resourceTbl+'
	WHERE zREM_Prime_Mover_Code = '''+@primemover+''' AND
		zREM_EV_Fuel_Code = '''+@fuel+''' AND
		(zREM_Plant_State = '''+@state+''' OR
		zREM_Online_Year > ('+@year+'-10) OR
		[zREM_NERC_Sub-region] = '''+@nercsub+''')

	SELECT *,
		CASE WHEN zREM_EV_Fuel_Code = '''+@fuel+''' THEN 1 ELSE 0 END AS C1,
		CASE WHEN zREM_Plant_State = '''+@state+'''  THEN 2 ELSE 0 END AS C2,
		CASE WHEN zREM_Online_Year > ('+@year+'-10)  THEN 1 ELSE 0 END AS C3,
		CASE WHEN [zREM_NERC_Sub-region] = '''+@nercsub+''' THEN 1 ELSE 0 END AS C4
	INTO #temp2
	FROM #temp

	SELECT TOP 100
		Name, zREM_Plant_State, [zREM_NERC_Sub-region], zREM_Prime_Mover_Code, zREM_EV_Fuel_Code, 
		Capacity, zREM_Online_Year, Heat_rate, Fuel, [Variable_O&M], [Fixed_O&M], 
		Forced_Outage, Non_Cycling, Minimum_Capacity, Heat_Rate_Scalar, 
		C1+C2+C3+C4 as total
	FROM #temp2
	Order by total DESC, zREM_Online_Year DESC

	drop table #temp, #temp2

'
	--print @dynsql;
	EXEC sp_executesql @dynsql;

