:setvar DBname "RIV_H22016_SH"
:setvar RunID "orm 200 60"

use $(DBname)

------------------------------------------------------
-- Fuel ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelHour1'))
BEGIN
    delete FuelHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelHour1')
END
ELSE BEGIN print('Table FuelHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelDay1'))
BEGIN
    delete FuelDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelDay1')
END
ELSE BEGIN print('Table FuelDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelMonth1'))
BEGIN
    delete FuelMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelMonth1')
END
ELSE BEGIN print('Table FuelMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelYear1'))
BEGIN
    delete FuelYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelYear1')
END
ELSE BEGIN print('Table FuelYear1 does not exist') END

------------------------------------------------------
-- FuelByZone ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelByZoneHour1'))
BEGIN
    delete FuelByZoneHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelByZoneHour1')
END
ELSE BEGIN print('Table FuelByZoneHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelByZoneDay1'))
BEGIN
    delete FuelByZoneDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelByZoneDay1')
END
ELSE BEGIN print('Table FuelByZoneDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelByZoneMonth1'))
BEGIN
    delete FuelByZoneMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelByZoneMonth1')
END
ELSE BEGIN print('Table FuelByZoneMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'FuelByZoneYear1'))
BEGIN
    delete FuelByZoneYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table FuelByZoneYear1')
END
ELSE BEGIN print('Table FuelByZoneYear1 does not exist') END

------------------------------------------------------
-- Hub ----------------------------------------------
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HubHour1'))
BEGIN
    delete HubHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table HubHour1')
END
ELSE BEGIN print('Table HubHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HubDay1'))
BEGIN
    delete HubDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table HubDay1')
END
ELSE BEGIN print('Table HubDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HubMonth1'))
BEGIN
    delete HubMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table HubMonth1')
END
ELSE BEGIN print('Table HubMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HubYear1'))
BEGIN
    delete HubYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table HubYear1')
END
ELSE BEGIN print('Table HubYear1 does not exist') END

------------------------------------------------------
-- Link ----------------------------------------------
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LinkHour1'))
BEGIN
    delete LinkHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table LinkHour1')
END
ELSE BEGIN print('Table LinkHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LinkDay1'))
BEGIN
    delete LinkDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table LinkDay1')
END
ELSE BEGIN print('Table LinkDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LinkMonth1'))
BEGIN
    delete LinkMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table LinkMonth1')
END
ELSE BEGIN print('Table LinkMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LinkYear1'))
BEGIN
    delete LinkYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table LinkYear1')
END
ELSE BEGIN print('Table LinkYear1 does not exist') END

------------------------------------------------------
-- Pool ----------------------------------------------
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PoolHour1'))
BEGIN
    delete PoolHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table PoolHour1')
END
ELSE BEGIN print('Table PoolHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PoolDay1'))
BEGIN
    delete PoolDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table PoolDay1')
END
ELSE BEGIN print('Table PoolDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PoolMonth1'))
BEGIN
    delete PoolMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table PoolMonth1')
END
ELSE BEGIN print('Table PoolMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PoolYear1'))
BEGIN
    delete PoolYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table PoolYear1')
END
ELSE BEGIN print('Table PoolYear1 does not exist') END

------------------------------------------------------
-- Resource ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceHour1'))
BEGIN
    delete ResourceHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceHour1')
END
ELSE BEGIN print('Table ResourceHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceDay1'))
BEGIN
    delete ResourceDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceDay1')
END
ELSE BEGIN print('Table ResourceDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceMonth1'))
BEGIN
    delete ResourceMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceMonth1')
END
ELSE BEGIN print('Table ResourceMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceYear1'))
BEGIN
    delete ResourceYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceYear1')
END
ELSE BEGIN print('Table ResourceYear1 does not exist') END

------------------------------------------------------
-- Resource ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceEmissionsHour1'))
BEGIN
    delete ResourceEmissionsHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceEmissionsHour1')
END
ELSE BEGIN print('Table ResourceEmissionsHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceEmissionsDay1'))
BEGIN
    delete ResourceEmissionsDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceEmissionsDay1')
END
ELSE BEGIN print('Table ResourceEmissionsDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceEmissionsMonth1'))
BEGIN
    delete ResourceEmissionsMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceEmissionsMonth1')
END
ELSE BEGIN print('Table ResourceEmissionsMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceEmissionsYear1'))
BEGIN
    delete ResourceEmissionsYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceEmissionsYear1')
END
ELSE BEGIN print('Table ResourceEmissionsYear1 does not exist') END


------------------------------------------------------
-- ResourceGroup ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupHour1'))
BEGIN
    delete ResourceGroupHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupHour1')
END
ELSE BEGIN print('Table ResourceGroupHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupDay1'))
BEGIN
    delete ResourceGroupDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupDay1')
END
ELSE BEGIN print('Table ResourceGroupDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupMonth1'))
BEGIN
    delete ResourceGroupMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupMonth1')
END
ELSE BEGIN print('Table ResourceGroupMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupYear1'))
BEGIN
    delete ResourceGroupYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupYear1')
END
ELSE BEGIN print('Table ResourceGroupYear1 does not exist') END


------------------------------------------------------
-- ResourceGroupEmissions ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupEmissionsHour1'))
BEGIN
    delete ResourceGroupEmissionsHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupEmissionsHour1')
END
ELSE BEGIN print('Table ResourceGroupEmissionsHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupEmissionsDay1'))
BEGIN
    delete ResourceGroupEmissionsDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupEmissionsDay1')
END
ELSE BEGIN print('Table ResourceGroupEmissionsDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupEmissionsMonth1'))
BEGIN
    delete ResourceGroupEmissionsMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupEmissionsMonth1')
END
ELSE BEGIN print('Table ResourceGroupEmissionsMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ResourceGroupEmissionsYear1'))
BEGIN
    delete ResourceGroupEmissionsYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ResourceGroupEmissionsYear1')
END
ELSE BEGIN print('Table ResourceGroupEmissionsYear1 does not exist') END


------------------------------------------------------
-- ZoneEmissions ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneEmissionsHour1'))
BEGIN
    delete ZoneEmissionsHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneEmissionsHour1')
END
ELSE BEGIN print('Table ZoneEmissionsHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneEmissionsDay1'))
BEGIN
    delete ZoneEmissionsDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneEmissionsDay1')
END
ELSE BEGIN print('Table ZoneEmissionsDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneEmissionsMonth1'))
BEGIN
    delete ZoneEmissionsMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneEmissionsMonth1')
END
ELSE BEGIN print('Table ZoneEmissionsMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneEmissionsYear1'))
BEGIN
    delete ZoneEmissionsYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneEmissionsYear1')
END
ELSE BEGIN print('Table ZoneEmissionsYear1 does not exist') END


------------------------------------------------------
-- Zone ----------------------------------------------

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneHour1'))
BEGIN
    delete ZoneHour1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneHour1')
END
ELSE BEGIN print('Table ZoneHour1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneDay1'))
BEGIN
    delete ZoneDay1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneDay1')
END
ELSE BEGIN print('Table ZoneDay1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneMonth1'))
BEGIN
    delete ZoneMonth1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneMonth1')
END
ELSE BEGIN print('Table ZoneMonth1 does not exist') END

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ZoneYear1'))
BEGIN
    delete ZoneYear1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table ZoneYear1')
END
ELSE BEGIN print('Table ZoneYear1 does not exist') END

------------------------------------------------------
-- StudyLog ----------------------------------------------


IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudyLog1'))
BEGIN
    delete StudyLog1
	where Run_ID like '%$(RunID)%'
	print('RunID $(RunID) successfully deleted from table StudyLog1')
END
ELSE BEGIN print('Table StudyLog1 does not exist') END