@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

echo.
echo INSTALLATION_FOLDER=%INSTALLATION_FOLFER%
echo.
echo EXTRACTION SCOPE
echo ================
echo DATAPOND=%DATAPOND%
echo EXTRACT_SRC=%EXTRACT_SRC% 
echo EXTRACT_MOD=%EXTRACT_MOD% 
echo.
echo REST API CLIENT SETTINGS
echo ========================
echo DEFAULT_DOMAIN=%DEFAULT_DOMAIN% 
echo DEFAULT_ROOT=%DEFAULT_ROOT% 
echo HD_ROOT=%HD_ROOT%
echo ED_ROOT=%ED_ROOT%
echo JOBS=%JOBS%
echo.
echo DB SETTINGS
echo =============
echo _DB_HOST=%_DB_HOST% 
echo _DB_PORT=%_DB_PORT% 
echo _DB_NAME=%_DB_NAME% 
echo _DB_USER=%_DB_USER% 
echo _DB_SCHEMA=%_DB_SCHEMA% 