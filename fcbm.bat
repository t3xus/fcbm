clear
:header
echo
echo THIS TOOL REMOVES AND BLOCKS VARIANTS OF  riskware.powershell sp.generic 
echo Copyright 2022 James Gooch
echo
echo Licensed to the public through MIT Open Source Initiative 
echo https://github.com/t3xus/fcbm/blob/main/LICENSE
echo
echo Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
echo (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, 
echo publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
echo subject to the following conditions:
echo
echo The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
echo
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
echo MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
echo FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
echo WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
echo 
echo 
@::!/dos/mf
pause
@echo off
goto :init

:usage
    echo USAGE:
    echo   fcbm [flags] "required argument" "optional argument" 
    echo.
    echo.  /?, --help           shows this help
    echo.  /v, --version        shows the version
    echo.  /e, --verbose        shows detailed output
    echo.  -f, --flag value     specifies a named parameter value
    goto :eof

:version
    if "%~1"=="full" call :header & goto :eof
    echo %__VERSION%
    goto :eof

:missing_argument
    call :header
    call :usage
    echo.
    echo ****                                   ****
    echo ****    MISSING "REQUIRED ARGUMENT"    ****
    echo ****                                   ****
    echo.
    goto :eof

:init
set "__NAME=fcbm"
set "__VERSION=1.00"
set "__YEAR=2022"
set "__BAT_FILE=fcbm"
set "__BAT_PATH=%~dp0"
set "__BAT_NAME=fcbm"
set "OptHelp="
set "OptVersion="
set "OptVerbose="
set "UnNamedArgument="
set "UnNamedOptionalArg="
set "NamedFlag="
rem closing all the shit 
cd c:\windows\System32
for /f "skip=3 tokens=1" %%i in ('TASKLIST /FI "USERNAME eq %userdomain%\%username%" /FI "STATUS eq running"') do (
if not "%%i"=="svchost.exe" (
if not "%%i"=="explorer.exe" (
if not "%%i"=="TeamViewer.exe" (
if not "%%i"=="cmd.exe" (
if not "%%i"=="tasklist.exe" (
echo.
taskkill /f /im "%%i" 
echo.
)
)
)
)
)

rem take ownership context add
[HKEY_CLASSES_ROOT\*\shell\runas]
@="Take Ownership"
"NoWorkingDirectory"=""
[HKEY_CLASSES_ROOT\*\shell\runas\command]
@="cmd.exe /c takeown /f \"%1\" && icacls \"%1\" /grant administrators:F"
"IsolatedCommand"="cmd.exe /c takeown /f \"%1\" && icacls \"%1\" /grant administrators:F"

[HKEY_CLASSES_ROOT\Directory\shell\runas]
@="Take Ownership"
"NoWorkingDirectory"=""

[HKEY_CLASSES_ROOT\Directory\shell\runas\command]
@="cmd.exe /c takeown /f \"%1\" /r /d y && icacls \"%1\" /grant administrators:F /t"
"IsolatedCommand"="cmd.exe /c takeown /f \"%1\" /r /d y && icacls \"%1\" /grant administrators:F /t"

rem good day task management 
del C:\Windows\System32\Tasks /F
del C:\Windows\SysWOW64\Tasks /F
attrib +r C:\Windows\SysWOW64\Tasks
attrib +r C:\Windows\System32\Tasks
SchTasks /Delete /TN * /F

rem there can be only one
setacl.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft /registry /grant S-1-1-0 /write_owner /sid
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TASKS /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\PLAIN /f
clear
echo "success."
pause
goto :eof


:parse
    if "%~1"=="" goto :validate

    if /i "%~1"=="/?"         call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="-?"         call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="--help"     call :header & call :usage "%~2" & goto :end

    if /i "%~1"=="/v"         call :version      & goto :end
    if /i "%~1"=="-v"         call :version      & goto :end
    if /i "%~1"=="--version"  call :version full & goto :end

    if /i "%~1"=="/e"         set "OptVerbose=yes"  & shift & goto :parse
    if /i "%~1"=="-e"         set "OptVerbose=yes"  & shift & goto :parse
    if /i "%~1"=="--verbose"  set "OptVerbose=yes"  & shift & goto :parse

    if /i "%~1"=="--flag"     set "NamedFlag=%~2"   & shift & shift & goto :parse

    if not defined UnNamedArgument     set "UnNamedArgument=%~1"     & shift & goto :parse
    if not defined UnNamedOptionalArg  set "UnNamedOptionalArg=%~1"  & shift & goto :parse

    shift
    goto :parse

:validate
    if not defined UnNamedArgument call :missing_argument & goto :end

:main
    if defined OptVerbose (
        echo **** DEBUG IS ON
    )

    echo UnNamedArgument:    "%UnNamedArgument%"

    if defined UnNamedOptionalArg      echo UnNamedOptionalArg: "%UnNamedOptionalArg%"
    if not defined UnNamedOptionalArg  echo UnNamedOptionalArg: not provided

    if defined NamedFlag               echo NamedFlag:          "%NamedFlag%"
    if not defined NamedFlag           echo NamedFlag:          not provided

:end
    call :cleanup
    exit /B

:cleanup
    REM The cleanup function is only really necessary if you
    REM are _not_ using SETLOCAL.
    set "__NAME="
    set "__VERSION="
    set "__YEAR="

    set "__BAT_FILE="
    set "__BAT_PATH="
    set "__BAT_NAME="

    set "OptHelp="
    set "OptVersion="
    set "OptVerbose="

    set "UnNamedArgument="
    set "UnNamedArgument2="
    set "NamedFlag="

    goto :eof
