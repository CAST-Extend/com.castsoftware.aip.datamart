ECHO OFF
SETLOCAL enabledelayedexpansion

CALL setenv.bat || GOTO :FAIL

REM Load Data
CALL :load BASEDATA_FLAT                        || GOTO :FAIL
CALL :load COMPLETE_FLAT                        || GOTO :FAIL
GOTO :SUCCESS

:FAIL
ECHO == Load Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
ECHO == Load Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:load
ECHO Load %~1
"%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%VIEWS_FOLDER%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF
