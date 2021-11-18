@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%" MKDIR "%TRANSFORM_FOLDER%\%DOMAIN%"
IF [%DEBUG%] == [OFF] DEL /F /Q /A "%TRANSFORM_FOLDER%\%DOMAIN%"

if [%1] == [install] goto :TRANSFORM
if [%1] == [refresh] goto :TRANSFORM
if [%1] == [ed-install] goto :TRANSFORM
if [%1] == [hd-update] goto :TRANSFORM
if [%1] == [ed-update] goto :TRANSFORM

:USAGE
echo This command should be called from the run.bat or datamart.bat command
echo Usage is
echo.
echo Single Data Source
echo transform install ROOT DOMAIN
echo     Add COPY statement to CSV content
echo transform refresh ROOT DOMAIN
echo     Add TRUNCATE AND COPY Statements to CSV content
echo.
echo Multiple Data Source
echo transform install HD_ROOT AAD
echo     Add COPY statement to CSV content
echo transform ed-install ED_ROOT DOMAIN
echo     Add COPY statement to CSV content
echo transform refresh^|hd-update HD_ROOT AAD
echo     Add TRUNCATE AND COPY Statements to CSV content
echo transform ed-update ED_ROOT ED_DOMAIN
echo     Add DELETE and COPY statement to CSV content
EXIT /b 1

:TRANSFORM
python transform.py --domain "%DOMAIN%" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%" || GOTO :FAIL
GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==