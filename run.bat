@echo off
if [%1] == [refresh] goto :RUN
if [%1] == [install] goto :RUN
if [%1] == [merge] if not "%DOMAIN%" == "AAD" goto :RUN

echo Usage is
echo run refresh
echo    To refresh all datamart tables with a new snapshot. 
echo run install
echo    To create or re-recreate all the datamart tables; some dependent tables or views will be dropped
echo    Use install
echo       1. for the first run
echo       2. if you have changed the set of quality standard tags (see variable QSTAGS of setenv.bat)
echo       3. to take into account a new version of the datamart Web Services
echo run merge
echo    To extract and append the data when DOMAIN is a regular ED domain
echo    'load refresh' or 'load install' must have been previously called

goto :FAIL

:RUN
call extract %1 %2 %3   || goto :FAIL
call transform %1 %2 %3 || goto :FAIL
call load %1 %2 %3      || goto :FAIL
GOTO :EOF

:FAIL
EXIT /b 1


