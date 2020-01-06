@echo off
SETLOCAL enabledelayedexpansion
SET HD_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET ED_ROOT=http://localhost:9090/CAST-RESTAPI/rest

CALL setenv.bat || GOTO :FAIL

if [%1] == [install] goto :INSTALL
if [%1] == [refresh] goto :REFRESH
if [%1] == [update] goto :UPDATE

echo Usage is
echo datamart install
echo    to create tables and extract data from AAD domain and all ED domains
echo datamart refresh
echo    to truncate tables and extract data from AAD domain and all ED domains
echo datamart update
echo    to refresh measurements tables, and to refresh engineering tables when a new snapshot has been added for a domain
goto :FAIL

:INSTALL
call :FETCH_DOMAINS || goto :FAIL
call run install %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (call run append_details %ED_ROOT% %%D || goto :FAIL)
GOTO :SUCCESS

:REFRESH
call :FETCH_DOMAINS || goto :FAIL
call run refresh %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (call run append_details %ED_ROOT% %%D || goto :FAIL)
GOTO :SUCCESS

:UPDATE
(call utilities\check_new_snapshot %HD_ROOT%/AAD)
if [%ERRORLEVEL%] == [0] (goto :SKIP)
call :FETCH_DOMAINS || goto :FAIL
call run refresh_measures %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (
(call utilities\check_new_snapshot %ED_ROOT%/%%D)
if [%ERRORLEVEL%] == [1] call run replace_details %ED_ROOT% %%D || goto :FAIL
)
GOTO :SUCCESS

:FAIL
echo Datamart %1 FAIL
EXIT /b 1

:SUCCESS
echo Datamart %1 SUCCESS
EXIT /b 0

:SKIP
echo Datamart is already synchronized. No new snapshot
EXIT /b 0

:FETCH_DOMAINS
REM SET ED_DOMAINS
REM We do not use a pipe because we need error handling
echo Fetch domains from %HD_ROOT%
(call utilities\get_domains %HD_ROOT% > DOMAINS.TXT) || goto :FAIL
FOR /F "tokens=* USEBACKQ" %%D IN (`type DOMAINS.TXT`) DO (SET ED_DOMAINS=%%D)
echo. 
GOTO :EOF