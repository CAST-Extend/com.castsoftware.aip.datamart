@ECHO OFF
SETLOCAL enabledelayedexpansion
CALL setenv.bat || GOTO :FAIL

set URL=%DEFAULT_ROOT%/%DEFAULT_DOMAIN%
echo Test REST API call with DEFAULT_ROOT and DEFAULT_DOMAIN environment variables
IF [%CREDENTIALS%] == [] (
        echo curl --no-buffer -f -k -H "Accept: application/json" --netrc-file %USERPROFILE%\_netrc "%URL%"
        curl --no-buffer -f -k -H "Accept: application/json" --netrc-file %USERPROFILE%\_netrc "%URL%" || GOTO :FAIL
) ELSE (
        echo curl --no-buffer -f -k -H "Accept: %MEDIATYPE%" -u "%CREDENTIALS%" "%URL%"
        curl --no-buffer -f -k -H "Accept: %MEDIATYPE%" -u "%CREDENTIALS%" "%URL%" || GOTO :FAIL
    )
)

echo.
echo.
echo Test Python
python -V || GOTO :PYTHON_FAIL

GOTO SUCCESS

:FAIL
echo.
echo Environment:
echo USERPROFILE=%USERPROFILE%
echo CREDENTIALS=%CREDENTIALS%
echo DEFAULT_ROOT=%DEFAULT_ROOT%
echo DEFAULT_DOMAIN=%DEFAULT_DOMAIN%
ECHO == Test Fail ==
EXIT /b 1

:PYTHON_FAIL
echo.
echo Cannot find python
ECHO == Test Fail ==
EXIT /b 1

:SUCCESS
ECHO == Test Success ==
EXIT /b 0