REM ------------------------------------------------------------------------------
REM ------
REM ------ CONFIGURE THE FOLLOWING SETTINGS
REM ------
REM ------------------------------------------------------------------------------

REM SET THE POSTGRESQL PATHS IF YOU DO NOT USE THE EMBEDDED THIRDPARTY FOLDER
REM DO NOT SET DOUBLE-QUOTES
SET PSQL=psql.exe
SET VACUUMDB=vacuumdb.exe
 
REM IN CASE OF A SINGLE DOMAIN EXTRACTION, YOU CAN SUPPLY A DEFAULT URL AND DOMAIN FOR THE RUN.BAT COMMAND
REM THE DATAMART.BAT COMMAND IGNORES THESE DEFAULT SETTINGS
REM MAKE SURE TO NOT INCLUDE "/" AT THE END OF URL
REM EXAMPLE: 
SET DEFAULT_ROOT=http://localhost:9090/CAST-RESTAPI/rest
SET DEFAULT_DOMAIN=AAD
SET CREDENTIALS=

REM SET TARGET DATABASE
SET _DB_HOST=localhost
SET _DB_PORT=2282
SET _DB_NAME=reporting
SET _DB_USER=
SET _DB_SCHEMA=datamart
SET PGPASSWORD=
