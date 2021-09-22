import sys,json,psycopg2,os
import csv
import decode

# Read left snapshots from STDIN
snapshots = {}
csv_reader = csv.reader(sys.stdin, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
skip = True
for csv_row in csv_reader:
    if skip:
       skip = False
       continue
    application_name = csv_row[1]
    if not application_name in snapshots:
        snapshots[application_name] = 1
    else:
        snapshots[application_name] += 1

# Read right snapshots from CSV File (Datamart table)
# Compare number of snapshots from stdin with the number of snapshots stored in the Datamart tables by application
try:
    csv_reader = csv.reader(sys.argv[1], delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for csv_row in csv_reader:
        try:
            if snapshots[csv_row[0]] != csv_row[1]:
                sys.exit(1)
        except:
            continue
    sys.exit(0)
except Exception as e:
    print("Unable to connect to the datamart database" )
    print(e)
    sys.exit(2)
