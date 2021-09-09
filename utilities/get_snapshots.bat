@echo off
(echo "" > %1) || goto :FAIL
(python utilities\get_snapshots.py "%1") || goto :FAIL2
EXIT /b 0

:FAIL
echo Access is denied to write into %1 file in current directory
EXIT /b 1

:FAIL2
echo Cannot fetch snapshots from Datamart
EXIT /b 1