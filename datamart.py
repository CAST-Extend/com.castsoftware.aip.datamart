import subprocess
import os
import sys
import csv
    
def install(domains_file):
    exit_code = subprocess.run(['run.bat', 'install', os.getenv("HD_ROOT"), 'AAD']).returncode
    if exit_code != 0:
        sys.exit(exit_code)
    # Loop on  domains of DOMAINS.TXT        
    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                exit_code = subprocess.run(['run.bat', 'append_details', os.getenv("HD_ROOT"), domain.strip()]).returncode
                if exit_code != 0:
                    sys.exit(exit_code)
    sys.exit(0)
    
def refresh(domains_file):
    exit_code = subprocess.run(['run.bat', 'refresh', os.getenv("HD_ROOT"), 'AAD']).returncode
    if exit_code != 0:
        sys.exit(exit_code)
    # Loop on  domains of DOMAINS.TXT        
    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                exit_code = subprocess.run(['run.bat', 'append_details', os.getenv("HD_ROOT"), domain.strip()]).returncode
                if exit_code != 0:
                    sys.exit(exit_code)
    sys.exit(0)

def update(domains_file):    
    exit_code = subprocess.run(['utilities\check_new_snapshot.bat', os.getenv("HD_ROOT") + '/AAD']).returncode
    if exit_code == 0:
        print("Datamart is already synchronized. No new snapshot")
        sys.exit(0)

    exit_code = subprocess.run(['run.bat', 'refresh_measures', os.getenv("HD_ROOT"), 'AAD']).returncode
    if exit_code != 0:
        sys.exit(exit_code)

    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                exit_code = subprocess.run(['utilities\check_new_snapshot.bat', os.getenv("HD_ROOT") + '/' + domain.strip()]).returncode
                if exit_code == 1:
                    exit_code = subprocess.run(['run.bat', 'replace_details', os.getenv("HD_ROOT"), domain.strip()]).returncode
                    if exit_code != 0:
                        sys.exit(exit_code)
    sys.exit(0)

if __name__ == '__main__':
    try:
        action = sys.argv[1];
        if action == 'INSTALL':
            install (sys.argv[2])
        elif action == 'REFRESH':
            refresh (sys.argv[2])
        elif action == 'UPDATE':
            update (sys.argv[2])
        else:    
            print("Internal error - unknown arg: " + sys.argv[1])
            sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(1)