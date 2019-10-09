call extract || goto :FAIL
call transform  || goto :FAIL
call load  || goto :FAIL

GOTO :EOF

:FAIL
EXIT /b 1


