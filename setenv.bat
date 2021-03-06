REM ------------------------------------------------------------------------------
REM ------
REM ------ CONFIGURE THE FOLLOWING SETTINGS
REM ------
REM ------------------------------------------------------------------------------

REM IF YOU DO NOT USE THE EMBEDDED THIRD PARTY BINARIES 
REM SET THE POSTGRESQL COMMAND LINE PATHS, DO NOT SET DOUBLE-QUOTES
SET PSQL=
SET VACUUMDB=

REM SET REST API CREDENTIALS or APIKEY
SET CREDENTIALS=

REM IN CASE OF A SINGLE DOMAIN EXTRACTION (RUN.BAT)
REM SUPPLY THE URL AND DOMAIN 
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
SET DEFAULT_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET DEFAULT_DOMAIN=AAD

REM IN CASE OF A MULTIPLE DOMMAINS EXTRACTION (DATAMART.BAT), 
REM SUPPLY THE REST API URL FOR HD (HEALTH DASHBOARD)
REM AND THE REST API URL FOR ED (ENGINEERING DASHBOARD)
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
SET HD_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET ED_ROOT=http://localhost:9090/CAST-RESTAPI/rest
REM Number of concurrent processes
SET JOBS=1

REM SET TARGET DATABASE
SET _DB_HOST=localhost
SET _DB_PORT=2282
SET _DB_NAME=reporting
SET _DB_USER=
SET _DB_SCHEMA=datamart
SET PGPASSWORD=
