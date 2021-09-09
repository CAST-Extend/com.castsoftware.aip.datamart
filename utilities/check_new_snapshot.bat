@echo off
echo Fetch %1
python utilities\curl.py text/csv "%1" | python utilities\check_new_snapshot.py %2
