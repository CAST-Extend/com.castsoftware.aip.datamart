@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%


IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%" MKDIR "%TRANSFORM_FOLDER%\%DOMAIN%"
del /F /Q /A "%TRANSFORM_FOLDER%\%DOMAIN%"

if "%1" == "ed-update" if "%DOMAIN%" == "AAD" goto :USAGE
if "%1" == "hd-update" if not "%DOMAIN%" == "AAD" goto :USAGE

if "%1" == "refresh" goto :TRANSFORM
if "%1" == "install" goto :TRANSFORM
if "%1" == "hd-update" goto :TRANSFORM
if "%1" == "ed-update" goto :TRANSFORM

:USAGE
echo This command should be called from the run.bat command
echo Usage is
echo.
echo Single Data Source
echo transform install ROOT DOMAIN
echo     All tables have been created or recreated, transform CSV data to copy all data.
echo transform refresh ROOT DOMAIN
echo     All tables are already filled, transform CSV data in order to truncate all tables and copy data
echo.
echo Multiple Data Source
echo transform install ROOT DOMAIN
echo     All tables have been created or recreated, transform CSV data to copy all data.
echo transform refresh HD_ROOT AAD
echo     All tables are already filled, transform CSV data in order to truncate all tables and copy data
echo transform hd-update HD_ROOT AAD
echo     All HD tables are already filled, transform CSV data in order to truncate only HD tables and copy data
echo transform ed-update ED_ROOT ED_DOMAIN
echo     All ED tables are already filled, if a new snapshot is added or a new application is added, transform CSV data in order to delete these data, and copy data for this application
goto :FAIL

:TRANSFORM
python transform.py --domain "%DOMAIN%" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%" || GOTO :FAIL
GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==