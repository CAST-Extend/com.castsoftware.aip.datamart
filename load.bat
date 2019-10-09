ECHO OFF
SETLOCAL enabledelayedexpansion

CALL setenv.bat 

rem ECHO Drop schema
rem "%PSQL%" %PSQL_OPTIONS% -c "DROP SCHEMA IF EXISTS %_DB_SCHEMA% cascade;" > "%LOG_FILE%" 2>&1 || GOTO :FAIL

ECHO Create schema
"%PSQL%" %PSQL_OPTIONS% -c "CREATE SCHEMA IF NOT EXISTS %_DB_SCHEMA%;" >> "%LOG_FILE%" 2>&1 || GOTO :FAIL

REM Create and Load DIM_APPLICATIONS
CALL :load DIM_APPLICATIONS || GOTO :FAIL
ECHO Create other tables
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f create.sql >> "%LOG_FILE%" 2>&1 || GOTO :FAIL

REM Load Data
CALL :load DIM_SNAPSHOTS                        || GOTO :FAIL
CALL :load DIM_RULES                            || GOTO :FAIL
CALL :load DIM_QUALITY_STANDARDS                || GOTO :FAIL
CALL :load APP_VIOLATIONS_MEASURES              || GOTO :FAIL
CALL :load APP_TECHNICAL_SIZING_MEASURES        || GOTO :FAIL
CALL :load APP_TECHNICAL_DEBT_MEASURES          || GOTO :FAIL
CALL :load APP_FUNCTIONAL_SIZING_MEASURES       || GOTO :FAIL
CALL :load APP_HEALTH_MEASURES                  || GOTO :FAIL
CALL :load APP_TECHNICAL_DEBT_EVOLUTION         || GOTO :FAIL
CALL :load APP_FUNCTIONAL_SIZING_EVOLUTION      || GOTO :FAIL
CALL :load APP_HEALTH_EVOLUTION                 || GOTO :FAIL
CALL :load MOD_VIOLATIONS_MEASURES              || GOTO :FAIL
CALL :load MOD_TECHNICAL_SIZING_MEASURES        || GOTO :FAIL
CALL :load MOD_TECHNICAL_DEBT_MEASURES          || GOTO :FAIL
CALL :load MOD_HEALTH_MEASURES                  || GOTO :FAIL
CALL :load MOD_TECHNICAL_DEBT_EVOLUTION         || GOTO :FAIL
CALL :load MOD_HEALTH_EVOLUTION                 || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO == Load Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
ECHO == Load Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:load
ECHO Load %~1
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%TRANSFORM_FOLDER%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
"%VACUUMDB%" -z %VACUUM_OPTIONS% -t %_DB_SCHEMA%.%~1 %_DB_NAME% >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF
