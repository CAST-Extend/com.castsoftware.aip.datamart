ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

set DOMAIN=%2
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

SET LOG_FILE=%LOG_FOLDER%\%DOMAIN%.log
echo > "%LOG_FILE%"

python load.py %1 || GOTO :EOF
IF [%DEBUG%] == [OFF] ECHO Cleanup "%DOMAIN%" intermediate files
IF [%DEBUG%] == [OFF] RMDIR /Q /S "%EXTRACT_FOLDER%\%DOMAIN%
IF [%DEBUG%] == [OFF] RMDIR /Q /S "%TRANSFORM_FOLDER%\%DOMAIN%"
IF [%DEBUG%] == [OFF] ECHO == Clean-up Done ==
EXIT /b 0


