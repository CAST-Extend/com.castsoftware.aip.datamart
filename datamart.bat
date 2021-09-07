@echo off
SETLOCAL enabledelayedexpansion

pushd %~dp0
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

if [%1] == [install] (CALL :DATAMART_INSTALL && GOTO :SUCCESS)
if [%1] == [refresh] (CALL :DATAMART_REFRESH && GOTO :SUCCESS)
if [%1] == [update] (CALL :DATAMART_UDPATE && GOTO :SUCCESS)

echo Usage is
echo datamart install
echo    to create tables and extract data from AAD domain and all ED domains
echo datamart refresh
echo    to truncate tables and extract data from AAD domain and all ED domains
echo datamart update
echo    to update measurements tables and engineering tables when a new snapshot or a new application has been added for a domain
goto :FAIL

:DATAMART_INSTALL
(CALL :HD_DATAMART HD-INSTALL %HD_ROOT%) || goto :FAIL
(CALL :FOR_EACH_ED_DOMAIN ED-INSTALL) || goto :FAIL
GOTO :SUCCESS

:DATAMART_REFRESH
(CALL :HD_DATAMART HD-REFRESH %HD_ROOT%) || goto :FAIL
(CALL :FOR_EACH_ED_DOMAIN ED-INSTALL) || goto :FAIL
GOTO :SUCCESS

:DATAMART_UPDATE
call :FETCH_SNAPSHOTS %HD_ROOT% DIM_SNAPSHOTS.CSV || goto :FAIL
(CALL :HD_DATAMART HD-UPDATE %HD_ROOT%) || goto :FAIL
(CALL :FOR_EACH_ED_DOMAIN ED-UPDATE) || goto :FAIL
GOTO :SUCCESS


:FOR_EACH_ED_DOMAIN
for /l %%n in (0,1,9) do (
  if not [!ED_ROOT[%%n]!] == [] (CALL :ED_DATAMART %1 !ED_ROOT[%%n]! DOMAINS_%%n.TXT) || goto :FAIL
)
GOTO :EOF

:HD_DATAMART
python datamart.py %1 %2 || goto :FAIL
GOTO :EOF

:ED_DATAMART
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

:FETCH_SNAPSHOTS
echo Fetch snapshots from %1
(call utilities\get_snapshots %1 %2) || EXIT /b 1
echo. 
GOTO :EOF
