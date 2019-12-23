@echo off

SET HD_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET ED_ROOT=http://localhost:9090/CAST-RESTAPI/rest

if [%1] == [install] goto :INSTALL
if [%1] == [refresh] goto :REFRESH

echo Extract/Transform/Load data from AAD and ED domains
echo Usage is
echo datamart install
echo    To create or re-recreate the tables of datamart schema for a first install or an upgrade
echo datamart refresh
echo    To truncate the tables of datamart schema for a common usage
goto :FAIL

:INSTALL
call run install %HD_ROOT% AAD          || goto :FAIL
call run merge   %ED_ROOT% ECHO         || goto :FAIL
call run merge   %ED_ROOT% HL           || goto :FAIL
GOTO :EOF

:REFRESH
call run refresh %HD_ROOT% AAD          || goto :FAIL
call run merge   %ED_ROOT% ECHO         || goto :FAIL
call run merge   %ED_ROOT% HL           || goto :FAIL
GOTO :EOF


:FAIL
EXIT /b 1


