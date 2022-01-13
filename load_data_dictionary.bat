ECHO OFF
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

SET LOG_FILE=%LOG_FOLDER%\build_data_dictionay.log
ECHO Create %INSTALLATION_FOLDER%\build_data_dictionary.sql
python utilities\build_data_dictionary.py sql > build_data_dictionary.sql || GOTO :FAIL
ECHO Load %INSTALLATION_FOLDER%\build_data_dictionary.sql
CALL :run build_data_dictionary || GOTO :FAIL
GOTO :SUCCESS

:FAIL
popd
ECHO == Load Datamart Descriptions Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
popd
EXIT /b 0

:run
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1
GOTO :EOF