@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
echo %*
set DOMAIN=%3
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

if "%1" == "merge" if "%DOMAIN%" == "AAD" goto :USAGE

if "%1" == "refresh" goto :RUN
if "%1" == "install" goto :RUN
if "%1" == "merge" goto :RUN

:USAGE
echo This command should be called from the run.bat command
echo Usage is
echo transform refresh^|install [DOMAIN]
echo     install: to transform CSV for an install or reinstall
echo     refresh: to transform CSV for refreshing data
echo transform merge [DOMAIN]
echo     merge: to transform CSV after a partial extraction when DOMAIN is a regular ED domain
echo if the "DOMAIN" argument is not set then the DEFAULT_DOMAIN is applied

goto :FAIL

:RUN
IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%" MKDIR "%TRANSFORM_FOLDER%\%DOMAIN%"
del /F /Q /A "%TRANSFORM_FOLDER%\%DOMAIN%"

"%INSTALLATION_FOLDER%\transform.py" --domain "%DOMAIN%" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%" || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==