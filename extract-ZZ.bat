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
call python utilities\curl-Z.py %CURL% %CONN% text/csv ^
 "%ROOT%/%DOMAIN%/datamart/dim-snapshots"                        "%EXTRACT_FOLDER%/%DOMAIN%/DIM_SNAPSHOTS.csv"                    ^
 "%ROOT%/%DOMAIN%/datamart/dim-rules"                            "%EXTRACT_FOLDER%/%DOMAIN%/DIM_RULES.csv"                        ^
 "%ROOT%/%DOMAIN%/datamart/dim-omg-rules"                        "%EXTRACT_FOLDER%/%DOMAIN%/DIM_OMG_RULES.csv"                    ^
 "%ROOT%/%DOMAIN%/datamart/dim-cisq-rules"                       "%EXTRACT_FOLDER%/%DOMAIN%/DIM_CISQ_RULES.csv"                   ^
 "%ROOT%/%DOMAIN%/datamart/dim-applications"                     "%EXTRACT_FOLDER%/%DOMAIN%/DIM_APPLICATIONS.csv"                 ^
 "%ROOT%/%DOMAIN%/datamart/app-violations-measures"              "%EXTRACT_FOLDER%/%DOMAIN%/APP_VIOLATIONS_MEASURES.csv"          ^
 "%ROOT%/%DOMAIN%/datamart/app-sizing-measures"                  "%EXTRACT_FOLDER%/%DOMAIN%/APP_SIZING_MEASURES.csv"              ^
 "%ROOT%/%DOMAIN%/datamart/app-functional-sizing-measures"       "%EXTRACT_FOLDER%/%DOMAIN%/APP_FUNCTIONAL_SIZING_MEASURES.csv"   ^
 "%ROOT%/%DOMAIN%/datamart/app-health-scores"                    "%EXTRACT_FOLDER%/%DOMAIN%/APP_HEALTH_SCORES.csv"                ^
 "%ROOT%/%DOMAIN%/datamart/app-scores"                           "%EXTRACT_FOLDER%/%DOMAIN%/APP_SCORES.csv"                       ^
 "%ROOT%/%DOMAIN%/datamart/app-sizing-evolution"                 "%EXTRACT_FOLDER%/%DOMAIN%/APP_SIZING_EVOLUTION.csv"             ^
 "%ROOT%/%DOMAIN%/datamart/app-functional-sizing-evolution"      "%EXTRACT_FOLDER%/%DOMAIN%/APP_FUNCTIONAL_SIZING_EVOLUTION.csv"  ^
 "%ROOT%/%DOMAIN%/datamart/app-health-evolution"                 "%EXTRACT_FOLDER%/%DOMAIN%/APP_HEALTH_EVOLUTION.csv"             ^
 "%ROOT%/%DOMAIN%/datamart/mod-violations-measures"              "%EXTRACT_FOLDER%/%DOMAIN%/MOD_VIOLATIONS_MEASURES .csv"         ^
 "%ROOT%/%DOMAIN%/datamart/mod-sizing-measures"                  "%EXTRACT_FOLDER%/%DOMAIN%/MOD_SIZING_MEASURES.csv"              ^
 "%ROOT%/%DOMAIN%/datamart/mod-health-scores"                    "%EXTRACT_FOLDER%/%DOMAIN%/MOD_HEALTH_SCORES.csv"                ^
 "%ROOT%/%DOMAIN%/datamart/mod-scores"                           "%EXTRACT_FOLDER%/%DOMAIN%/MOD_SCORES.csv"                       ^
 "%ROOT%/%DOMAIN%/datamart/mod-sizing-evolution"                 "%EXTRACT_FOLDER%/%DOMAIN%/MOD_SIZING_EVOLUTION.csv"             ^
 "%ROOT%/%DOMAIN%/datamart/mod-health-evolution"                 "%EXTRACT_FOLDER%/%DOMAIN%/MOD_HEALTH_EVOLUTION.csv"             ^
 "%ROOT%/%DOMAIN%/datamart/std-rules"                            "%EXTRACT_FOLDER%/%DOMAIN%/STD_RULES.csv"                        ^
 "%ROOT%/%DOMAIN%/datamart/std-descriptions"                     "%EXTRACT_FOLDER%/%DOMAIN%/STD_DESCRIPTIONS.csv"                 ^
 || EXIT /b 1
 
goto :EOF

:EXTRACT_DETAILS
call python utilities\curl-Z.py %CURL%  %CONN% text/csv ^
 "%ROOT%/%DOMAIN%/datamart/src-objects"                          "%EXTRACT_FOLDER%/%DOMAIN%/SRC_OBJECTS.csv"                      ^
 "%ROOT%/%DOMAIN%/datamart/src-transactions"                     "%EXTRACT_FOLDER%/%DOMAIN%/SRC_TRANSACTIONS.csv"                 ^
 "%ROOT%/%DOMAIN%/datamart/src-mod-objects"                      "%EXTRACT_FOLDER%/%DOMAIN%/SRC_MOD_OBJECTS.csv"                  ^
 "%ROOT%/%DOMAIN%/datamart/src-trx-objects"                      "%EXTRACT_FOLDER%/%DOMAIN%/SRC_TRX_OBJECTS.csv"                  ^
 "%ROOT%/%DOMAIN%/datamart/src-health-impacts"                   "%EXTRACT_FOLDER%/%DOMAIN%/SRC_HEALTH_IMPACTS.csv"               ^
 "%ROOT%/%DOMAIN%/datamart/src-trx-health-impacts"               "%EXTRACT_FOLDER%/%DOMAIN%/SRC_TRX_HEALTH_IMPACTS.csv"           ^
 "%ROOT%/%DOMAIN%/datamart/src-violations"                       "%EXTRACT_FOLDER%/%DOMAIN%/SRC_VIOLATIONS.csv"                   ^
 "%ROOT%/%DOMAIN%/datamart/usr-exclusions"                       "%EXTRACT_FOLDER%/%DOMAIN%/USR_EXCLUSIONS.csv"                   ^
 "%ROOT%/%DOMAIN%/datamart/usr-action-plan"                      "%EXTRACT_FOLDER%/%DOMAIN%/USR_ACTION_PLAN.csv"                  ^
 || EXIT /b 1

GOTO :EOF

:FAIL
ECHO == Extract Failed ==
DEL cookies.txt >nul 2>&1
EXIT /b 1

:SUCCESS
ECHO == Extract Done ==
DEL cookies.txt >nul 2>&1
EXIT /b 0

GOTO :EOF
