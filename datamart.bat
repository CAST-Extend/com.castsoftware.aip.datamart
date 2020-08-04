@echo off
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

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
python datamart.py INSTALL DOMAINS.TXT || goto :FAIL
GOTO :SUCCESS

:REFRESH
call :FETCH_DOMAINS || goto :FAIL
python datamart.py REFRESH DOMAINS.TXT || goto :FAIL
GOTO :SUCCESS

:UPDATE
call :FETCH_DOMAINS || goto :FAIL
python datamart.py UPDATE DOMAINS.TXT || goto :FAIL
GOTO :SUCCESS

:FAIL
popd
echo Datamart %1 FAIL
EXIT /b 1

:SUCCESS
popd
echo Datamart %1 SUCCESS
EXIT /b 0

:FETCH_DOMAINS
REM SET ED_DOMAINS
REM We do not use a pipe because we need error handling
echo Fetch domains from %HD_ROOT%
(call utilities\get_domains %HD_ROOT% > DOMAINS.TXT) || goto :FAIL
echo. 
GOTO :EOF