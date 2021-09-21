ECHO OFF
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

SET LOG_FILE=%INSTALLATION_FOLDER%\log\build_data_dictionay.log

ECHO Build build_data_dictionary.sql
python utilities\build_data_dictionary.py sql > build_data_dictionary.sql || GOTO :FAIL
CALL :run build_data_dictionary || GOTO :FAIL
GOTO :SUCCESS

:FAIL
popd
ECHO == Script Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
popd
ECHO == Script Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0

:run
ECHO Run %~1.sql script
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF