import sys,json,psycopg2,os
import csv
import decode

# Read left snapshots from STDIN (REST API)
left_snapshots = {}
csv_reader = csv.reader(sys.stdin, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
skip = True
for csv_row in csv_reader:
    if skip:
       skip = False
       continue
    application_name = csv_row[1]
    if not application_name in left_snapshots:
        left_snapshots[application_name] = 1
    else:
        left_snapshots[application_name] += 1

# Read right snapshots from CSV File (Datamart table)
right_snapshots = {}
with open(sys.argv[1]) as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for csv_row in csv_reader:
        application_name = csv_row[0]
        nb_snapshots = csv_row[1]
        right_snapshots[csv_row[0]] = int(nb_snapshots)

# Compare the number of snapshots from stdin with the number of snapshots stored in the Datamart tables by application
for application in left_snapshots:
    #print("left_snapshots[" + application + "] (" + str(left_snapshots[application]) + ") != right_snapshots[" + application + "] (" + str(right_snapshots[application]) + "))" + " = " + str(left_snapshots[application] != right_snapshots[application]))
    try:
        if left_snapshots[application] != right_snapshots[application]:
            sys.exit(1)
    except:
        sys.exit(1)

