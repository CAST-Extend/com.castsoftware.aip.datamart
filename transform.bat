@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%


IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%" MKDIR "%TRANSFORM_FOLDER%\%DOMAIN%"
del /F /Q /A "%TRANSFORM_FOLDER%\%DOMAIN%"

if "%1" == "append_details" if "%DOMAIN%" == "AAD" goto :USAGE

if "%1" == "refresh" goto :TRANSFORM
if "%1" == "install" goto :TRANSFORM
if "%1" == "append_details" goto :TRANSFORM
if "%1" == "replace_details" goto :TRANSFORM
if "%1" == "refresh_measures" goto :TRANSFORM

:USAGE
echo This command should be called from the run.bat command
echo Usage is
echo transform refresh^|install
echo transform refresh^|install ROOT DOMAIN
echo     to transform CSV data for an install or refresh
echo     if the "DOMAIN" argument is not set then the DEFAULT_DOMAIN is applied
echo transform append_details ROOT DOMAIN
echo     to transform CSV data in order to append engineering data
echo transform replace_details ROOT DOMAIN
echo     to transform CSV data in order to replace engineering data
echo transform refresh_measures ROOT DOMAIN
echo     to transform CSV data in order to refresh measures data
goto :FAIL

:TRANSFORM
"%INSTALLATION_FOLDER%\transform.py" --domain "%DOMAIN%" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%" || GOTO :FAIL
GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==