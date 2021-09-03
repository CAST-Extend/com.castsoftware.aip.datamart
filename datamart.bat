@echo off
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

if [%1] == [install] (CALL :FOR_EACH_DOMAIN INSTALL && GOTO :SUCCESS)
if [%1] == [refresh] (CALL :FOR_EACH_DOMAIN REFRESH && GOTO :SUCCESS)
if [%1] == [update] (CALL :FOR_EACH_DOMAIN UPDATE && GOTO :SUCCESS)

echo Usage is
echo datamart install
echo    to create tables and extract data from AAD domain and all ED domains
echo datamart refresh
echo    to truncate tables and extract data from AAD domain and all ED domains
echo datamart update
echo    to refresh measurements tables, and to refresh engineering tables when a new snapshot has been added for a domain
goto :FAIL

:FOR_EACH_DOMAIN
for /l %%n in (0,1,10) do (
  if not [!ED_ROOT[%%n]!] == [] (CALL :DATAMART %1 !ED_ROOT[%%n]! DOMAINS_%%n.TXT) || goto :FAIL
)
GOTO :EOF

:DATAMART
call :FETCH_DOMAINS %2 %3 || goto :FAIL
python datamart.py %1 %2 %3 %JOBS% || goto :FAIL
GOTO :EOF

:FAIL
popd
echo Datamart %1 FAIL
EXIT /b 1

:SUCCESS
popd
echo Datamart %1 SUCCESS
EXIT /b 0

:FETCH_DOMAINS
echo Fetch domains from %1
(call utilities\get_domains %1 %2) || EXIT /b 1
echo. 
GOTO :EOF

