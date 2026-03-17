import sys
import os
import subprocess
from datetime import datetime
from utilities.decode import decode
from utilities.build_data_dictionary import build_sql

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

def run_with_timestamp(argv, env):
    process = subprocess.Popen(
        argv,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1
    )
    log_file = env["LOG_FILE"]
    with open(log_file, "a") as w:
        for line in iter(process.stdout.readline, ''):
            w.write(f"{timestamp()} {line}")
            w.flush()

    process.stdout.close()
    process.wait()
    return process.returncode

def run(argv, log_file):
    pgpassword = os.getenv("PGPASSWORD")

    environment = os.environ.copy()
    environment["LOG_FILE"] = log_file
    if pgpassword:
        environment["PGPASSWORD"] = decode(pgpassword)
    exit_code = run_with_timestamp(argv, env=environment)
   
    if exit_code != 0:
        fail()

def load_table(table):
    sql = os.path.join(os.environ["TRANSFORM_FOLDER"], os.environ["DOMAIN"], table + ".sql")
    print("Load " + sql)
    options = os.environ["PSQL_OPTIONS"].split()
    run([os.environ["PSQL"], *options, "--set=schema=" + os.environ["_DB_SCHEMA"], "-f", sql], os.environ['LOG_FILE'])
    options = os.environ["VACUUM_OPTIONS"].split()
    run([os.environ["VACUUMDB"], "-z", *options, "-t", os.environ["_DB_SCHEMA"] + "." + table, os.environ["_DB_NAME"]], os.environ["LOG_FILE"])

def load_view(view):
    sql = os.path.join(os.environ["VIEWS_FOLDER"], view + ".sql")
    options = os.environ["PSQL_OPTIONS"].split()
    print("Load " + sql)
    run([os.environ["PSQL"], *options, "--set=schema=" + os.environ["_DB_SCHEMA"], "-f",  sql], os.environ["LOG_FILE"])

def load_data_dictionary():
    options = os.environ["PSQL_OPTIONS"].split()
    log_file = os.path.join (os.environ["LOG_FOLDER"], "build_data_dictionary.log")
    sql = os.path.join(os.environ["INSTALLATION_FOLDER"], "build_data_dictionary.sql")
    build_sql(sql)
    print(f"Load {sql}")
    run([os.environ["PSQL"], *options, "--set=schema=" + os.environ["_DB_SCHEMA"], "-f", sql], os.environ["LOG_FILE"])


def install(scope) :
    options = os.environ["PSQL_OPTIONS"].split()
    print(f"Create schema '{os.environ['_DB_SCHEMA']}' if not exists")
    run([os.environ["PSQL"], *options, "-c", f"CREATE SCHEMA IF NOT EXISTS {os.environ['_DB_SCHEMA']};"], os.environ["LOG_FILE"])
    
    if scope == "hd":
        print("Create and Load DIM_APPLICATIONS")
        load_table("DIM_APPLICATIONS")
        if os.environ.get('EXTRACT_DATAPOND') == "ON":
            load_table("DATAPOND_ORGANIZATION")
    
    print("Create other tables")
    
    sql = os.path.join(os.environ["INSTALLATION_FOLDER"], "create_tables.sql")
    run([os.environ["PSQL"], *options, "--set=schema=" + os.environ["_DB_SCHEMA"], "-f", sql], os.environ['LOG_FILE'])
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

