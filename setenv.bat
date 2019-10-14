REM ------------------------------------------------------------------------------
REM ------
REM ------ CONFIGURE THE FOLLOWING SETTINGS
REM ------
REM ------------------------------------------------------------------------------

REM SET THE ROOT FOLDER OF THE ETL
REM MAKE SURE TO NOT INCLUDE "\" AT THE END OF THE PATH
REM DO NOT SET DOUBLE-QUOTES
SET INSTALLATION_FOLDER=C:\datamart

REM CHANGE THE POSTGRESQL PATHS 
REM DO NOT SET DOUBLE-QUOTES
REM SET PSQL=C:\Program Files\CAST\CASTStorageService3\bin\psql.exe
REM SET VACUUMDB=C:\Program Files\CAST\CASTStorageService3\bin\vacuumdb.exe
SET PSQL=D:\postgresql_css3\bin\psql.exe
SET VACUUMDB=D:\postgresql_css3\bin\vacuumdb.exe
 
REM SETS URL AND LOGIN CREDENTIALS FOR THE AIP REST API. 
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
REM EXAMPLE: 
SET ROOT=http://localhost:9090/CAST-RESTAPI/rest/AAD
SET CREDENTIALS=user:password

REM SET TARGET DB SERVER FOR DATAMART
SET _DB_HOST=localhost
SET _DB_PORT=2282
SET _DB_NAME=datamart
SET _DB_USER=
SET _DB_SCHEMA=health
SET PGPASSWORD=

REM ------------------------------------------------------------------------------
REM ------
REM ------ DO NOT CHANGE ANYTHING BELOW THIS LINE 
REM ------
REM ------------------------------------------------------------------------------

IF NOT DEFINED INSTALLATION_FOLDER (echo Missing variable INSTALLATION_FOLDER & EXIT /b 1)
IF NOT DEFINED PSQL (echo Missing variable PSQL & EXIT /b 1)
IF NOT DEFINED VACUUMDB (echo Missing variable VACUUMDB & EXIT /b 1)
IF NOT DEFINED ROOT (echo Missing variable ROOT & EXIT /b 1)
IF NOT DEFINED CREDENTIALS (echo Missing variable CREDENTIALS & EXIT /b 1)
IF NOT DEFINED _DB_HOST (echo Missing variable _DB_HOST & EXIT /b 1)
IF NOT DEFINED _DB_PORT (echo Missing variable _DB_PORT & EXIT /b 1)
IF NOT DEFINED _DB_NAME (echo Missing variable _DB_NAME & EXIT /b 1)
IF NOT DEFINED _DB_USER (echo Missing variable _DB_USER & EXIT /b 1)
IF NOT DEFINED _DB_SCHEMA (echo Missing variable _DB_SCHEMA & EXIT /b 1)
IF NOT DEFINED PGPASSWORD (echo Missing variable PGPASSWORD & EXIT /b 1)

SET EXTRACT_FOLDER=%INSTALLATION_FOLDER%\extract
SET TRANSFORM_FOLDER=%INSTALLATION_FOLDER%\transform
SET LOG_FILE=%INSTALLATION_FOLDER%\ETL.log

IF NOT EXIST "%EXTRACT_FOLDER%" MKDIR "%EXTRACT_FOLDER%"
IF NOT EXIST "%TRANSFORM_FOLDER%" MKDIR "%TRANSFORM_FOLDER%"

SET PSQL_OPTIONS=-d %_DB_NAME% -h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT% --set=ON_ERROR_STOP=true
SET VACUUM_OPTIONS=-h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT%

