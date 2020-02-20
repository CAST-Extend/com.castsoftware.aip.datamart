import sys,json
comma = ''
domains = ''
try:
    for x in json.load(sys.stdin):
        if x['href'] != 'AAD': 
            domains += comma + x['href']
            comma = ', '
    print(domains)
except:
    sys.exit(1)