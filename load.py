import sys
import os
import subprocess

from CONFIG import DATAMART

"""
TODO: REMOVE utilities/run.bat
TODO: REMOVE load_dictionary.bat
TODO: TRANSFET create_dataponf_views.bat
toDO: ??? statements
"""

def usage():
    print("This script should be executed from run.sh, datamart.sh (Linux/Docker) or run.bat, datamart.bat (Windows)")
    print("This command should be called from the run.bat command or datamart.bat")
    print("Usage is")
    print("")
    print("Single Data Source")
    print("load {refresh|install}")
    print("load {refresh|install} DOMAIN")
    print("    To load CSV data for an install or refresh")
    print("    if the 'DOMAIN' argument is not set then the DEFAULT_DOMAIN is applied")
    print("")
    print("Multiple Data Source")
    print("load {install|refresh|hd-update} HD_ROOT AAD")
    print("    To load CSV health data")
    print("load {ed-install|ed-update} ED_ROOT DOMAIN")
    print("    To load CSV engineering date")
    sys.exit(1)


def fail():
    print(f"== Load Failed (see {os.environ['LOG_FILE']} file ==")
    sys.exit(1)

def success():
    print(f"Load Done: schema '{os.environ['_DB_SCHEMA']}', database '{os.environ['_DB_NAME']}, host '{os.environ['_DB_HOST']}' ==")
    sys.exit(0)

def timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def run_with_timestamp(argv, env=None):
    process = subprocess.Popen(
        argv,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        env=env,
        bufsize=1
    )

    for line in process.stdout:
        sys.stdout.write(f"{timestamp()} {line}")
        sys.stdout.flush()

    process.wait()
    return process.returncode

def run(argv, log_file):
    pgpassword = os.getenv("PGPASSWORD")

    environment = os.environ.copy()
    environment["LOG_FILE"] = log_file
        
    if pgpassword:
        environment["PGPASSWORD"] = decode.decode(pgpassword)

    exit_code = run_with_timestamp(argv, env=environment)

    if exit_code != 0:
        fail()

def load_table(table):
    ???IF NOT EXIST "%TRANSFORM_FOLDER%\%DOMAIN%\%~1.sql" GOTO :EOF
    sql = os.path.(os.environ["TRANSFORM_FOLDER"], os.environ["DOMAIN"] + ".sql")
    print("Load " + sql)
    run([os.environ["PSQL"], os.environ["PSQL_OPTIONS"], "--set=schema=" + os.environ["_DB_SCHEMA"], "-f", os.environ["TRANSFORM_FOLDER"], sql], os.environ['LOG_FILE'])
    run([os.environ["VACUUMDB"], "-z", os.environ["VACUUM_OPTIONS"], "-t", os.environ["_DB_SCHEMA"] + "." + table, os.environ["_DB_NAME"], os.environ["LOG_FILE"])

def load_view(view):
    sql = os.path.join(os.environ("VIEWS_FOLDER"), view + ".sql")
    print("Load " + sql)
    run([os.environ("PSQL"), os.environ["PSQL_OPTIONS"], "--set=schema=" + os.environ["_DB_SCHEMA"], "-f",  sql], os.environ["LOG_FILE"])

def load_data_dictionary():
    log_file = os.path.join (os.environ["LOG_FOLDER"], "build_data_dictionary.log")
    sql = os.path.join(os.environ["INSTALLATION_FOLDER"], "build_data_dictionary.sql")

    ???python utilities\build_data_dictionary.py sql > build_data_dictionary.sql || GOTO :FAIL
    ???ECHO Load %INSTALLATION_FOLDER%\build_data_dictionary.sql
    ???CALL :run build_data_dictionary || GOTO :FAIL
    ???python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f "%~1.sql" >> "%LOG_FILE%" 2>&1 || EXIT /b 1


def install(scope) :
    print(f"Create schema '{os.environ('_DB_SCHEMA')}' if not exists")
    run([os.environ["PSQL"], os.environ["PSQL_OPTIONS"], "-c", f"CREATE SCHEMA IF NOT EXISTS {os.environ["_DB_SCHEMA"]};"], os.environ["LOG_FILE"])
    print("Create and Load DIM_APPLICATIONS")
    load_table("DIM_APPLICATIONS")
    load_table("DATAPOND_ORGANIZATION")
    print("Create other tables")
    run([os.environ["PSQL"], os.environ["PSQL_OPTIONS"], "--set=schema=" + os.environ["_DB_SCHEMA"], "-f", "create_table.sql"], os.environ('LOG_FILE')])
    load_data_dictionary()
    # SET FOREIGN KEY FOR TEST OR A SINGLE DATA SOURCE
    # REM python utilities\run.py "%PSQL%" %PSQL_OPTIONS% --set=schema=%_DB_SCHEMA% -f add_foreign_keys.sql >> "%LOG_FILE%" 2>&1 || EXIT /b 1
    for entry in DATAMART:
        if not check_env(entry):
            continue
        table = entry['table']
        if table == "DIM_APPLICATIONS":
            continue
        if scope == "default" or (entry["origin"] == scope):
            load_table(table)
    
    if scope in ["hd", "default"]:
        load_view("DIM_QUALITY_STANDARDS")

def refresh(scope):
    for entry in DATAMART:
        if not check_env(entry):
            continue
        table = entry['table']
        if scope == "default" or (entry["origin"] == scope):
            load_table(table)    

    if scope in ["hd", "default"]:
        load_view("DIM_QUALITY_STANDARDS")

def check_env(entry):
    if not entry['env']:
        return True
    for var,val in entry['env'].items():
        if os.environ[var] != val:
            return False
    return True
    
def main():
    if len(sys.argv) < 2:
        usage()

    action = sys.argv[1]
    root = sys.argv[2]
    domain = sys.argv[3]

    try:
        if action == "install":
            install("default")
        elif action == "refresh":
            refresh("default")
        elif action == "ed-install":
            install("ed")
        elif action == "ed-update":
            refresh("ed")
        elif action == "hd-update":
            refresh("hd")
        else:
            usage()
       success()

    except Exception as e:
        print(e)
        fail()

if __name__ == "__main__":
    main()

