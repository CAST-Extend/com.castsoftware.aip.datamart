REM ------------------------------------------------------------------------------
REM ------
REM ------ DO NOT CHANGE ANYTHING BELOW THIS LINE 
REM ------
REM ------------------------------------------------------------------------------

IF NOT DEFINED DEFAULT_DOMAIN (echo Missing variable DEFAULT_DOMAIN & EXIT /b 1)
IF NOT DEFINED PSQL (echo Missing variable PSQL & EXIT /b 1)
IF NOT DEFINED VACUUMDB (echo Missing variable VACUUMDB & EXIT /b 1)
IF NOT DEFINED DEFAULT_ROOT (echo Missing variable DEFAULT_ROOT & EXIT /b 1)
IF NOT DEFINED _DB_HOST (echo Missing variable _DB_HOST & EXIT /b 1)
IF NOT DEFINED _DB_PORT (echo Missing variable _DB_PORT & EXIT /b 1)
IF NOT DEFINED _DB_NAME (echo Missing variable _DB_NAME & EXIT /b 1)
IF NOT DEFINED _DB_USER (echo Missing variable _DB_USER & EXIT /b 1)
IF NOT DEFINED _DB_SCHEMA (echo Missing variable _DB_SCHEMA & EXIT /b 1)

IF NOT EXIST "%PSQL%" (echo Invalid path for PSQL: %PSQL% & EXIT /b 1)
IF NOT EXIST "%VACUUMDB%" (echo Invalid path for VACUUMDB: %VACUUMDB% & EXIT /b 1)

SET INSTALLATION_FOLDER=%cd%
SET EXTRACT_FOLDER=%INSTALLATION_FOLDER%\extract
SET TRANSFORM_FOLDER=%INSTALLATION_FOLDER%\transform
SET VIEWS_FOLDER=%INSTALLATION_FOLDER%\views

IF NOT EXIST "%INSTALLATION_FOLDER%\log" MKDIR "%INSTALLATION_FOLDER%\log"
IF NOT DEFINED LOG_FILE SET LOG_FILE=%INSTALLATION_FOLDER%\log\ETL-%date%-%time::=-%.log

SET PSQL_OPTIONS=-d %_DB_NAME% -h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT% --set=ON_ERROR_STOP=true
SET VACUUM_OPTIONS=-h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT%
