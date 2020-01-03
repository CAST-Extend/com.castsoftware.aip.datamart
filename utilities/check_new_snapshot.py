import sys,json,psycopg2,os
import csv

# Read snapshots from STDIN
snapshots = {}
csv_reader = csv.reader(sys.stdin, delimiter=';')
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
# Compare number of snapshots from stdin with the number of snapshots stored in the Datamart tables
try:
    conn=psycopg2.connect(database = os.environ['_DB_NAME'], user=os.environ['_DB_USER'], host=os.environ['_DB_HOST'], port=os.environ['_DB_PORT'])
    cur = conn.cursor()
    query = "SELECT APPLICATION_NAME, COUNT(*) FROM " + os.environ['_DB_SCHEMA'] + ".DIM_SNAPSHOTS GROUP BY APPLICATION_NAME"
    cur.execute(query)
    rows = cur.fetchall()
    exit_code = 0
    for row in rows:
        try:
            if snapshots[row[0]] != row[1]:
                exit_code = 1
                break
        except:
            continue
    cur.close()
    conn.close()
    sys.exit(exit_code)
except Exception as e:
    print("Unable to connect to the datamart database" )
    print(e)
    sys.exit(2)
