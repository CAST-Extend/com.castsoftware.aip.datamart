import sys, psycopg2, os
import decode
import csv

#= Use comma delimiter for compliancy with Excel
DELIMITER=','

def main():
    
    if len(sys.argv) != 2:
        print("Usage is:");
        print("psql_copy_from.py table_name.csv");
        sys.exit(2)
    
    csv_file_name = sys.argv[1]
    table_name = csv_file_name.split('.')[0]

    try:
        csv_file = open(csv_file_name, 'r')
        csv_reader = csv.reader(csv_file, delimiter=DELIMITER)
        columns = next(csv_reader)
        pgpassword = os.getenv("PGPASSWORD")
        if pgpassword:
            os.environ["PGPASSWORD"] = decode.decode(pgpassword)
            
        schema = os.environ["_DB_SCHEMA"]
            
        conn=psycopg2.connect(
            database = os.environ['_DB_NAME'], 
            user = os.environ['_DB_USER'], 
            host = os.environ['_DB_HOST'], 
            port = os.environ['_DB_PORT'],
            options = f'-c search_path={schema}',
        )
        cur = conn.cursor()
        cur.copy_from(csv_file, table_name, sep=',', null='null', columns=columns)
        cur.close()
        csv_file.close()
        conn.commit()
        conn.close()
        sys.exit(0)
        
    except Exception as e:
        print(e, file=sys.stderr)
        sys.exit(2)
 
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(1)