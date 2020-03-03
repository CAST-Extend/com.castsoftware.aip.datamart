from datetime import datetime
print(datetime.now().replace(microsecond=0).isoformat().replace(':','-'))