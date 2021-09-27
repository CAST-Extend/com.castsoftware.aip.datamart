@echo off
(echo "" > %2) || goto :FAIL
(python utilities\curl.py application/json "%1" | python utilities\filter_domains.py > %2)
EXIT /b %ERRORLEVEL%

:FAIL
echo Access is denied to write %2 file into current directory
EXIT /b 1