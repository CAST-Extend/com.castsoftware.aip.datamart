ECHO OFF
SETLOCAL enabledelayedexpansion

if "%1" == "refresh" goto :RUN
if "%1" == "install" goto :RUN
if "%1" == "merge" if not "%DOMAIN%" == "AAD" goto :RUN

echo This command should be called from the run.bat command
echo Usage is
echo load refresh
echo    Truncate all tables, and insert data 
echo load install
echo    (Re)Create all tables and insert data
echo load merge
echo    Append data when DOMAIN is a regular ED domain,
echo    'load refresh' or 'load install' must have been previously called
EXIT /b 1

:RUN

CALL setenv.bat || GOTO :FAIL

if "%1" == "refresh" goto :REFRESH
if "%1" == "merge" goto :MERGE

ECHO Create schema if not exists
rem POSTGRESQL >= 9.3 OR ABOVE
rem "%PSQL%" %PSQL_OPTIONS% -c "CREATE SCHEMA IF NOT EXISTS %_DB_SCHEMA%;" >> "%LOG_FILE%" 2>&1 || GOTO :FAIL
rem POSTGRESQL <= 9.2
"%PSQL%" %PSQL_OPTIONS% -c "DO $$ BEGIN IF NOT EXISTS(SELECT schema_name FROM information_schema.schemata WHERE schema_name = '%_DB_SCHEMA%') THEN CREATE SCHEMA %_DB_SCHEMA%; END IF; END $$;" >> "%LOG_FILE%" 2>&1 || GOTO :FAIL
REM Create and Load DIM_APPLICATIONS
CALL :load DIM_APPLICATIONS                     || GOTO :FAIL
CALL :load DIM_QUALITY_STANDARDS                || GOTO :FAIL
ECHO Create other tables
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f create_tables.sql >> "%LOG_FILE%" 2>&1 || GOTO :FAIL
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f add_foreign_keys.sql >> "%LOG_FILE%" 2>&1 || GOTO :FAIL
goto :CONTINUE

:REFRESH
CALL :load DIM_APPLICATIONS                     || GOTO :FAIL
CALL :load DIM_QUALITY_STANDARDS                || GOTO :FAIL

:CONTINUE
REM Load Data
CALL :load DIM_SNAPSHOTS                        || GOTO :FAIL
CALL :load DIM_RULES                            || GOTO :FAIL
CALL :load APP_VIOLATIONS_MEASURES              || GOTO :FAIL
CALL :load APP_SIZING_MEASURES                  || GOTO :FAIL
CALL :load APP_FUNCTIONAL_SIZING_MEASURES       || GOTO :FAIL
CALL :load APP_HEALTH_MEASURES                  || GOTO :FAIL
CALL :load APP_SIZING_EVOLUTION                 || GOTO :FAIL
CALL :load APP_FUNCTIONAL_SIZING_EVOLUTION      || GOTO :FAIL
CALL :load APP_HEALTH_EVOLUTION                 || GOTO :FAIL
CALL :load MOD_VIOLATIONS_MEASURES              || GOTO :FAIL
CALL :load MOD_SIZING_MEASURES                  || GOTO :FAIL
CALL :load MOD_HEALTH_MEASURES                  || GOTO :FAIL
CALL :load MOD_SIZING_EVOLUTION                 || GOTO :FAIL
CALL :load MOD_HEALTH_EVOLUTION                 || GOTO :FAIL

:MERGE
CALL :load SRC_OBJECTS                          || GOTO :FAIL
CALL :load SRC_TRANSACTIONS                     || GOTO :FAIL
CALL :load SRC_MOD_OBJECTS                      || GOTO :FAIL
CALL :load SRC_TRX_OBJECTS                      || GOTO :FAIL
CALL :load SRC_VIOLATIONS                       || GOTO :FAIL
CALL :load SRC_HEALTH_IMPACTS                   || GOTO :FAIL
CALL :load USR_EXCLUSIONS                       || GOTO :FAIL
CALL :load USR_ACTION_PLAN                      || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO == Load Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
ECHO == Load Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:load
ECHO Load %~1
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
"%VACUUMDB%" -z %VACUUM_OPTIONS% -t %_DB_SCHEMA%.%~1 %_DB_NAME% >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF
