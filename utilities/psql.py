import sys, psycopg2, os
import decode

def main():
    
    if len(sys.argv) != 2:
        print("Usage is:");
        print("psql.py file.sql");
        sys.exit(2)
    
    file = sys.argv[1]

    try:
        sql_file = open(file,'r')
        
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
        cur.execute(sql_file.read())
        cur.close()
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