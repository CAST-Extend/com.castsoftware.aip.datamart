ECHO OFF
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

SET LOG_FILE=%LOG_FOLDER%\schema_upgrade.log
ECHO > "%LOG_FILE%"

ECHO Upgrade schema
python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f upgrade_schema.sql >> "%LOG_FILE%" 2>&1 || GOTO :FAIL
call load_data_dictionary || GOTO :FAIL
GOTO :SUCCESS

:FAIL
popd
ECHO == Schema upgrade Failed (see %LOG_FILE% file) ==
EXIT /b 1

:SUCCESS
popd
ECHO == Schema upgrade Done: schema '%_DB_SCHEMA%', database '%_DB_NAME%', host '%_DB_HOST%' ==
EXIT /b 0