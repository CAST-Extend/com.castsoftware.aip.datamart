@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%" MKDIR "%TRANSFORM_FOLDER%\%DOMAIN%"
IF [%DEBUG%] == [OFF] DEL /F /Q /A "%TRANSFORM_FOLDER%\%DOMAIN%"

python transform.py --domain "%DOMAIN%" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%"
