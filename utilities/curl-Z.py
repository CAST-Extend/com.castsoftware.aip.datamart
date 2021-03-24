import argparse
import subprocess
import decode
import os
import sys
    
def full_executable_path(invoked):
     # From https://bugs.python.org/issue8557  
     # https://bugs.python.org/issue8557
     # with subprocess.open, c:\windows\system32\curl.exe has precedence on the PATH environment variable for Windows 10
     # which discards the path to the  thirdparty directory     
    explicit_dir = os.path.dirname(invoked)
    if explicit_dir:
        path = [ explicit_dir ]
    else:
        path = os.environ.get('PATH').split(os.path.pathsep)
    for dir in path:
        full_path = os.path.join(dir, invoked)
        if os.path.exists( full_path ):
            return full_path
    return invoked # Not found; invoking it will likely fail
  
def main():    
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="""Run CURL to fetch data from a Web Server using the environment variable 'CREDENTIALS' or %USERPROFILE%\_netrc
For Windows OS only""")
    parser.add_argument("max", action="store", help="Maximum number of concurrent requests")
    parser.add_argument("mediatype", action="store", help="Media type. Typically 'application/json' or 'text/csv'")
    parser.add_argument("paths", action="store", nargs="*", help="Pairs of Output File Path and URL to fetch")      
    args = parser.parse_args()
    
    curl_args = [full_executable_path("curl.exe"), '-c', 'cookies.txt', '-b', 'cookies.txt', '--retry', '5', '--no-buffer', '-f', '-k', '-H', 'Accept: ' + args.mediatype, '-H', 'X-Client: Datamart']
    credentials=os.getenv("CREDENTIALS")
    apikey=os.getenv("APIKEY")
    if credentials:
        curl_args += ['-u', decode.decode(credentials)]
    elif apikey:
        curl_args += ['-H', 'X-API-KEY: ' + decode.decode(apikey)]
    else:
        curl_args += ['--netrc-file', os.getenv("USERPROFILE") +  '\_netrc ']
    
    if int(args.max) == 1:
        # sequential calls of Curl
        for i in range(0,len(args.paths),2):
            print("------------------------------ ")
            curl_args_copy = curl_args.copy()
            print("Extract " + args.paths [i]);
            curl_args_copy += ['-o', args.paths[i+1], args.paths[i]]
            print("------------------------------ ")
            exit_code = subprocess.run(curl_args_copy).returncode
            if exit_code == 22:
                print("on error (470): check the credentials", file=sys.stderr)
                print("on error (400): check the REST API version", file=sys.stderr)
                print("on error (404): check the domain name", file=sys.stderr)
                sys.exit(exit_code)
        sys.exit(0)
    
    curl_args += ["-Z", "--parallel-immediate", "--parallel-max", args.max]
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
