@echo off
(echo "" > %2) || goto :FAIL
(python -m utilities.curl application/json "%1" | python -m utilities.filter_domains > %2)
EXIT /b %ERRORLEVEL%

:FAIL
echo Access is denied to write %2 file into current directory
EXIT /b 1