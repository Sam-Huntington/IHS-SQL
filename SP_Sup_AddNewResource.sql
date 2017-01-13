
USE AURORA
IF OBJECT_ID ( 'dbo.SP_Sup_AddNewResource', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.SP_Sup_AddNewResource;
GO
CREATE PROCEDURE dbo.SP_Sup_AddNewResource
/* 
   ! >>Parameters: 
   ! 1) Database Name
   ! 2-117) Parameters
   !	
   ! >>Input: Parameter values
   ! >>Output: None
   !
*/
    @dbname nvarchar(50),
	@reporting nvarchar(50),
	@ID nvarchar(50),
	@Name nvarchar(50),
	@Utility nvarchar(50),
	@Heat_Rate nvarchar(50),
	@Capacity nvarchar(50),
	@Fuel nvarchar(50),
	@Area nvarchar(50),
	@Variable_OM nvarchar(50),
	@Fixed_OM nvarchar(50),
	@Var_Cost_Mod1 nvarchar(50),
	@Var_Cost_Mod2 nvarchar(50),
	@Forced_Outage nvarchar(50),
	@Maintenance_Rate nvarchar(50),
	@Non_Cycling nvarchar(50),
	@Must_Run nvarchar(50),
	@Start_Up_Costs nvarchar(50),
	@Minimum_Capacity nvarchar(50),
	@Resource_Begin_Date nvarchar(50),
	@Resource_End_Date nvarchar(50),
	@Capacity_Monthly_Shape nvarchar(50),
	@Heat_Rate_at_Minimum nvarchar(50),
	@Heat_Rate_Scalar nvarchar(50),
	@Ramp_Rate nvarchar(50),
	@Min_Up_Time nvarchar(50),
	@Min_Down_Time nvarchar(50),
	@Committed_Heat_Rate nvarchar(50),
	@Storage_Control_Type nvarchar(50),
	@Storage_Inflow nvarchar(50),
	@Recharge_Capacity nvarchar(50),
	@Maximum_Storage nvarchar(50),
	@Initial_Contents nvarchar(50),
	@Primary_Fuel_Limit nvarchar(50),
	@Start_Fuel_ID nvarchar(50),
	@Start_Fuel_Amount nvarchar(50),
	@Fuel_Adder nvarchar(50),
	@Fuel_Multiplier nvarchar(50),
	@Second_Fuel nvarchar(50),
	@Second_Fuel_Limit nvarchar(50),
	@Second_Fuel_Adder nvarchar(50),
	@Second_Fuel_Heat_Rate nvarchar(50),
	@Second_Fuel_Multiplier nvarchar(50),
	@Second_Emission_Rate_ID nvarchar(50),
	@Accounting_Fuel nvarchar(50),
	@Emission_Rate_ID nvarchar(50),
	@Emission_Price_ID nvarchar(50),
	@Hydro_Number nvarchar(50),
	@Resource_Group nvarchar(255),
	@Mean_Repair_Time nvarchar(50),
	@Risk_Outage nvarchar(50),
	@Risk_Resource_Link nvarchar(50),
	@Cycle_Only_Capacity nvarchar(50),
	@Cycle_Only_Heat_Rate nvarchar(50),
	@Cycle_Only_Startup_Cost nvarchar(50),
	@UBB_Heat_Rate nvarchar(50),
	@UBB_Bidding_Factor nvarchar(50),
	@UBB_Segment_Size nvarchar(50),
	@UBB_Bidding_Shape nvarchar(50),
	@Bidding_Factor nvarchar(50),
	@Bidding_Shape nvarchar(50),
	@Bidding_Adder nvarchar(50),
	@Shadow_Bidding_Adder nvarchar(50),
	@Shadow_Bidding_Resource nvarchar(50),
	@Max_Operating_Reserve nvarchar(50),
	@Resource_Fixed nvarchar(50),
	@Can_Drop nvarchar(50),
	@Peak_Credit nvarchar(50),
	@Heat_Rate_Units nvarchar(50),
	@Currency_Units nvarchar(50),
	@zREM_EIA_Plant_Code nvarchar(50),
	@zREM_EIA_Gen_Code nvarchar(50),
	@zREM_Total_Capacity nvarchar(50),
	@zREM_Plant_State nvarchar(50),
	@zREM_Plant_County nvarchar(50),
	@zREM_Plant_City nvarchar(50),
	@Primary_Key nvarchar(50),
	@Emission_Rate_Units nvarchar(50),
	@Emission_Price_Units nvarchar(50),
	@Maint_Begin nvarchar(50),
	@Maint_End nvarchar(50),
	@Storage_Shaping_Factor nvarchar(50),
	@zREM_COGEN_YN nvarchar(50),
	@zREM_NERC_Region nvarchar(50),
	@zREM_NERC_Subregion nvarchar(50),
	@zREM_EV_Unit_Status nvarchar(50),
	@zREM_EV_Unit_Status_Category nvarchar(50),
	@zREM_Unit_Status_Date nvarchar(50),
	@zREM_Plant_Country nvarchar(50),
	@zREM_Online_Year nvarchar(50),
	@zREM_Prime_Mover_Code nvarchar(50),
	@zREM_Prime_Mover_Category nvarchar(50),
	@zREM_EV_Fuel_Code nvarchar(50),
	@zREM_EV_Fuel_Category nvarchar(50),
	@zREM_EV_Nameplate_Capacity nvarchar(50),
	@zREM_EV_Summer_Capacity nvarchar(50),
	@zREM_EV_Winter_Capacity nvarchar(50),
	@zREM_Unit_Number nvarchar(50),
	@zREM_AURORA_Demand_Area_Name nvarchar(50),
	@zREM_AURORA_Zone_Name nvarchar(50),
	@zREM_EV_Unit_ID nvarchar(50),
	@zREM_EV_Plant_ID nvarchar(50),
	@zREM_Other_Comments nvarchar(50),
	@zREM_Other_Comments2 nvarchar(50),
	@zREM_Other_Comments3 nvarchar(50),
	@zREM_Other_Comments4 nvarchar(50),
	@zREM_Other_Comments5 nvarchar(50),
	@zREM_CERA_Fuel_Group nvarchar(50),
	@zREM_CERA_PM_Type nvarchar(50),
	@zREM_CERA_FuelPM_Group nvarchar(50),
	@zREM_CERA_Status_Type nvarchar(50),
	@Country nvarchar(50),
	@Retire_year nvarchar(50),
	@region nvarchar(50),
	@zREM_Nuclear_Refurb nvarchar(50),
	@zREM_Incremental_Capacity nvarchar(50),
	@Detailed_Fuel_Type nvarchar(50)


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

	/*Body of the query*/
	SET @dynsql = N'USE '+ QUOTENAME(@dbname) + N'
	INSERT INTO dbo._Input_Resources_RIV1 ([Reporting], [ID], [Name], [Utility], [Heat_Rate], [Capacity], [Fuel], [Area], [Variable_O&M], [Fixed_O&M], [Var_Cost_Mod1], [Var_Cost_Mod2], [Forced_Outage], [Maintenance_Rate], [Non_Cycling], [Must_Run], [Start_Up_Costs], [Minimum_Capacity], [Resource_Begin_Date], [Resource_End_Date], [Capacity_Monthly_Shape], [Heat_Rate_at_Minimum], [Heat_Rate_Scalar], [Ramp_Rate], [Min_Up_Time], [Min_Down_Time], [Committed_Heat_Rate], [Storage_Control_Type], [Storage_Inflow], [Recharge_Capacity], [Maximum_Storage], [Initial_Contents], [Primary_Fuel_Limit], [Start_Fuel_ID], [Start_Fuel_Amount], [Fuel_Adder], [Fuel_Multiplier], [Second_Fuel], [Second_Fuel_Limit], [Second_Fuel_Adder], [Second_Fuel_Heat_Rate], [Second_Fuel_Multiplier], [Second_Emission_Rate_ID], [Accounting_Fuel], [Emission_Rate_ID], [Emission_Price_ID], [Hydro_Number], [Resource_Group], [Mean_Repair_Time], [Risk_Outage], [Risk_Resource_Link], [Cycle_Only_Capacity], [Cycle_Only_Heat_Rate], [Cycle_Only_Startup_Cost], [UBB_Heat_Rate], [UBB_Bidding_Factor], [UBB_Segment_Size], [UBB_Bidding_Shape], [Bidding_Factor], [Bidding_Shape], [Bidding_Adder], [Shadow_Bidding_Adder], [Shadow_Bidding_Resource], [Max_Operating_Reserve], [Resource_Fixed], [Can_Drop], [Peak_Credit], [Heat_Rate_Units], [Currency_Units], [zREM_EIA_Plant_Code], [zREM_EIA_Gen_Code], [zREM_Total_Capacity], [zREM_Plant_State], [zREM_Plant_County], [zREM_Plant_City], [Emission_Rate_Units], [Emission_Price_Units], [Maint_Begin], [Maint_End], [Storage_Shaping_Factor], [zREM_COGEN_Y/N], [zREM_NERC_Region], [zREM_NERC_Sub-region], [zREM_EV_Unit_Status], [zREM_EV_Unit_Status_Category], [zREM_Unit_Status_Date], [zREM_Plant_Country], [zREM_Online_Year], [zREM_Prime_Mover_Code], [zREM_Prime_Mover_Category], [zREM_EV_Fuel_Code], [zREM_EV_Fuel_Category], [zREM_EV_Nameplate_Capacity], [zREM_EV_Summer_Capacity], [zREM_EV_Winter_Capacity], [zREM_Unit_Number], [zREM_AURORA_Demand_Area_Name], [zREM_AURORA_Zone_Name], [zREM_EV_Unit_ID], [zREM_EV_Plant_ID], [zREM_Other_Comments], [zREM_Other_Comments2], [zREM_Other_Comments3], [zREM_Other_Comments4], [zREM_Other_Comments5], [zREM_CERA_Fuel_Group], [zREM_CERA_PM_Type], [zREM_CERA_FuelPM_Group], [zREM_CERA_Status_Type], [Country], [Retire_year], [region], [zREM_Nuclear_Refurb], [zREM_Incremental_Capacity], [Detailed_Fuel_Type])
	VALUES ('''+@reporting+''','''+@ID+''','''+@Name+''','''+@Utility+''','''+@Heat_Rate+''','''+@Capacity+''','''+@Fuel+''','''+@Area+''','''+@Variable_OM+''','''+@Fixed_OM+''','''+@Var_Cost_Mod1+''','''+@Var_Cost_Mod2+''','''+@Forced_Outage+''','''+@Maintenance_Rate+''','''+@Non_Cycling+''','''+@Must_Run+''','''+@Start_Up_Costs+''','''+@Minimum_Capacity+''','''+@Resource_Begin_Date+''','''+@Resource_End_Date+''','''+@Capacity_Monthly_Shape+''','''+@Heat_Rate_at_Minimum+''','''+@Heat_Rate_Scalar+''','''+@Ramp_Rate+''','''+@Min_Up_Time+''','''+@Min_Down_Time+''','''+@Committed_Heat_Rate+''','''+@Storage_Control_Type+''','''+@Storage_Inflow+''','''+@Recharge_Capacity+''','''+@Maximum_Storage+''','''+@Initial_Contents+''','''+@Primary_Fuel_Limit+''','''+@Start_Fuel_ID+''','''+@Start_Fuel_Amount+''','''+@Fuel_Adder+''','''+@Fuel_Multiplier+''','''+@Second_Fuel+''','''+@Second_Fuel_Limit+''','''+@Second_Fuel_Adder+''','''+@Second_Fuel_Heat_Rate+''','''+@Second_Fuel_Multiplier+''','''+@Second_Emission_Rate_ID+''','''+@Accounting_Fuel+''','''+@Emission_Rate_ID+''','''+@Emission_Price_ID+''','''+@Hydro_Number+''','''+@Resource_Group+''','''+@Mean_Repair_Time+''','''+@Risk_Outage+''','''+@Risk_Resource_Link+''','''+@Cycle_Only_Capacity+''','''+@Cycle_Only_Heat_Rate+''','''+@Cycle_Only_Startup_Cost+''','''+@UBB_Heat_Rate+''','''+@UBB_Bidding_Factor+''','''+@UBB_Segment_Size+''','''+@UBB_Bidding_Shape+''','''+@Bidding_Factor+''','''+@Bidding_Shape+''','''+@Bidding_Adder+''','''+@Shadow_Bidding_Adder+''','''+@Shadow_Bidding_Resource+''','''+@Max_Operating_Reserve+''','''+@Resource_Fixed+''','''+@Can_Drop+''','''+@Peak_Credit+''','''+@Heat_Rate_Units+''','''+@Currency_Units+''','''+@zREM_EIA_Plant_Code+''','''+@zREM_EIA_Gen_Code+''','''+@zREM_Total_Capacity+''','''+@zREM_Plant_State+''','''+@zREM_Plant_County+''','''+@zREM_Plant_City+''','''+@Emission_Rate_Units+''','''+@Emission_Price_Units+''','''+@Maint_Begin+''','''+@Maint_End+''','''+@Storage_Shaping_Factor+''','''+@zREM_COGEN_YN+''','''+@zREM_NERC_Region+''','''+@zREM_NERC_Subregion+''','''+@zREM_EV_Unit_Status+''','''+@zREM_EV_Unit_Status_Category+''','''+@zREM_Unit_Status_Date+''','''+@zREM_Plant_Country+''','''+@zREM_Online_Year+''','''+@zREM_Prime_Mover_Code+''','''+@zREM_Prime_Mover_Category+''','''+@zREM_EV_Fuel_Code+''','''+@zREM_EV_Fuel_Category+''','''+@zREM_EV_Nameplate_Capacity+''','''+@zREM_EV_Summer_Capacity+''','''+@zREM_EV_Winter_Capacity+''','''+@zREM_Unit_Number+''','''+@zREM_AURORA_Demand_Area_Name+''','''+@zREM_AURORA_Zone_Name+''','''+@zREM_EV_Unit_ID+''','''+@zREM_EV_Plant_ID+''','''+@zREM_Other_Comments+''','''+@zREM_Other_Comments2+''','''+@zREM_Other_Comments3+''','''+@zREM_Other_Comments4+''','''+@zREM_Other_Comments5+''','''+@zREM_CERA_Fuel_Group+''','''+@zREM_CERA_PM_Type+''','''+@zREM_CERA_FuelPM_Group+''','''+@zREM_CERA_Status_Type+''','''+@Country+''','''+@Retire_year+''','''+@region+''','''+@zREM_Nuclear_Refurb+''','''+@zREM_Incremental_Capacity+''','''+@Detailed_Fuel_Type+''')
'
	--print @dynsql;
	EXEC sp_executesql @dynsql;

GO

--Grant access

USE AURORA;
GRANT Execute ON [dbo].SP_Sup_AddNewResource TO [IHS\AuroraUsers]
--GRANT Execute ON [dbo].SP_Sup_AddNewResource TO svc_AuroraXMP
