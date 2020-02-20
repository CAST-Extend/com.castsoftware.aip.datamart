@echo off
echo %1
python %~dp0\curl.py application/json "%1" | python %~dp0\check_new_snapshot.py