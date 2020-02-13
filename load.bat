ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

if [%1] == [append] if [%DOMAIN%] == "AAD" goto :USAGE

if [%1] == [refresh] (call :REFRESH && GOTO :SUCCESS)
if [%1] == [install] (call :INSTALL && GOTO :SUCCESS)
if [%1] == [append_details] (call :LOAD_DETAILS && GOTO :SUCCESS)
if [%1] == [replace_details] (call :LOAD_DETAILS && GOTO :SUCCESS)
if [%1] == [refresh_measures] (call :LOAD_MEASURES && GOTO :SUCCESS)

if [%ERRORLEVEL%] == [1] GOTO :FAIL

:USAGE
echo This command should be called from the run.bat command
echo Usage is
echo load refresh^|install
echo load refresh^|install DOMAIN
echo     to load CSV data for an install or refresh
echo     if the "DOMAIN" argument is not set then the DEFAULT_DOMAIN is applied
echo load append_details DOMAIN
echo     to load CSV data in order to append engineering data
echo load replace_details DOMAIN
echo     to load CSV data in order to replace engineering data
echo load refresh_measures DOMAIN
echo     to load CSV data in order to refresh measures data
goto :FAIL



:INSTALL
ECHO Create schema if not exists
rem POSTGRESQL >= 9.3 OR ABOVE
rem "%PSQL%" %PSQL_OPTIONS% -c "CREATE SCHEMA IF NOT EXISTS %_DB_SCHEMA%;" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
rem POSTGRESQL <= 9.2
"%PSQL%" %PSQL_OPTIONS% -c "DO $$ BEGIN IF NOT EXISTS(SELECT schema_name FROM information_schema.schemata WHERE schema_name = '%_DB_SCHEMA%') THEN CREATE SCHEMA %_DB_SCHEMA%; END IF; END $$;" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
REM Create and Load DIM_APPLICATIONS
CALL :load DIM_APPLICATIONS                     || EXIT /b 1
ECHO Create other tables
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f create_tables.sql >> "%LOG_FILE%" 2>&1 || EXIT /b 1
REM SET FOREIGN KEY FOR TEST OR A SINGLE DATA SOURCE
REM "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f add_foreign_keys.sql >> "%LOG_FILE%" 2>&1 || EXIT /b 1
CALL :LOAD_OTHER_MEASURES                       || EXIT /b 1
CALL :LOAD_DETAILS                              || EXIT /b 1
GOTO :EOF

:REFRESH
CALL :LOAD_MEASURES                             || EXIT /b 1
CALL :LOAD_DETAILS                              || EXIT /b 1
GOTO :EOF

:LOAD_MEASURES
CALL :load DIM_APPLICATIONS                     || EXIT /b 1
CALL :LOAD_OTHER_MEASURES                       || EXIT /b 1
GOTO :EOF

:LOAD_OTHER_MEASURES
REM Load Data
CALL :load DIM_SNAPSHOTS                        || EXIT /b 1
CALL :load DIM_RULES                            || EXIT /b 1
CALL :load APP_VIOLATIONS_MEASURES              || EXIT /b 1
CALL :load APP_SIZING_MEASURES                  || EXIT /b 1
CALL :load APP_FUNCTIONAL_SIZING_MEASURES       || EXIT /b 1
CALL :load APP_HEALTH_SCORES                    || EXIT /b 1
CALL :load APP_SCORES                           || EXIT /b 1
CALL :load APP_SIZING_EVOLUTION                 || EXIT /b 1
CALL :load APP_FUNCTIONAL_SIZING_EVOLUTION      || EXIT /b 1
CALL :load APP_HEALTH_EVOLUTION                 || EXIT /b 1
CALL :load MOD_VIOLATIONS_MEASURES              || EXIT /b 1
CALL :load MOD_SIZING_MEASURES                  || EXIT /b 1
CALL :load MOD_HEALTH_SCORES                    || EXIT /b 1
CALL :load MOD_SCORES                           || EXIT /b 1
CALL :load MOD_SIZING_EVOLUTION                 || EXIT /b 1
CALL :load MOD_HEALTH_EVOLUTION                 || EXIT /b 1
CALL :load STD_RULES                            || EXIT /b 1
CALL :load STD_DESCRIPTIONS                     || EXIT /b 1
CALL :load_view DIM_QUALITY_STANDARDS           || EXIT /b 1
GOTO :EOF

:LOAD_DETAILS
CALL :load SRC_OBJECTS                          || EXIT /b 1
CALL :load SRC_TRANSACTIONS                     || EXIT /b 1
CALL :load SRC_MOD_OBJECTS                      || EXIT /b 1
CALL :load SRC_TRX_OBJECTS                      || EXIT /b 1
CALL :load SRC_VIOLATIONS                       || EXIT /b 1
CALL :load SRC_HEALTH_IMPACTS                   || EXIT /b 1
CALL :load SRC_TRX_HEALTH_IMPACTS               || EXIT /b 1
CALL :load USR_EXCLUSIONS                       || EXIT /b 1
CALL :load USR_ACTION_PLAN                      || EXIT /b 1
GOTO :EOF

:FAIL
ECHO == Load Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
ECHO == Load Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:load
ECHO Load %TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
"%VACUUMDB%" -z %VACUUM_OPTIONS% -t %_DB_SCHEMA%.%~1 %_DB_NAME% >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF

:load_view
ECHO Load %VIEWS_FOLDER%\%~1.sql
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%VIEWS_FOLDER%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF
