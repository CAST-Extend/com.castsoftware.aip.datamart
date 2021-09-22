import sys,json,psycopg2,os
import csv
import decode

# Save current applications with number of applications from Datamart
try:
    pgpassword = os.getenv("PGPASSWORD")
    if pgpassword:
        environment = os.environ
        environment["PGPASSWORD"] = decode.decode(pgpassword)
    conn=psycopg2.connect(database = os.environ['_DB_NAME'], user=os.environ['_DB_USER'], host=os.environ['_DB_HOST'], port=os.environ['_DB_PORT'])
    cur = conn.cursor()
    query = "SELECT APPLICATION_NAME, COUNT(*) FROM " + os.environ['_DB_SCHEMA'] + ".DIM_SNAPSHOTS GROUP BY APPLICATION_NAME"
    cur.execute(query)
    rows = cur.fetchall()
    exit_code = 0
    
    with open(sys.argv[1], 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        writer.writerows(rows)

    cur.close()
    conn.close()
    sys.exit(exit_code)
except Exception as e:
    print("Unable to connect to the datamart database" )
    print(e)
    sys.exit(2)
    
    
