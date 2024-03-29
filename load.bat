ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

SET LOG_FILE=%LOG_FOLDER%\%DOMAIN%.log
echo > "%LOG_FILE%"

if [%1] == [install] (call :INSTALL && GOTO :SUCCESS)
if [%1] == [refresh] (call :REFRESH && GOTO :SUCCESS)
if [%1] == [ed-install] (call :LOAD_DETAILS && GOTO :SUCCESS)
if [%1] == [ed-update] (call :LOAD_DETAILS && GOTO :SUCCESS)
if [%1] == [hd-update] (call :LOAD_MEASURES && GOTO :SUCCESS)

if [%ERRORLEVEL%] == [1] GOTO :FAIL

:USAGE
echo This command should be called from the run.bat command or datamart.bat
echo Usage is
echo.
echo Single Data Source
echo load refresh^|install
echo load refresh^|install DOMAIN
echo     To load CSV data for an install or refresh
echo     if the "DOMAIN" argument is not set then the DEFAULT_DOMAIN is applied
echo.
echo Multiple Data Source
echo load install^|refresh^|hd-update HD_ROOT AAD
echo     To load CSV health data
echo load ed-install^|ed-update ED_ROOT DOMAIN
echo     To load CSV engineering date
EXIT /b 1


:INSTALL
ECHO Create schema '%_DB_SCHEMA%' if not exists
rem POSTGRESQL >= 9.3 OR ABOVE
rem python utilities\run.py "%PSQL%" %PSQL_OPTIONS% -c "CREATE SCHEMA IF NOT EXISTS %_DB_SCHEMA%;" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
rem POSTGRESQL <= 9.2
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% -c "DO $$ BEGIN IF NOT EXISTS(SELECT schema_name FROM information_schema.schemata WHERE schema_name = lower('%_DB_SCHEMA%')) THEN CREATE SCHEMA %_DB_SCHEMA%; END IF; END $$;" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
REM Create and Load DIM_APPLICATIONS
CALL :load DIM_APPLICATIONS                     || EXIT /b 1
CALL :load DATAPOND_ORGANIZATION                || EXIT /b 1
ECHO Create other tables
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f create_tables.sql >> "%LOG_FILE%" 2>&1 || EXIT /b 1
CALL load_data_dictionary                       || EXIT /b 1
REM SET FOREIGN KEY FOR TEST OR A SINGLE DATA SOURCE
REM python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f add_foreign_keys.sql >> "%LOG_FILE%" 2>&1 || EXIT /b 1
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
CALL :load DIM_OMG_RULES                        || EXIT /b 1
CALL :load DIM_CISQ_RULES                       || EXIT /b 1
CALL :load APP_VIOLATIONS_MEASURES              || EXIT /b 1
CALL :load APP_VIOLATIONS_EVOLUTION             || EXIT /b 1
CALL :load APP_SIZING_MEASURES                  || EXIT /b 1
CALL :load APP_TECHNO_SIZING_MEASURES           || EXIT /b 1
CALL :load APP_FUNCTIONAL_SIZING_MEASURES       || EXIT /b 1
CALL :load APP_HEALTH_SCORES                    || EXIT /b 1
CALL :load APP_SCORES                           || EXIT /b 1
CALL :load APP_TECHNO_SCORES                    || EXIT /b 1
CALL :load APP_SIZING_EVOLUTION                 || EXIT /b 1
CALL :load APP_TECHNO_SIZING_EVOLUTION          || EXIT /b 1
CALL :load APP_FUNCTIONAL_SIZING_EVOLUTION      || EXIT /b 1
CALL :load APP_HEALTH_EVOLUTION                 || EXIT /b 1
CALL :load MOD_VIOLATIONS_MEASURES              || EXIT /b 1
CALL :load MOD_VIOLATIONS_EVOLUTION             || EXIT /b 1
CALL :load MOD_SIZING_MEASURES                  || EXIT /b 1
CALL :load MOD_TECHNO_SIZING_MEASURES           || EXIT /b 1
CALL :load MOD_HEALTH_SCORES                    || EXIT /b 1
CALL :load MOD_SCORES                           || EXIT /b 1
CALL :load MOD_TECHNO_SCORES                    || EXIT /b 1
CALL :load MOD_SIZING_EVOLUTION                 || EXIT /b 1
CALL :load MOD_TECHNO_SIZING_EVOLUTION          || EXIT /b 1
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
CALL :load APP_FINDINGS_MEASURES                || EXIT /b 1
GOTO :EOF

:FAIL
ECHO == Load Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
IF [%DEBUG%] == [OFF] ECHO Cleanup "%DOMAIN%" intermediate files
IF [%DEBUG%] == [OFF] RMDIR /Q /S "%EXTRACT_FOLDER%\%DOMAIN%
IF [%DEBUG%] == [OFF] RMDIR /Q /S "%TRANSFORM_FOLDER%\%DOMAIN%"
ECHO == Load Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:load
IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql" GOTO :EOF
ECHO Load %TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
python utilities\run.py "%VACUUMDB%" -z %VACUUM_OPTIONS% -t %_DB_SCHEMA%.%~1 %_DB_NAME% >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF

:load_view
ECHO Load %VIEWS_FOLDER%\%~1.sql
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%VIEWS_FOLDER%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF

