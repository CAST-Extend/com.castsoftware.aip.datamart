import sys,json
comma = ''
domains = ''
try:
    for x in json.load(sys.stdin):
        if not x['href'].startswith('AAD'): 
            domains += comma + x['href']
            comma = ', '
    print(domains)
except:
    sys.exit(1)