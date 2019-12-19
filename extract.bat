@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

if "%1" == "refresh" goto :RUN
if "%1" == "install" goto :RUN
if "%1" == "merge" if not "%DOMAIN%" == "AAD" goto :RUN

echo This command should be called from the run.bat command
echo Usage is
echo extract refresh^|install
echo     To make a full extraction
echo extract merge
echo     To make a partial extraction when DOMAIN is a regular ED domain

goto :FAIL

:RUN
del /F /Q /A "%EXTRACT_FOLDER%\%DOMAIN%"

if "%1" == "merge" goto :ED
call :extract datamart/dim-snapshots                        DIM_SNAPSHOTS                       || GOTO :FAIL
call :extract datamart/dim-rules                            DIM_RULES                           || GOTO :FAIL
call :extract "datamart/dim-quality-standards?tags=%QSTAGS%"  DIM_QUALITY_STANDARDS             || GOTO :FAIL
call :extract datamart/dim-applications                     DIM_APPLICATIONS                    || GOTO :FAIL
call :extract datamart/app-violations-measures              APP_VIOLATIONS_MEASURES             || GOTO :FAIL
call :extract datamart/app-sizing-measures                  APP_SIZING_MEASURES                 || GOTO :FAIL
call :extract datamart/app-functional-sizing-measures       APP_FUNCTIONAL_SIZING_MEASURES      || GOTO :FAIL
call :extract datamart/app-health-measures                  APP_HEALTH_MEASURES                 || GOTO :FAIL
call :extract datamart/app-sizing-evolution                 APP_SIZING_EVOLUTION                || GOTO :FAIL
call :extract datamart/app-functional-sizing-evolution      APP_FUNCTIONAL_SIZING_EVOLUTION     || GOTO :FAIL
call :extract datamart/app-health-evolution                 APP_HEALTH_EVOLUTION                || GOTO :FAIL
call :extract datamart/mod-violations-measures              MOD_VIOLATIONS_MEASURES             || GOTO :FAIL
call :extract datamart/mod-sizing-measures                  MOD_SIZING_MEASURES                 || GOTO :FAIL
call :extract datamart/mod-health-measures                  MOD_HEALTH_MEASURES                 || GOTO :FAIL
call :extract datamart/mod-sizing-evolution                 MOD_SIZING_EVOLUTION                || GOTO :FAIL
call :extract datamart/mod-health-evolution                 MOD_HEALTH_EVOLUTION                || GOTO :FAIL

rem Let's extract SRC*, USR* tables for AAD domain to cleanup the tables

:ED
call :extract datamart/src-objects                          SRC_OBJECTS                         || GOTO :FAIL
call :extract datamart/src-transactions                     SRC_TRANSACTIONS                    || GOTO :FAIL
call :extract datamart/src-mod-objects                      SRC_MOD_OBJECTS                     || GOTO :FAIL
call :extract datamart/src-trx-objects                      SRC_TRX_OBJECTS                     || GOTO :FAIL
call :extract datamart/src-health-impacts                   SRC_HEALTH_IMPACTS                  || GOTO :FAIL
call :extract datamart/src-violations                       SRC_VIOLATIONS                      || GOTO :FAIL
call :extract datamart/usr-exclusions                       USR_EXCLUSIONS                      || GOTO :FAIL
call :extract datamart/usr-action-plan                      USR_ACTION_PLAN                     || GOTO :FAIL
GOTO :SUCCESS

:FAIL
ECHO == Extract Failed ==
EXIT /b 1

:SUCCESS
ECHO == Extract Done ==
EXIT /b 0

:extract
ECHO.
ECHO ------------------------------
ECHO Extract %~2
ECHO ------------------------------
IF NOT DEFINED CREDENTIALS (
   curl --no-buffer -f -k -H "Accept: text/csv" --netrc-file %USERPROFILE%\_netrc "%ROOT%/%DOMAIN%/%~1" -o "%EXTRACT_FOLDER%\%DOMAIN%\%~2.csv" || EXIT /b 1
) ELSE (
   curl --no-buffer -f -k -H "Accept: text/csv" -u %CREDENTIALS% "%ROOT%/%DOMAIN%/%~1" -o "%EXTRACT_FOLDER%\%DOMAIN%\%~2.csv" || EXIT /b 1
)
GOTO :EOF
