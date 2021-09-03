import subprocess
import os
import sys
import csv
import time
  
# Once AAD domain is transferted, start run.bat to append details for a domain  
# Create a job as a pair: (domain, process) 
def start_domain_transfer(ed_url, domain, jobs, pos, transform_mode):
    output_path = os.getenv("INSTALLATION_FOLDER") + "/log/" + domain + ".stdout"
    cmd = ['run.bat', transform_mode, ed_url, domain]
    with open(output_path, "w") as output:
        process = subprocess.Popen(cmd, stdout=output, stderr=output)
        jobs[pos] = (domain, process)

# Start AAD transfer, abort all transfers in case of failure
def start_aad_transfer(transfer_mode):
    output_path = os.getenv("INSTALLATION_FOLDER") + "/log/" + "AAD.stdout"
    cmd = ['run.bat', transfer_mode, os.getenv("HD_ROOT"), 'AAD']
    with open(output_path, "w") as output:
        process = subprocess.Popen(cmd, stdout=output, stderr=output)
        return_code = process.wait()
    print ("Data transfer " + ("done" if (return_code == 0) else "ABORTED") + " for domain AAD")
    if return_code != 0:
        sys.exit(1)
  
def transfer(ed_url, domains_file, total_jobs, aad_transfer_mode):
    print ("Data transfer of Health Dashboard domain (AAD) in progress...")
    start_aad_transfer(aad_transfer_mode)
    print ("Data transfer of Engineering Dashboard domains in progress...")
    domains = []
    # Loop on  domains of DOMAINS.TXT        
    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                domains.append(domain.strip())     

    # Initialize the first pool of jobs
    total = len(domains)
    nb = min(total_jobs,total)
    jobs = [None]*nb
    for pos in range(nb):
        start_domain_transfer(ed_url, domains[pos], jobs, pos, "append_details")

    # Run a pool of concurrent jobs
    # Each time a job is ended, we start a new one
    exit_code = 0
    remaining_jobs = nb
    progress = 0
    while remaining_jobs > 0:
        current_jobs = jobs.copy() # avoid list modification during iteration
        for pos, job in enumerate(current_jobs):
            if job is None:
                continue
            (domain, process) = job
            return_code = process.poll()
            if return_code is not None:
                progress += 1
                print ("Data transfer (" + str(progress) + "/" + str(total) + ") " + ("done" if (return_code == 0) else "ABORTED") + " for domain " + domain)
                if return_code != 0:
                    if exit_code == 0:
                        exit_code = 1
                if nb < total:
                    start_domain_transfer(ed_url, domains[nb], jobs, pos, "append_details")
                    nb += 1
                    # leave remaining_jobs unchanged
                else:
                    jobs[pos] = None
                    remaining_jobs -= 1
        time.sleep(2) # awaits 2 seconds between each iteration
        
    sys.exit(exit_code)
          
# Update domains  when a new snapshot has been added. A single process is used here.
def update(domains_file, ed_url):    
    check_code = subprocess.run(['utilities\check_new_snapshot.bat', os.getenv("HD_ROOT") + '/AAD/datamart/dim-snapshots']).returncode
    if check_code == 0:
        print("Datamart is already synchronized. No new snapshot")
        sys.exit(0)

    exit_code = 0
    with open(domains_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')  
        for csv_row in csv_reader:
            for domain in csv_row:
                domain = domain.strip()
                check_code = subprocess.run(['utilities\check_new_snapshot.bat', ed_url + '/' + domain + '/datamart/dim-snapshots']).returncode
                if check_code != 0: 
                    jobs = [None]
                    start_domain_transfer(domain, jobs, 0, "replace_details")
                    return_code = jobs[0][1].wait()
                    print ("Data transfer " + ("done" if (return_code == 0) else "ABORTED") + " for domain " + domain)
                    if return_code != 0:
                        exit_code = 1

    # Do it after in order to update table of snapshots after each domain checking
    start_aad_transfer("refresh_measures")

    sys.exit(exit_code)

if __name__ == '__main__':
    try:
        # sys.argv[1] is INSTALL, REFRESH  or UPDATE
        # sys.argv[2] is ED_ROOT value (Engineering Dashboard URL)
        # sys.argv[3] is DOMAINS_?.TXT file name
        # sys.argv[4] is number of JOBS
        action = sys.argv[1];
        if action == 'INSTALL':
            transfer (sys.argv[2], sys.argv[3], int(sys.argv[4]), "install")
        elif action == 'REFRESH':
            transfer (sys.argv[2], sys.argv[3], int(sys.argv[4]), "refresh")
        elif action == 'UPDATE':
            update (sys.argv[2], sys.argv[3])
        else:    
            print("Internal error - unknown arg: " + sys.argv[1])
            sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(1)