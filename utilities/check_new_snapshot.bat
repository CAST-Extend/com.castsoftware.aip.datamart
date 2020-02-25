@echo off
echo %1
python utilities\curl.py application/json "%1" | python utilities\check_new_snapshot.py