@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

if "%1" == "refresh" goto :RUN
if "%1" == "install" goto :RUN
if "%1" == "merge" if not "%DOMAIN%" == "AAD" goto :RUN

echo This command should be called from the run.bat command
echo Usage is
echo transform refresh
echo     To transform CSV after a full extraction
echo transform install
echo transform merge
echo     To transforl CSV adter a partial extacrtion when DOMAIN is a regular ED domain

goto :FAIL

:RUN
del /F /Q /A "%TRANSFORM_FOLDER%\%DOMAIN%"

"%INSTALLATION_FOLDER%\transform.py" --domain "%DOMAIN%" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%" || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==