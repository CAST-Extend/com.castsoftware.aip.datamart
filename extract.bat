@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
REM CALL checkenv.bat || GOTO :FAIL

set ROOT=%2
set DOMAIN=%3
if [%ROOT%] == [] set ROOT=%DEFAULT_ROOT%
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

IF NOT DEFINED ROOT (echo ERROR: Missing variable DEFAULT_ROOT & EXIT /b 1)
IF NOT DEFINED DOMAIN (echo ERROR: Missing variable DEFAULT_DOMAIN & EXIT /b 1)

IF NOT EXIST "%EXTRACT_FOLDER%\%DOMAIN%" MKDIR "%EXTRACT_FOLDER%\%DOMAIN%"
IF [%DEBUG%] == [OFF] DEL /F /Q /A "%EXTRACT_FOLDER%\%DOMAIN%"

python extract.py %1 %ROOT% %DOMAIN%

