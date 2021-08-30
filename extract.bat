@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL
CALL checkenv.bat || GOTO :FAIL

if [%2] == [] if not [%3] == [] goto :USAGE

set ROOT=%2
set DOMAIN=%3
if [%ROOT%] == [] set ROOT=%DEFAULT_ROOT%
if [%DOMAIN%] == [] set DOMAIN=%DEFAULT_DOMAIN%

IF NOT EXIST "%EXTRACT_FOLDER%\%DOMAIN%" MKDIR "%EXTRACT_FOLDER%\%DOMAIN%"
del /F /Q /A "%EXTRACT_FOLDER%\%DOMAIN%"

if [%1] == [append_details] if [%DOMAIN%] == [AAD] goto :USAGE

if [%1] == [refresh]          (call :EXTRACT_ALL      && GOTO :SUCCESS)
if [%1] == [refresh_measures] (call :EXTRACT_MEASURES && GOTO :SUCCESS)
if [%1] == [install]          (call :EXTRACT_ALL      && GOTO :SUCCESS)
if [%1] == [append_details]   (call :EXTRACT_DETAILS  && GOTO :SUCCESS)
if [%1] == [replace_details]  (call :EXTRACT_DETAILS  && GOTO :SUCCESS)

if [%ERRORLEVEL%] == [1] GOTO :FAIL

:USAGE
echo This command should be called from the run.bat command
echo Usage is
echo extract refresh^|install
echo extract refresh^|install ROOT DOMAIN
echo     To make a full extraction for a refresh or an install
echo     if ROOT and DOMAIN are not set then the DEFAULT_DOMAIN and DEFAULT_ROOT are applied
echo extract append_details ROOT DOMAIN
echo     To make a partial extraction in order to append engineering data
echo extract replace_details ROOT DOMAIN
echo     To make a partial extraction in order to replace engineering data
echo extract refresh_measures ROOT DOMAIN
echo     To make a partial extraction in order to refresh measures data
goto :FAIL


:EXTRACT_ALL
call :EXTRACT_MEASURES || EXIT /b 1
call :EXTRACT_DETAILS  || EXIT /b 1
goto :EOF

:EXTRACT_MEASURES
call :extract datamart/dim-snapshots                        DIM_SNAPSHOTS                       || EXIT /b 1
call :extract datamart/dim-rules                            DIM_RULES                           || EXIT /b 1
call :extract datamart/dim-omg-rules                        DIM_OMG_RULES                       || EXIT /b 1
call :extract datamart/dim-cisq-rules                       DIM_CISQ_RULES                      || EXIT /b 1
call :extract datamart/dim-applications                     DIM_APPLICATIONS                    || EXIT /b 1
call :extract datamart/app-violations-measures              APP_VIOLATIONS_MEASURES             || EXIT /b 1
call :extract datamart/app-violations-evolution             APP_VIOLATIONS_EVOLUTION            || EXIT /b 1
call :extract datamart/app-sizing-measures                  APP_SIZING_MEASURES                 || EXIT /b 1
call :extract datamart/app-functional-sizing-measures       APP_FUNCTIONAL_SIZING_MEASURES      || EXIT /b 1
call :extract datamart/app-health-scores                    APP_HEALTH_SCORES                   || EXIT /b 1
call :extract datamart/app-scores                           APP_SCORES                          || EXIT /b 1
call :extract datamart/app-sizing-evolution                 APP_SIZING_EVOLUTION                || EXIT /b 1
call :extract datamart/app-functional-sizing-evolution      APP_FUNCTIONAL_SIZING_EVOLUTION     || EXIT /b 1
call :extract datamart/app-health-evolution                 APP_HEALTH_EVOLUTION                || EXIT /b 1
call :extract datamart/std-rules                            STD_RULES                           || EXIT /b 1
call :extract datamart/std-descriptions                     STD_DESCRIPTIONS                    || EXIT /b 1
if [%EXTRACT_TECHNO%] == [ON] CALL :EXTRACT_APP_TECHNO  || EXIT /b 1
if [%EXTRACT_MOD%] == [ON] CALL :EXTRACT_MOD  || EXIT /b 1
GOTO :EOF

:EXTRACT_APP_TECHNO:
call :extract datamart/app-techno-sizing-measures           APP_TECHNO_SIZING_MEASURES          || EXIT /b 1
call :extract datamart/app-techno-scores                    APP_TECHNO_SCORES                   || EXIT /b 1
call :extract datamart/app-techno-sizing-evolution          APP_TECHNO_SIZING_EVOLUTION         || EXIT /b 1
GOTO :EOF

:EXTRACT_MOD
call :extract datamart/mod-violations-measures              MOD_VIOLATIONS_MEASURES             || EXIT /b 1
call :extract datamart/mod-violations-evolution             MOD_VIOLATIONS_EVOLUTION            || EXIT /b 1
call :extract datamart/mod-sizing-measures                  MOD_SIZING_MEASURES                 || EXIT /b 1
call :extract datamart/mod-health-scores                    MOD_HEALTH_SCORES                   || EXIT /b 1
call :extract datamart/mod-scores                           MOD_SCORES                          || EXIT /b 1
call :extract datamart/mod-sizing-evolution                 MOD_SIZING_EVOLUTION                || EXIT /b 1
call :extract datamart/mod-health-evolution                 MOD_HEALTH_EVOLUTION                || EXIT /b 1
if [%EXTRACT_TECHNO%] == [ON] CALL :EXTRACT_MOD_TECHNO  || EXIT /b 1

GOTO :EOF

:EXTRACT_MOD_TECHNO:
call :extract datamart/mod-techno-sizing-measures           MOD_TECHNO_SIZING_MEASURES          || EXIT /b 1
call :extract datamart/mod-techno-scores                    MOD_TECHNO_SCORES                   || EXIT /b 1
call :extract datamart/mod-techno-sizing-evolution          MOD_TECHNO_SIZING_EVOLUTION         || EXIT /b 1
GOTO :EOF


:EXTRACT_DETAILS
call :extract datamart/app-findings-measures                APP_FINDINGS_MEASURES               || EXIT /b 1
if [%EXTRACT_USR%] == [ON] CALL :EXTRACT_USR  || EXIT /b 1
if [%EXTRACT_SRC%] == [ON] CALL :EXTRACT_SRC  || EXIT /b 1
GOTO :EOF

:EXTRACT_USR
call :extract datamart/usr-exclusions                       USR_EXCLUSIONS                      || EXIT /b 1
call :extract datamart/usr-action-plan                      USR_ACTION_PLAN                     || EXIT /b 1
GOTO :EOF

:EXTRACT_SRC
call :extract datamart/src-objects                          SRC_OBJECTS                         || EXIT /b 1
call :extract datamart/src-transactions                     SRC_TRANSACTIONS                    || EXIT /b 1
call :extract datamart/src-trx-objects                      SRC_TRX_OBJECTS                     || EXIT /b 1
call :extract datamart/src-health-impacts                   SRC_HEALTH_IMPACTS                  || EXIT /b 1
call :extract datamart/src-trx-health-impacts               SRC_TRX_HEALTH_IMPACTS              || EXIT /b 1
call :extract datamart/src-violations                       SRC_VIOLATIONS                      || EXIT /b 1
if [%EXTRACT_MOD%] == [ON] CALL :EXTRACT_SRC_MOD  || EXIT /b 1
GOTO :EOF

:EXTRACT_SRC_MOD
call :extract datamart/src-mod-objects                      SRC_MOD_OBJECTS                     || EXIT /b 1
GOTO :EOF

:FAIL
ECHO == Extract Failed ==
DEL cookies.txt >nul 2>&1
EXIT /b 1

:SUCCESS
ECHO == Extract Done ==
DEL cookies.txt >nul 2>&1
EXIT /b 0

:extract
ECHO.
ECHO ------------------------------
ECHO Extract %EXTRACT_FOLDER%\%DOMAIN%\%~2.csv
ECHO ------------------------------
python utilities\curl.py text/csv "%ROOT%/%DOMAIN%/%~1" -o "%EXTRACT_FOLDER%\%DOMAIN%\%~2.csv"
GOTO :EOF
