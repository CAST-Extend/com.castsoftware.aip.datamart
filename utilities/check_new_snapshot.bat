@echo off
echo %1
python utilities\curl.py text/csv "%1" | python utilities\check_new_snapshot.py
