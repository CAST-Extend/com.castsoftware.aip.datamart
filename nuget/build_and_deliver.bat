:: ====================================================================================================================
:: Build tool for aip console tools nuget extension
:: ====================================================================================================================
@if not defined LOGDEBUG set LOGDEBUG=off
@echo %LOGDEBUG%
SetLocal EnableDelayedExpansion

set RETCODE=1
for /f "delims=/" %%a in ('cd') do set WORKSPACE=%%a
for %%a in (%0) do set CMDDIR=%%~dpa
set CMDPATH=%0

:: Checking arguments
set TOOLS_DIR=
set SRC_DIR=
set PACK_DIR=
set BUILDNO=
set VERSION=
set WORKSPACE=
set NOPUB=false

:LOOP_ARG
    set option=%1
    if not defined option goto CHECK_ARGS
    shift
    set value=%1
    if defined value set value=%value:"=%
    call set %option%=%%value%%
    shift
goto LOOP_ARG

:CHECK_ARGS
if not defined TOOLS_DIR (
	echo.
	echo No "tools_dir" defined !
	goto endclean
)
if not defined SRC_DIR (
	echo.
	echo No "src_dir" defined !
	goto endclean
)
if not defined PACK_DIR (
	echo.
	echo No "pack_dir" defined !
	goto endclean
)
if not defined BUILDNO (
	echo.
	echo No "buildno" defined !
	goto endclean
)
if not defined VERSION (
	echo.
	echo No "version" defined !
	goto endclean
)
if not defined WORKSPACE (
	echo.
	echo No "workspace" defined !
	goto endclean
)

set PATH=%PATH%;c:\Tools\Git\usr\bin;C:\CAST-Caches\Win64
if not exist %TEMP% mkdir %TEMP%
set TMPFIC=%TEMP%\build_and_deliver.txt
set ID=com.castsoftware.aip.datamart

for %%a in (%WORKSPACE% %TOOLS_DIR% %SRC_DIR%) do (
    if not exist %%a (
        echo.
        echo ERROR: Folder %%a does not exist
        goto endclean
    )
)
cd /d %WORKSPACE%

for %%a in (%PACK_DIR%) do (
    if exist %%a rmdir /s /q %%a
    mkdir %%a
    if errorlevel 1 goto endclean
)

echo.
echo =========================================
echo Preparing component package
echo =========================================
pushd %PACK_DIR%
curl http://jenkins5/job/DASHBOARD_Master_Build_Datamart_JAR/lastSuccessfulBuild/artifact/target/archive.zip -o archive.zip
set CMD=7z.exe x archive.zip
echo %CMD%
call %CMD% >%TMPFIC% 2>&1
if errorlevel 1 (
    type %TMPFIC%
    goto endclean
)
for /f "delims=/" %%a in ('cd') do set PACK_DIR=%%a
robocopy /mir /nfl /ndl /njh /njs /nc /ns %SRC_DIR% . -xd nuget -xd .git -xf .gitattributes
if errorlevel 8 goto endclean
robocopy /mir /nfl /ndl /njh /njs /nc /ns \\productfs01\EngTools\external_tools\datamart\thirdparty thirdparty
if errorlevel 8 goto endclean

echo.
echo =========================================
echo Zipping component package
echo =========================================
if exist *.zip del /q *.zip
set CMD=7z.exe a -sdel -r -mx5 ..\%ID%.%VERSION%.zip .\
echo Executing command:
echo %CMD%
call %CMD% >%TMPFIC% 2>&1
if errorlevel 1 (
    type %TMPFIC%
    goto endclean
)
popd
mv.exe %ID%.%VERSION%.zip %PACK_DIR%
if errorlevel 1 goto endclean

xcopy /f /y %SRC_DIR%\nuget\package_files\plugin.nuspec %PACK_DIR%
if errorlevel 1 goto endclean

sed -i 's/_THE_VERSION_/%VERSION%/' %PACK_DIR%/plugin.nuspec
if errorlevel 1 goto endclean
sed -i 's/_THE_VERSION_/%VERSION%/' %PACK_DIR%/plugin.nuspec
if errorlevel 1 goto endclean
sed -i 's/_THE_ID_/%ID%/' %PACK_DIR%/plugin.nuspec
if errorlevel 1 goto endclean
 
:: ========================================================================================
:: Nuget packaging
:: ========================================================================================
set CMD=%TOOLS_DIR%\nuget_package_basics.bat outdir=%PACK_DIR% pkgdir=%PACK_DIR% buildno=%BUILDNO% nopub=%NOPUB% is_component=true
echo Executing command:
echo %CMD%
call %CMD%
if errorlevel 1 goto endclean

for /f "tokens=*" %%a in ('dir /b %PACK_DIR%\com.castsoftware.*.nupkg') do set PACKPATH=%PACK_DIR%\%%a
if not defined PACKPATH (
	echo .
	echo ERROR: No package was created : file not found %PACK_DIR%\com.castsoftware.*.nupkg ...
	goto endclean
)
if not exist %PACKPATH% (
	echo .
	echo ERROR: File not found %PACKPATH% ...
	goto endclean
)

set GROOVYEXE=groovy
%GROOVYEXE% --version 2>nul
if errorlevel 1 set GROOVYEXE="%GROOVY_HOME%\bin\groovy"
%GROOVYEXE% --version 2>nul
if errorlevel 1 (
	echo ERROR: no groovy executable available, need one!
	goto endclean
)

:: ========================================================================================
:: Nuget checking
:: ========================================================================================
set CMD=%GROOVYEXE% %TOOLS_DIR%\nuget_package_verification.groovy --packpath=%PACKPATH%
echo Executing command:
echo %CMD%
call %CMD%
if errorlevel 1 goto endclean

echo.
echo Extension creation in SUCCESS
set RETCODE=0

:endclean
cd /d %WORKSPACE%
exit /b %RETCODE%
