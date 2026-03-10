import sys
import os
import subprocess

from CONFIG import DATAMART

def usage():
    print("This command should be called from the run.sh|run.bat command or datamart.sh|datamart.bat command")
    print("Usage is\n")
    print("Single Data Source")
    print("extract refresh|install")
    print("extract refresh|install ROOT DOMAIN")
    print("    To make a full extraction for a refresh or an install")
    print("    if ROOT and DOMAIN are not set then the DEFAULT_DOMAIN and DEFAULT_ROOT are applied\n")
    print("Multiple Data Source")
    print("extract install HD_ROOT AAD")
    print("    To make a full extraction of all tables")
    print("extract refresh HD_ROOT AAD")
    print("    To make a full extraction of all tables")
    print("extract ed-install|ed-update ED_ROOT ED_DOMAIN")
    print("    To make a partial extraction of ED tables")
    print("extract hd-update HD_ROOT AAD")
    print("    To make a partial extraction of HD tables")
    sys.exit(1)


def fail():
    print("== Extract Failed ==")
    try:
        os.remove("cookies.txt")
    except FileNotFoundError:
        pass
    sys.exit(1)


def success():
    print("== Extract Done ==")
    try:
        os.remove("cookies.txt")
    except FileNotFoundError:
        pass
    sys.exit(0)


def extract(uri, table):

    root = os.environ["ROOT"]
    domain = os.environ["DOMAIN"]
    extract_snapshots_months = os.getenv("EXTRACT_SNAPSHOTS_MONTHS", None)
    extract_zero_weight = os.environ["EXTRACT_ZERO_WEIGHT"]
    extract_folder = os.environ["EXTRACT_FOLDER"]
    extract_url = f"{root}/{domain}/{uri}?a=1"
    output = f"{extract_folder}/{domain}/{table}.csv"
    
    print()
    print("------------------------------")
    print(f"Extract {output}")
    print("------------------------------")

    if extract_snapshots_months:
        extract_url += f"&snapshots-months={extract_snapshots_months}"
    if extract_zero_weight == 'ON':
        extract_url += "&extract-zero-weight=on"

    cmd = ["python", "utilities/curl.py", "text/csv", extract_url, "-o", output]
    print(str(cmd))
    """
    result = subprocess.run(cmd)
    if result.returncode != 0:
        fail()
    """

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
        if action in ("refresh", "install"):
            for entry in DATAMART:
                if not check_env(entry):
                    continue
                extract(entry['uri'], entry['table'])
            success()

        elif action in ("ed-install", "ed-update"):
            for entry in DATAMART:
                if entry['origin'] != "ed":
                    continue
                if not check_env(entry):
                    continue
                extract(entry['uri'], entry['table'])
            success()

        elif action == "hd-update":
            for entry in DATAMART:
                if entry['origin'] != "hd":
                    continue
                if not check_env(entry):
                    continue
                extract(entry['uri'], entry['table'])

        else:
            usage()

    except Exception as e:
        print(e)
        fail()


if __name__ == "__main__":
    main()

