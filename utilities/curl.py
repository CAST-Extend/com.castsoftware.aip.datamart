import argparse
import subprocess
import decode
import os
import sys
    
def main():    
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="""Run CURL to fetch data from a Web Server using the environment variable 'CREDENTIALS' or %USERPROFILE%\_netrc
For Windows OS only""")
    parser.add_argument("mediatype", action="store", help="Media type. Typically 'application/json' or 'text/csv'")
    parser.add_argument("url", action="store", help="URL to fetch")    
    parser.add_argument("-o", "--output", dest="output", action="store", help="Output file path")
    args = parser.parse_args()

    curl_args = ['curl', '--retry', '5', '--no-buffer', '-f', '-k', '-H', 'Accept: ' + args.mediatype, '-H', 'X-Client: Datamart']
    credentials=os.getenv("CREDENTIALS")
    apikey=os.getenv("APIKEY")
    if credentials:
        curl_args += ['-u', decode.decode(credentials)]
    elif apikey:
        curl_args += ['-H', 'X-API-KEY: ' + decode.decode(apikey)]
    else:
        curl_args += ['--netrc-file', os.getenv("USERPROFILE") +  '\_netrc ']
    output=args.output
    if output:
        curl_args += ['-o', output]
    curl_args +=  [args.url]
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
