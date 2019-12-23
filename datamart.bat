@echo off

SET HD_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET ED_ROOT=http://localhost:9090/CAST-RESTAPI/rest
REM SET ED_DOMAINS
REM We do not use a pipe because we need error handling
echo Fetch domains from %HD_ROOT%
(call utilities\get_domains %HD_ROOT% > DOMAINS.TXT) || goto :FAIL
FOR /F "tokens=* USEBACKQ" %%D IN (`type DOMAINS.TXT`) DO (SET ED_DOMAINS=%%D)
echo. 

if [%1] == [install] goto :INSTALL
if [%1] == [refresh] goto :REFRESH

echo Usage is
echo datamart install
echo    To create tables and extract data from AAD domain and all ED domains
echo datamart refresh
echo    To truncate tables and extract data from AAD domain and all ED domains
goto :FAIL

:INSTALL
call run install %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (call run merge %ED_ROOT% %%D || goto :FAIL)
GOTO :SUCCESS

:REFRESH
call run refresh %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (call run merge %ED_ROOT% %%D || goto :FAIL)
GOTO :SUCCESS

:FAIL
echo Datamart %1 FAIL
EXIT /b 1

:SUCCESS
echo Datamart %1 SUCCESS



