USE [AURORA]
GO
/****** Object:  StoredProcedure [dbo].[SP_PreCheck_References]    Script Date: 1/13/2017 8:29:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_PreCheck_References]
/* 
   ! >>Parameters: 
   ! 1) Database Name
   ! 2) Scenario
   ! 3) Fuel String
   ! 4) heat rate
   ! 5) variable O&M
   ! 6) forced outage
   ! 7) maintenance rate
   ! 8) capacity shape
   ! 9) emissions rate
   ! 10) emissions price
   ! 11) Plant name
   !	
   ! >>Input: resource parameter references
   ! >>Output: If any of the parameters don't exist in the input tables an error will interrupt the code
   !
*/
    @dbname		nvarchar(50),
	@scen		nvarchar(50),
	@fuel		nvarchar(50),
	@hrd		nvarchar(50) = NULL,
	@varOM		nvarchar(50) = NULL,
	@ForceOut	nvarchar(50) = NULL,
	@Maint		nvarchar(50) = NULL,
	@CapShape	nvarchar(50) = NULL,
	@ER			nvarchar(50) = NULL,
	@EP			nvarchar(50) = NULL,
	@PlantName	nvarchar(50) = NULL
	
AS
    SET NOCOUNT ON
    SET XACT_ABORT ON

	/*Validate the database name exists*/
    IF DB_ID(@dbname) IS NULL  
       BEGIN
       RAISERROR('Invalid Database Name passed',16,1)
       RETURN
       END

	DECLARE @scenlong nvarchar(10)
	IF @scen = 'RIV' BEGIN set @scenlong = 'Rivalry' END
	IF @scen = 'AUT' BEGIN set @scenlong = 'Autonomy' END
	IF @scen = 'VER' BEGIN set @scenlong = 'Vertigo' END

	/*set the table names*/
	DECLARE @RES_tbl nvarchar(max)  
	DECLARE @FUEL_tbl nvarchar(max)  
	DECLARE @ANN_tbl nvarchar(max)  
	DECLARE @MON_tbl nvarchar(max)  
	DECLARE @WK_tbl nvarchar(max)  
	DECLARE @ER_tbl nvarchar(max)
	DECLARE @EP_tbl nvarchar(max)
	DECLARE @HRD_tbl nvarchar(max)
	
	SET @RES_tbl = 'Resources_' +@scen
	SET @FUEL_tbl = 'Fuels_IHS'
	SET @ANN_tbl = 'Annual_Vectors_'+@scenlong
	SET @MON_tbl = 'Monthly_Vectors_'+@scenlong
	SET @WK_tbl = 'Weekly_Vectors_'+@scenlong
	SET @ER_tbl = 'Emission_Rates_GRD'
	SET @EP_tbl = 'Emissions_Prices_IHS'
	SET @HRD_tbl = 'HeatRate_IHS'
	
	DECLARE @dynsql nvarchar(max)  
		
	/*Check that parameter references exist*/
	SET @dynsql = N'USE '+ QUOTENAME(@dbname) + N'

	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@FUEL_tbl)+' WHERE [Fuel ID] = '''+@fuel+''')
		BEGIN
		RAISERROR(''The Fuel Code reference does not exist in the Fuels table.'',16,1)
        END
		'
	IF @hrd IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@HRD_tbl)+' WHERE [ID] = '''+@hrd+''')
		BEGIN
		RAISERROR(''The heat rate reference does not exist in the HRD table.'',16,1)
        END
		'
	IF @varOM IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@ANN_tbl)+' WHERE [ID] = '''+@varOM+''')
		BEGIN
		RAISERROR(''The variable O&M reference does not exist in the annual vectors table.'',16,1)
        END
		'
	IF @ForceOut IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@MON_tbl)+' WHERE [ID] = '''+@ForceOut+''')
		BEGIN
		RAISERROR(''The forced outage reference does not exist in the monthly vectors table.'',16,1)
        END
		'
	IF @Maint IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@MON_tbl)+' WHERE [ID] = '''+@Maint+''') AND NOT EXISTS (SELECT * FROM '+QUOTENAME(@ANN_tbl)+' WHERE [ID] = '''+@Maint+''')
		BEGIN
		RAISERROR(''The maintenance reference does not exist in the annual or monthly vector tables.'',16,1)
        END
		'
	IF @CapShape IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@ANN_tbl)+' WHERE [ID] = '''+@CapShape+''')
		BEGIN
		RAISERROR(''The capacity shape reference does not exist in the annual vectors table.'',16,1)
        END
		'
	IF @ER IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@ER_tbl)+' WHERE [ID] = '''+@ER+''')
		BEGIN
		RAISERROR(''The emissions rate reference does not exist.'',16,1)
        END
		'
	IF @EP IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF NOT EXISTS (SELECT * FROM '+QUOTENAME(@EP_tbl)+' WHERE [ID] = '''+@EP+''')
		BEGIN
		RAISERROR(''The emissions price reference does not exist.'',16,1)
        END
		'
	IF @PlantName IS NOT NULL	
		SET @dynsql = @dynsql + '
	IF EXISTS (SELECT * FROM '+QUOTENAME(@RES_tbl)+' WHERE [Name] = '''+@PlantName+''')
		BEGIN
		RAISERROR(''The plant name already exist in the resources table.'',16,1)
        END
		'
	--print @dynsql;
	EXEC sp_executesql @dynsql;

	

