ECHO OFF
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

SET LOG_FILE=%LOG_FOLDER%\VIEWS.log
echo > "%LOG_FILE%"

REM Load Data
CALL :load DIM_OMG_ASCQM                        || GOTO :FAIL
CALL :load DIM_OWASP_2017                       || GOTO :FAIL
GOTO :SUCCESS

:FAIL
popd
ECHO == Load Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
popd
ECHO == Load Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:load
ECHO Load %VIEWS_FOLDER%\%~1.sql
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%VIEWS_FOLDER%\%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF
