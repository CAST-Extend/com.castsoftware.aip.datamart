import sys,json
import os
comma = ''
domains = ''
HD_DOMAIN=os.getenv("HD_DOMAIN")
try:
    for x in json.load(sys.stdin):
        if x['href'] != HD_DOMAIN: 
            domains += comma + x['href']
            comma = ', '
    print(domains)
except:
    sys.exit(1)