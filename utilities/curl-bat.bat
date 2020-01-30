@echo off
set MEDIATYPE=%1
set URL=%2
set OUTPUT=%3

if [%MEDIATYPE%] == [] goto :USAGE
if [%URL%] == [] goto :USAGE

GOTO :RUN

:USAGE
echo curl-bat MEDIATYPE URL [OUTPUT]
echo     Call CURL using the environment variable 'CREDENTIALS' or %USERPROFILE%\_netrc
echo Example:
echo curl-bat application/json https://demo-eu.castsoftware.com/Health/rest
EXIT /b 1

:RUN
IF [%CREDENTIALS%] == [] (
   IF [%OUTPUT%] == [] (
        curl --no-buffer -f -k -H "Accept: %MEDIATYPE%" --netrc-file %USERPROFILE%\_netrc "%URL%" || EXIT /b 1
   ) ELSE (
        curl --no-buffer -f -k -H "Accept: %MEDIATYPE%" --netrc-file %USERPROFILE%\_netrc "%URL%" -o "%OUTPUT%" || EXIT /b 1
   )
) ELSE (
    IF [%OUTPUT%] == [] (
        curl --no-buffer -f -k -H "Accept: %MEDIATYPE%" -u "%CREDENTIALS%" "%URL%" || EXIT /b 1
    ) ELSE (
        curl --no-buffer -f -k -H "Accept: %MEDIATYPE%" -u "%CREDENTIALS%" "%URL%" -o "%OUTPUT%" || EXIT /b 1    
    )
)
