import subprocess
import os
import sys
import csv
import subprocess
import os
  
def install(domains_file, jobs):

    output_path = os.getenv("INSTALLATION_FOLDER") + "/log/" + "AAD.stdout"
    cmd = ['run.bat', 'install', os.getenv("HD_ROOT"), 'AAD']
    print (" ".join(cmd))
    with open(output_path, "w") as output:
        return_code = subprocess.run(['run.bat', 'install', os.getenv("HD_ROOT"), 'AAD'], stdout=output, stderr=output).returncode
        print ("Data transfer for domain AAD" + (": Done" if (return_code == 0) else ": Aborted"))
        if return_code != 0:
            sys.exit(1)

    domains = []
    # Loop on  domains of DOMAINS.TXT        
    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        pos = 0
        for csv_row in csv_reader:
            for domain in csv_row:
                if pos % jobs == 0:
                    group = []
                    domains.append(group)
                pos += 1
                group.append(domain)     
    for group in domains:
        processes = []
        for domain in group:
            domain = domain.strip()
            output_path = os.getenv("INSTALLATION_FOLDER") + "/log/" + domain + ".stdout"
            cmd = ['run.bat', 'append_details', os.getenv("ED_ROOT"), domain]
            print (" ".join(cmd))
            with open(output_path, "w") as output:
                p = subprocess.Popen(cmd, stdout=output, stderr=output)
                processes.append((domain,p))
        exit_code = 0
        for domain, p in processes:
            return_code = p.wait()
            print ("Data transfer for domain " + domain + (": Done" if (return_code == 0) else ": Aborted"))
            if return_code != 0:
                if exit_code == 0:
                    exit_code = 1
    sys.exit(exit_code)
           
    
def refresh(domains_file, jobs):
    #exit_code = subprocess.run(['run.bat', 'refresh', os.getenv("HD_ROOT"), 'AAD']).returncode
    #if exit_code != 0:
    #    sys.exit(exit_code)
    # Loop on  domains of DOMAINS.TXT        
    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                exit_code = subprocess.run(['run.bat', 'append_details', os.getenv("ED_ROOT"), domain.strip()]).returncode
                if exit_code != 0:
                    sys.exit(exit_code)
    sys.exit(0)

def update(domains_file):    
    exit_code = subprocess.run(['utilities\check_new_snapshot.bat', os.getenv("HD_ROOT") + '/AAD']).returncode
    if exit_code == 0:
        print("Datamart is already synchronized. No new snapshot")
        sys.exit(0)

    exit_code = subprocess.run(['run.bat', 'refresh_measures', os.getenv("ED_ROOT"), 'AAD']).returncode
    if exit_code != 0:
        sys.exit(exit_code)

    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                exit_code = subprocess.run(['utilities\check_new_snapshot.bat', os.getenv("HD_ROOT") + '/' + domain.strip()]).returncode
                if exit_code == 1:
                    exit_code = subprocess.run(['run.bat', 'replace_details', os.getenv("ED_ROOT"), domain.strip()]).returncode
                    if exit_code != 0:
                        sys.exit(exit_code)
    sys.exit(0)

if __name__ == '__main__':
    try:
        action = sys.argv[1];
        if action == 'INSTALL':
            install (sys.argv[2], int(sys.argv[3]))
        elif action == 'REFRESH':
            refresh (sys.argv[2], int(sys.argv[3]))
        elif action == 'UPDATE':
            update (sys.argv[2])
        else:    
            print("Internal error - unknown arg: " + sys.argv[1])
            sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(1)