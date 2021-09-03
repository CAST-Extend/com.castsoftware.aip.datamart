REM ------------------------------------------------------------------------------
REM ------
REM ------ CONFIGURE THE FOLLOWING SETTINGS
REM ------
REM ------------------------------------------------------------------------------

REM ------
REM REST API 
REM ------

REM SET REST API CREDENTIALS or APIKEY
SET CREDENTIALS=

REM IN CASE OF A SINGLE DOMAIN EXTRACTION (RUN.BAT)
REM SUPPLY THE URL AND DOMAIN 
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
SET DEFAULT_ROOT=http://localhost:9090/rest
SET DEFAULT_DOMAIN=AAD

REM IN CASE OF A MULTIPLE DOMMAINS EXTRACTION (DATAMART.BAT), 
REM SUPPLY THE REST API URL FOR HD (HEALTH DASHBOARD)
REM AND THE REST API URL FOR ED (ENGINEERING DASHBOARD)
REM FOR ED YOU CAN SUPPLY UP TO 10 URLs (from ED_ROOT[0] to ED_ROOT[9])
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
SET HD_ROOT=http://localhost:8080/rest
SET ED_ROOT[0]=http://localhost:8080/rest
SET ED_ROOT[1]=

REM Number of concurrent processes
SET JOBS=1

REM ------
REM EXTRACTION SCOPE
REM ------

REM IN CASE OF A DATAPOND COMPLIANT EXTRACTION SET THE FOLLOWING VARIABLES
REM set EXTRACT_DATAPOND=ON
REM set EXTRACT_MOD=OFF
REM set EXTRACT_TECHNO=OFF
REM set EXTRACT_SRC=OFF
REM set EXTRACT_USR=ON

REM ------
REM TARGET DATABASE
REM ------

SET _DB_HOST=localhost
SET _DB_PORT=2282
SET _DB_NAME=reporting
SET _DB_USER=
SET _DB_SCHEMA=datamart
SET PGPASSWORD=
