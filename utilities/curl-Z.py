import argparse
import subprocess
import decode
import os
import sys
    
def main():    
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="""Run CURL to fetch data from a Web Server using the environment variable 'CREDENTIALS' or %USERPROFILE%\_netrc
For Windows OS only""")
    parser.add_argument("curl", action="store", help="Curl binary path")
    parser.add_argument("max", action="store", help="Maximum number of concurrent requests")
    parser.add_argument("mediatype", action="store", help="Media type. Typically 'application/json' or 'text/csv'")
    parser.add_argument("paths", action="store", nargs="*", help="Pairs of Output File Path and URL to fetch")      
    args = parser.parse_args()

    curl_args = [args.curl, '-c', 'cookies.txt', '-b', 'cookies.txt', '--retry', '5', '--no-buffer', '-f', '-k', '-H', 'Accept: ' + args.mediatype, '-H', 'X-Client: Datamart']
    credentials=os.getenv("CREDENTIALS")
    apikey=os.getenv("APIKEY")
    if credentials:
        curl_args += ['-u', decode.decode(credentials)]
    elif apikey:
        curl_args += ['-H', 'X-API-KEY: ' + decode.decode(apikey)]
    else:
        curl_args += ['--netrc-file', os.getenv("USERPROFILE") +  '\_netrc ']
    curl_args += ["-Z", "--parallel-max", args.max]
    print("------------------------------ ")
    for i in range(0,len(args.paths),2):
        print("Extract " + args.paths [i]);
        curl_args += ['-o', args.paths[i+1], args.paths[i]]
    print("------------------------------ ")
    exit_code = subprocess.run(curl_args).returncode
    if exit_code == 22:
        print("on error (470): check the credentials", file=sys.stderr)
        print("on error (400): check the REST API version", file=sys.stderr)
        print("on error (404): check the domain name", file=sys.stderr)
    sys.exit(exit_code)
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(1)
