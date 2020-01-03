@echo off
echo %1
%~dp0\curl-bat application/json "%1" | python %~dp0\check_new_snapshot.py