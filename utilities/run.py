import argparse
import subprocess
import decode
import os
import sys
from datetime import datetime

def timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def run_with_timestamp(cmd, env=None):
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        env=env,
        bufsize=1
    )

    for line in process.stdout:
        sys.stdout.write(f"{timestamp()} {line}")
        sys.stdout.flush()

    process.wait()
    return process.returncode

def main():
    pgpassword = os.getenv("PGPASSWORD")

    if pgpassword:
        environment = os.environ.copy()
        environment["PGPASSWORD"] = decode.decode(pgpassword)
        exit_code = run_with_timestamp(sys.argv[1:], env=environment)
    else:
        exit_code = run_with_timestamp(sys.argv[1:])

    sys.exit(exit_code)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(1)