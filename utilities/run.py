import argparse
import subprocess
import decode
import os
import sys
    
def main():
    pgpassword = os.getenv("PGPASSWORD")
    if pgpassword:
        environment = os.environ
        environment["PGPASSWORD"] = decode.decode(pgpassword)
        exit_code = subprocess.run(sys.argv[1:], env=environment).returncode
    else:
        exit_code = subprocess.run(sys.argv[1:]).returncode
    sys.exit(exit_code)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(1)
