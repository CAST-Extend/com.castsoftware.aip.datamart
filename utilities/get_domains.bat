@echo off
(echo "" > %2) || goto :FAIL
(python utilities\curl.py application/json "%1" | python utilities\filter_domains.py > %2)
EXIT /b 0

:FAIL
echo Acccess is denied to write into %2 file in current directory
EXIT /b 1