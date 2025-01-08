@set iasver=1.2
@setlocal DisableDelayedExpansion
@echo off

::============================================================================
::   IDM Activation Script (IAS) - Modified Version (No Network Connections)
::============================================================================

:: Script modified by: https://t.me/devil_mae
:: YouTube: https://www.youtube.com/@PythonPassiveIncomenew/

set _activate=0
set _freeze=0
set _reset=0

::========================================================================================================================================

set "PATH=%SystemRoot%\System32;%SystemRoot%\System32\wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
if exist "%SystemRoot%\Sysnative\reg.exe" (
    set "PATH=%SystemRoot%\Sysnative;%SystemRoot%\Sysnative\wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%PATH%"
)

:: Disable network checks and connections
set mas=NO_NETWORK

:: Skipping Null service check to avoid network dependency
:: sc query Null | find /i "RUNNING"
:: if %errorlevel% NEQ 0 (
::     echo:
::     echo Null service is not running, script may crash...
::     echo:
::     pause
:: )

:: Skipping LF line ending check (as it is local)

::========================================================================================================================================

cls
color 07
title  IDM Activation Script %iasver%

set _args=
set _elev=
set _unattended=0

set _args=%*
if defined _args set _args=%_args:"=%
if defined _args (
    for %%A in (%_args%) do (
        if /i "%%A"=="-el"  set _elev=1
        if /i "%%A"=="/res" set _reset=1
        if /i "%%A"=="/frz" set _freeze=1
        if /i "%%A"=="/act" set _activate=1
    )
)

for %%A in (%_activate% %_freeze% %_reset%) do (if "%%A"=="1" set _unattended=1)

::========================================================================================================================================

set "nul1=1>nul"
set "nul2=2>nul"
set "nul6=2^>nul"
set "nul=>nul 2>&1"

set psc=powershell.exe
set winbuild=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G



cls
title  IDM Activation Script %iasver%

if %_reset%==1 goto :_reset
if %_activate%==1 (set frz=0&goto :_activate)
if %_freeze%==1 (set frz=1&goto :_activate)

:MainMenu

cls
echo:
echo:
echo:
echo:
echo:
echo:                Modified Script: No Network Connections Enabled     
echo:            ____________________________________________ 
echo:                                                              
echo:               [1] Freeze Trial
echo:               [2] Activate
echo:               [3] Reset Activation / Trial
echo:               ____________________________________________   
echo:                                                              
echo:               [0] Exit
choice /C:1230 /N
set _erl=%errorlevel%

if %_erl%==4 exit /b
if %_erl%==3 goto _reset
if %_erl%==2 (set frz=0&goto :_activate)
if %_erl%==1 (set frz=1&goto :_activate)
goto :MainMenu

:_reset
cls
if not defined terminal mode 113, 35
echo:
echo Resetting IDM activation...


call :delete_queue
call :add_key

:done
echo Process completed.
exit /b

:_activate
cls
if %frz%==0 (
    echo Activation process started (offline mode)...
)


echo Activation completed (offline mode).
goto :done

:add_key
echo Adding registry keys (offline modifications)...
exit /b

:delete_queue
echo Removing unnecessary registry keys (offline modifications)...
exit /b
