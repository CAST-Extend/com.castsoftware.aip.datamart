@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat
CALL checkenv.bat

echo.
echo INSTALLATION_FOLDER=%INSTALLATION_FOLDER%
echo.
echo REST API
echo ========
if defined CREDENTIALS echo CREDENTIALS=*****
if not defined CREDENTIALS echo CREDENTIALS=

if defined APIUSER echo APIUSER=*****
if not defined APIUSER echo APIUSER=

if defined APIKEY echo APIKEY=*****
if not defined APIKEY echo APIKEY=

echo DEFAULT_DOMAIN=%DEFAULT_DOMAIN% 
echo DEFAULT_ROOT=%DEFAULT_ROOT% 
echo HD_ROOT=%HD_ROOT%
for /l %%n in (0,1,9) do (echo ED_ROOT[%%n]=!ED_ROOT[%%n]!)
echo JOBS=%JOBS%
echo.
echo.
echo EXTRACTION SCOPE
echo ================
echo EXTRACT_DATAPOND=%EXTRACT_DATAPOND%
echo EXTRACT_TECHNO=%EXTRACT_TECHNO% 
echo EXTRACT_MOD=%EXTRACT_MOD% 
echo EXTRACT_SRC=%EXTRACT_SRC% 
echo EXTRACT_USR=%EXTRACT_USR% 
echo EXTRACT_ZERO_WEIGHT=%EXTRACT_ZERO_WEIGHT% 
echo DEBUG=%DEBUG%
echo.
echo TARGET DATABASE
echo ===============
echo _DB_HOST=%_DB_HOST% 
echo _DB_PORT=%_DB_PORT% 
echo _DB_NAME=%_DB_NAME% 
echo _DB_USER=%_DB_USER% 
echo _DB_SCHEMA=%_DB_SCHEMA%