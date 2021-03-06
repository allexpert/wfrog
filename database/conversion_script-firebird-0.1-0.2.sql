-- Before the changes it is good to do a backup export of the db  ... just in case :-)
-- (see below for restore command)
--
-- gbak -v -t -user SYSDBA -password "masterkey" localhost:/var/lib/firebird/2.1/data/wfrog.db wfrog.fbk

-- Drop unnecessary fields

DELETE FROM RDB$DEPENDENCIES WHERE RDB$DEPENDED_ON_NAME='METEO';

ALTER TABLE METEO 
   DROP TEMP_MIN,
   DROP TEMP_MIN_TIME,
   DROP TEMP_MAX,
   DROP TEMP_MAX_TIME,
   DROP WIND_GUST_TIME,
   DROP RAIN_RATE_TIME;

ALTER TABLE METEO
   ADD TMP1 NUMERIC(4,1),
   ADD TMP2 NUMERIC(4,1); 

COMMIT;

-- Reducing field precision from int to smallint for RAIN and RAIN_RATE fields 
-- requires creating temporal fields first.

UPDATE METEO SET TMP1 = RAIN, TMP2 = RAIN_RATE;

ALTER TABLE METEO 
   DROP RAIN,
   DROP RAIN_RATE;

ALTER TABLE METEO 
   ADD RAIN NUMERIC(4,1),
   ADD RAIN_RATE  NUMERIC(4,1);

COMMIT;

UPDATE METEO SET RAIN = TMP1, RAIN_RATE = TMP2;

ALTER TABLE METEO 
   DROP TMP1,
   DROP TMP2;

COMMIT;

-- Add field comments. Useful when viewing table properties in Flamerobin

UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'TEMPERATURE (C)'  where RDB$FIELD_NAME = 'TEMP' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = '% RELATIVE HUMIDITY'  where RDB$FIELD_NAME = 'HUM' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'WIND AVERAGE SPEED (m/s)'  where RDB$FIELD_NAME = 'WIND' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'WIND PREDOMINANT DIRECTION (0-359)'  where RDB$FIELD_NAME = 'WIND_DIR' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'WIND GUST SPEED (m/s)'  where RDB$FIELD_NAME = 'WIND_GUST' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'WIND GUST DIRECTION (0-359)'  where RDB$FIELD_NAME = 'WIND_GUST_DIR' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'DEWPOINT TEMPERATURE (C)'  where RDB$FIELD_NAME = 'DEW_POINT' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'RAIN FALL (mm)'  where RDB$FIELD_NAME = 'RAIN' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'RAIN RATE (mm/hr)'  where RDB$FIELD_NAME = 'RAIN_RATE' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'ATMOSFERIC PRESSURE (mb)'  where RDB$FIELD_NAME = 'PRESSURE' and RDB$RELATION_NAME = 'METEO';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'UV INDEX'  where RDB$FIELD_NAME = 'UV_INDEX' and RDB$RELATION_NAME = 'METEO';

COMMIT;


-- Export and import to improve database structure and performance:
--
-- gbak -v -t -user SYSDBA -password "masterkey" localhost:/var/lib/firebird/2.1/data/wfrog.db wfrog.fbk 
-- gbak -v -rep -use_all_space -user SYSDBA -password "masterkey" wfrog.fbk localhost:/var/lib/firebird/2.1/data/wfrog.db

