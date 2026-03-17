import argparse
import subprocess
import os
import sys

#  Decode a text to prevent "shoulder surfing", except if the text starts with "HEX:"
import base64, sys

def decode(text):
   if not text.startswith("HEX:"):
       return(text)
   else:
       text2 = text[4:]
       try:
           msg = "warning:"
           dec = []
           enc = base64.urlsafe_b64decode(bytearray.fromhex(text2).decode()).decode()
           for i in range(len(enc)):
              key_c = msg[i % len(msg)]
              dec_c = chr((256 + ord(enc[i]) - ord(key_c)) % 256)
              dec.append(dec_c)
           return("".join(dec))
       except:
           return(text)
        

def full_executable_path(invoked):
    if os.name == 'posix':
        return "curl"
        
     # From https://bugs.python.org/issue8557  
     # https://bugs.python.org/issue8557
     # with subprocess.open, c:\windows\system32\curl.exe has precedence on the PATH environment variable for Windows 10
     # which discards the path to the thirdparty directory
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


    
def curl(argv=None):    
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="""Run CURL to fetch data from a Web Server using the environment variable 'CREDENTIALS' or %USERPROFILE%\\_netrc
For Windows OS only""")
    parser.add_argument("mediatype", action="store", help="Media type. Typically 'application/json' or 'text/csv'")
    parser.add_argument("url", action="store", help="URL to fetch")    
    parser.add_argument("-o", "--output", dest="output", action="store", help="Output file path")
    args = parser.parse_args(argv)

    curl_args = [full_executable_path("curl.exe"), '-c', 'cookies.txt', '-b', 'cookies.txt', '--retry', '5', '--no-buffer', '--fail-with-body', '-k', '-H', 'Accept: ' + args.mediatype, '-H', 'X-Client: Datamart']
    credentials=os.getenv("CREDENTIALS")
    apikey=os.getenv("APIKEY")
    if credentials:
        curl_args += ['-u', decode(credentials)]
    elif apikey:
        curl_args += ['-H', 'X-API-USER: '  + decode(os.getenv("APIUSER")), '-H', 'X-API-KEY: ' + decode(apikey)]
    else:
        curl_args += ['--netrc-file', os.getenv("USERPROFILE") +  '\\_netrc ']
    output=args.output
    if output:
        curl_args += ['-o', output]
    curl_args +=  [args.url]
    #print(curl_args)
    exit_code = subprocess.run(curl_args).returncode
    msg = "See also error message in " + output if output else ""
    if exit_code == 22:
        print("on error (470/401): check the credentials", file=sys.stderr)
        print("on error (400): check the REST API version", file=sys.stderr)
        print("on error (404): check the domain name", file=sys.stderr)
        print(msg)
        print("Requested URL: "+ args.url, file=sys.stderr)   
    return exit_code
       

if __name__ == '__main__':
    try:
        sys.exit(curl())
    except KeyboardInterrupt:
        sys.exit(1)
