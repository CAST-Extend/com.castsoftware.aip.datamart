@echo off
if [%1] == [refresh] goto :RUN
if [%1] == [install] goto :RUN
if [%1] == [append_details] goto :RUN
if [%1] == [replace_details] goto :RUN
if [%1] == [refresh_measures] goto :RUN

echo Usage is
echo run refresh
echo    to refresh all datamart tables using this domain
echo run install
echo    to create or re-recreate all the datamart tables; some dependent tables or views will be dropped
echo    use install
echo       1. for the first run
echo       2. if you have changed the set of quality standard tags
echo       3. to take into account a new version of the datamart Web Services
goto :FAIL

:RUN
call extract %1 %2 %3   || goto :FAIL
call transform %1 %3    || goto :FAIL
call load %1 %3         || goto :FAIL
GOTO :EOF

:FAIL
EXIT /b 1


