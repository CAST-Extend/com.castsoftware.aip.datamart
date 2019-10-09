ECHO OFF
SETLOCAL enabledelayedexpansion

CALL setenv.bat

del /F /Q /A "%TRANSFORM_FOLDER%"

"%INSTALLATION_FOLDER%\transform.py" --extract "%EXTRACT_FOLDER%" --transform "%TRANSFORM_FOLDER%" || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==