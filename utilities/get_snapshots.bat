@echo off
(echo "" > %2) || goto :FAIL
(python utilities\curl.py text/csv "%1" > "%2") || goto :FAIL2
EXIT /b 0

:FAIL
echo Access is denied to write into %2 file in current directory
EXIT /b 1

:FAIL2
echo Cannot fetch snapshots from %1
EXIT /b 1