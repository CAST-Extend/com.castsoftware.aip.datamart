@echo off
set MEDIATYPE=%1
set URL=%2
set OUTPUT=%3

if [%MEDIATYPE%] == [] goto :USAGE
if [%URL%] == [] goto :USAGE

IF [%CREDENTIALS%] == [] GOTO :NETRC
GOTO :CREDENTIALS

:USAGE
echo curl-bat MEDIATYPE URL [OUTPUT]
echo     Call CURL using the environment variable 'CREDENTIALS' or %USERPROFILE%\_netrc
echo Example:
echo curl-bat application/json https://demo-eu.castsoftware.com/Health/rest
EXIT /b 1

:CREDENTIALS
IF [%OUTPUT%] == [] (
    curl --retry 5 --no-buffer -f -k -H "Accept: %MEDIATYPE%" -u "%CRED%" "%URL%" || GOTO :FAIL
) ELSE (
    curl --retry 5 --no-buffer -f -k -H "Accept: %MEDIATYPE%" -u "%CRED%" "%URL%" -o "%OUTPUT%" || GOTO :FAIL
)
GOTO :EOF

:NETRC
IF [%OUTPUT%] == [] (
    curl --retry 5 --no-buffer -f -k -H "Accept: %MEDIATYPE%" --netrc-file %USERPROFILE%\_netrc "%URL%" || GOTO :FAIL
)
 ELSE (
    curl --retry 5 --no-buffer -f -k -H "Accept: %MEDIATYPE%" --netrc-file %USERPROFILE%\_netrc "%URL%" -o "%OUTPUT%" || GOTO :FAIL
)
GOTO :EOF

:FAIL
echo Curl failed with MEDIATYPE=%MEDIATYPE%, URL=%URL%, OUTPUT=%OUTPUT%, CREDENTIALS=%CREDENTIALS%
EXIT /b 1
