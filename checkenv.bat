REM ------------------------------------------------------------------------------
REM ------
REM ------ DO NOT CHANGE ANYTHING BELOW THIS LINE 
REM ------
REM ------------------------------------------------------------------------------

SET INSTALLATION_FOLDER=%cd%
SET PGSQL=pgsql-10.12

REM Add path for embedded third party binaries
IF EXIST "%INSTALLATION_FOLDER%\thirdparty\curl-7.70\bin" SET PATH=%INSTALLATION_FOLDER%\thirdparty\curl-7.70\bin;%PATH%
IF EXIST "%INSTALLATION_FOLDER%\thirdparty\Python38-32" SET PATH=%INSTALLATION_FOLDER%\thirdparty\Python38-32;%PATH%

IF DEFINED PGSQL IF EXIST "%INSTALLATION_FOLDER%\thirdparty\%PGSQL%\bin" SET PATH=%INSTALLATION_FOLDER%\thirdparty\%PGSQL%\bin;%PATH%
IF DEFINED PGSQL IF EXIST "%INSTALLATION_FOLDER%\thirdparty\%PGSQL%\bin" SET PSQL=psql.exe
IF DEFINED PGSQL IF EXIST "%INSTALLATION_FOLDER%\thirdparty\%PGSQL%\bin" SET VACUUMDB=vacuumdb.exe

WHERE PYTHON > nul 2> nul || (echo Python is not found & EXIT /b /1)
WHERE CURL > nul 2> nul || (echo CURL is not found & EXIT /b /1)
WHERE PSQL > nul 2> nul || (call :EXIST PSQL "%PSQL%") || (echo PSQL is not found & EXIT /b /1)
WHERE VACUUMDB > nul 2> nul || (call :EXIST VACUUMDB "%VACUUMDB%") || (echo VACUUMDB is not found & EXIT /b /1)

python utilities\check_python_version.py || EXIT /b 1

IF NOT DEFINED DEFAULT_DOMAIN (echo Missing variable DEFAULT_DOMAIN & EXIT /b 1)
IF NOT DEFINED DEFAULT_ROOT (echo Missing variable DEFAULT_ROOT & EXIT /b 1)
IF NOT DEFINED _DB_HOST (echo Missing variable _DB_HOST & EXIT /b 1)
IF NOT DEFINED _DB_PORT (echo Missing variable _DB_PORT & EXIT /b 1)
IF NOT DEFINED _DB_NAME (echo Missing variable _DB_NAME & EXIT /b 1)
IF NOT DEFINED _DB_USER (echo Missing variable _DB_USER & EXIT /b 1)
IF NOT DEFINED _DB_SCHEMA (echo Missing variable _DB_SCHEMA & EXIT /b 1)

SET EXTRACT_FOLDER=%INSTALLATION_FOLDER%\extract
SET TRANSFORM_FOLDER=%INSTALLATION_FOLDER%\transform
SET VIEWS_FOLDER=%INSTALLATION_FOLDER%\views

IF NOT EXIST "%INSTALLATION_FOLDER%\log" MKDIR "%INSTALLATION_FOLDER%\log"
FOR /f %%D in ('python utilities\isodatetime.py') do set NOW=%%D
IF NOT DEFINED LOG_FILE SET LOG_FILE=%INSTALLATION_FOLDER%\log\ETL-%NOW%.log

SET PSQL_OPTIONS=-d %_DB_NAME% -h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT% --set=ON_ERROR_STOP=true
SET VACUUM_OPTIONS=-h %_DB_HOST% -U %_DB_USER% -p %_DB_PORT%

goto :EOF

:EXIST
    IF NOT DEFINED %~1 EXIT /b 1
    IF NOT EXIST %~2 EXIT /b 1
    EXIT /b 0