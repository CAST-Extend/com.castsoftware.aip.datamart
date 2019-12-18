ECHO OFF
SETLOCAL enabledelayedexpansion

@echo off
if "%1" == "refresh" goto :RUN
if "%1" == "install" goto :RUN

echo This command should be called from the run.bat command
echo Usage is
echo transform refresh
echo transform install

goto :FAIL

:RUN
CALL setenv.bat || GOTO :FAIL

del /F /Q /A "%TRANSFORM_FOLDER%"

"%INSTALLATION_FOLDER%\transform.py" --mode "%1" --extract "%EXTRACT_FOLDER%\%DOMAIN%" --transform "%TRANSFORM_FOLDER%\%DOMAIN%" || GOTO :FAIL

GOTO :SUCCESS

:FAIL
ECHO.
ECHO == Transform Failed ==
EXIT /b 1

:SUCCESS
ECHO == Transform Done ==