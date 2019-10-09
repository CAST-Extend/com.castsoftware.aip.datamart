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

SET EXTRACT_FOLDER=%INSTALLATION_FOLDER%\extract
SET TRANSFORM_FOLDER=%INSTALLATION_FOLDER%\transform
SET LOG_FILE=%INSTALLATION_FOLDER%\ETL.log

IF NOT EXIST "%EXTRACT_FOLDER%" MKDIR "%EXTRACT_FOLDER%"
IF NOT EXIST "%TRANSFORM_FOLDER%" MKDIR "%TRANSFORM_FOLDER%"

SET PSQL_OPTIONS=-d %_DB_NAME% -h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT% --set=ON_ERROR_STOP=true
SET VACUUM_OPTIONS=-h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT%

