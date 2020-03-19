import platform
import sys

def check (generation, major, minor):
    if generation > 3:
        return 0

    if generation < 3:
        return 1

    if major > 6:
        return 0

    if major < 6:
        return 1

    if minor >= 4:
        return 0
    
    return 1

def tests():
    print ("ok" if check (3,6,4) == 0 else "ko")
    print ("ok" if check (3,6,5) == 0 else "ko")
    print ("ok" if check (3,8,2) == 0 else "ko")
    print ("ok" if check (4,0,0) == 0 else "ko")
    
    print ("ok" if check (2,7,1) == 1 else "ko")
    print ("ok" if check (3,5,8) == 1 else "ko")        
    print ("ok" if check (3,6,3) == 1 else "ko")    

v=platform.python_version_tuple()
if check(int(v[0]), int(v[1]), int(v[2])) == 0:
    sys.exit(0)

print("Python version 3.6.4 or higher is required")
sys.exit(1)
