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

    curl_args = ['curl', '--retry', '5', '--no-buffer', '-f', '-k', '-H', 'Accept: ' + args.mediatype]
    credentials=os.getenv("CREDENTIALS")
    if credentials:
        curl_args += ['-u', decode.decode(credentials)]
    else:
        curl_args += ['--netrc-file', os.getenv("USERPROFILE") +  '\_netrc ']
    output=args.output
    if output:
        curl_args += ['-o', output]
    curl_args +=  [args.url]
    exit_code = subprocess.run(curl_args).returncode
    sys.exit(exit_code)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(1)
