ECHO OFF
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

SET LOG_FILE=%INSTALLATION_FOLDER%\log\DATAPOND_VIEWS.log

REM Load Data
CALL :load DIM_CISQ                             || GOTO :FAIL
CALL :load DIM_OWASP_2017                       || GOTO :FAIL
CALL :load BASEDATA_FLAT                        || GOTO :FAIL
CALL :load COMPLETE_FLAT                        || GOTO :FAIL
CALL :load DATAPOND_BASEDATA                    || GOTO :FAIL
call :load DATAPOND_VIOLATIONS                  || GOTO :FAIL
call :load DATAPOND_AP                          || GOTO :FAIL
call :load DATAPOND_EXCLUSIONS                  || GOTO :FAIL
call :load DATAPOND_PATTERNS                    || GOTO :FAIL

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
