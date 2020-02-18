import sys
import signal
import datetime
import argparse
import requests
import threading
import time
import netrc
import os
from urllib.parse import urlparse
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

item = 0
elapsed_time = 0
is_timer_stopped = False

def print_progress():
    print("Elapsed time: " + str(datetime.timedelta(seconds=elapsed_time)) + "s - size: " + str(item) + "k \r", sep=' ', end='', flush=True, file=sys.stderr)

def start_timer():
    global elapsed_time
    if is_timer_stopped:
        return
    threading.Timer(1.0, start_timer).start()
    elapsed_time += 1
    print_progress()

def stop_timer():
    global is_timer_stopped
    is_timer_stopped = True

def get_credentials(url):
    credentials = os.getenv("CREDENTIALS")
    if credentials:
        return credentials.split(":")
    url_components = urlparse(url)
    # Strip port numbers from netloc
    host = url_components.netloc.split(':')[0]
    file_path = os.path.join(os.environ["USERPROFILE"], "_netrc")
    try:
        username, _, password = netrc.netrc(file_path).authenticators(host)
    except netrc.NetrcParseError:
        print("Malformed file " + file_path)
        exit(1)
    except TypeError:
        print("Cannot find credentials, neither in CREDENTIALS environment variable, nor in " + file_path, file=sys.stderr)
        exit(1)
    return [username, password]

def check_status(status):
    if status == 200:
        return
    print("The requested URL returned error: " + str(status), file=sys.stderr)
    exit(1)

def exit(code):
    stop_timer()
    sys.exit(code)
    
def signal_handler(sig, frame):
    exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="""Fetch data from a Web Server using the environment variable 'CREDENTIALS' or %USERPROFILE%\_netrc
For Windows OS only""")
    parser.add_argument("media", action="store", help="Media type. Typically 'application/json' or 'text/csv'")
    parser.add_argument("url", action="store", help="URL to fetch")    
    parser.add_argument("-o", "--output", dest="output", action="store", help="Output file path, a verbose mode is also enabled")
    parser.add_argument("-r", "--retry", type=int, dest="retry", action="store", help="Number of retries in case of network error", default=5)
    args = parser.parse_args()

    credentials = get_credentials(args.url)
    
    session = requests.Session()
    session.mount('http://', HTTPAdapter(max_retries=Retry(read=args.retry, backoff_factor=1)))
    session.mount('https://', HTTPAdapter(max_retries=Retry(read=args.retry, backoff_factor=1)))
    
    if args.output == None:
        response = session.get(args.url, headers={'accept': args.media, 'user-agent':'python'}, auth=(credentials[0], credentials[1]))
        check_status(response.status_code)
        print(response.text)
        exit(0)
    else:
        start_timer()
        response =requests.get(args.url, headers={'accept': args.media, 'user-agent':'python'}, auth=(credentials[0], credentials[1]), stream=True)
        check_status(response.status_code)
        with open(args.output, 'wb') as f:
            for chunk in response.iter_content(chunk_size=1024):
                item += 1
                f.write(chunk)
        print_progress()
        exit(0)