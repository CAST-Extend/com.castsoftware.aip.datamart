ECHO OFF
SETLOCAL enabledelayedexpansion

pushd %~dp0

ECHO Build data_dictionary.md 
python utilities\build_data_dictionary.py markdown > data_dictionary.md || GOTO :FAIL
GOTO :SUCCESS

:FAIL
popd
ECHO == Script Failed ==
EXIT /b 1

:SUCCESS
popd
ECHO == Script Done ==
EXIT /b 0

