@echo off

SET HD_ROOT=http://localhost:9090/Health/rest
SET ED_ROOT=http://localhost:9090/Engineering/rest
SET ED_DOMAINS=ED1,ED2

if [%1] == [install] goto :INSTALL
if [%1] == [refresh] goto :REFRESH

echo Usage is
echo datamart install
echo    To create tables and extract data from AAD and all ED domains
echo datamart refresh
echo    To truncate tables and extract data from AAD and all ED domains
goto :FAIL

:INSTALL
call run install %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (call run merge %ED_ROOT% %%D || goto :FAIL)
GOTO :EOF

:REFRESH
call run refresh %HD_ROOT% AAD || goto :FAIL
FOR %%D IN (%ED_DOMAINS%) DO (call run merge %ED_ROOT% %%D || goto :FAIL)
GOTO :EOF

:FAIL
EXIT /b 1


