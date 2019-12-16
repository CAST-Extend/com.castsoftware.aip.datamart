@echo off
if "%1" == "refresh" goto :RUN
if "%1" == "install" goto :RUN

echo Usage is
echo run refresh
echo    To refresh the data with a new snapshot. 
echo run install
echo    To create or re-recreate the datamart tables; some dependent tables or views will be dropped
echo    Use install
echo       1. for the first run
echo       2. if you have changed the set of quality standard tags (see varaible QSTAGS of setenv.bat)
echo       3. to take into account a new version of the extraction Web Services

goto :FAIL

:RUN
call extract      || goto :FAIL
call transform %1 || goto :FAIL
call load %1      || goto :FAIL

GOTO :EOF

:FAIL
EXIT /b   


