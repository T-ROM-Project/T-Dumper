:: T-ROM Project (timmkoo.de) 2025-2026 
@echo off 
:: Requesting admin rights
:-------------------------------------
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: Admin rights request finished
:: Making Open it in Fullscreen
powershell -WindowStyle Maximized -Command "Start-Sleep -Seconds 1"
:: Start of the main Script
setlocal
setlocal EnableDelayedExpansion
:: Version of the script
set "VER=2.1"
:: Filepaths (If anyone wants to change it)
set "ROOT=%USERPROFILE%\Desktop\trom"
set "RES=%ROOT%\res"
set "TOOLS=%ROOT%\tools"
set "SYS=%RES%\system.img"
set "BOOT=%RES%\boot.img"
set "KITCHEN=%TOOLS%\Kitchen"
set "FTOOL=%TOOLS%\Flashtool"
set "PORT=%TOOLS%\Porttool"
set "MDRI=%RES%\Driver"
set "PYTHON_EXE=%FILETEMP%\python-latest.exe"
set "SCRIPTS=%ROOT%\scripts"
set "FILETEMP=%ROOT%\temp"
set "BASEURL=https://github.com/T-ROM-Project/T-ROM-Sources-Manifest/raw/refs/heads/main"
set "MTKCHECK=C:\Program Files\MediaTek\SP Driver\Tools"
set "USBCHECK=C:\Windows\System32\drivers"
set scriptPath=%~dp0
set "AUTOSTART=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"
set "MTKCLI=%TOOLS%\mtkcli"
set  "RP=%FILETEMP%\RP.hta"
set "MTKCLIOUT=%MTKCLI%\mtkclient-main\output"
set "devchoice=%SAVEDATA%\enable.txt"
set "NOCONFIG=Not yet configured"
set "vscodeexe=%FILETEMP%\setup.exe"
:: Logo
echo TTTTTTT   RRRRRR   OOOOOO   M     M  
echo    T      R     R  O    O   MM   MM  
echo    T      RRRRRR   O    O   M M M M  
echo    T      R   R    O    O   M  M  M  
echo    T      R    R   OOOOOO   M     M  
echo ====================================
echo T-Dumper %VER%
echo ====================================
timeout /t 2 >nul
cls
echo Booting up ...
powershell.exe -c "mkdir '%ROOT%'"    >nul 2>&1
powershell.exe -c "mkdir '%RES%'"     >nul 2>&1
powershell.exe -c "mkdir '%TOOLS%'"   >nul 2>&1
powershell.exe -c "mkdir '%KITCHEN%'" >nul 2>&1
powershell.exe -c "mkdir '%FTOOL%'"   >nul 2>&1
powershell.exe -c "mkdir '%PORT%'"    >nul 2>&1
powershell.exe -c "mkdir '%SCRIPTS%'"    >nul 2>&1
powershell.exe -c "mkdir '%FILETEMP%'"    >nul 2>&1
powershell.exe -c "mkdir '%SCRCPY%'"    >nul 2>&1
powershell.exe -c "mkdir '%MTKCLI%'"    >nul 2>&1
attrib.exe +h +s "%SCRIPTS%"
attrib.exe +h +s "%FILETEMP%"
cls
echo Done
if not exist "%FILETEMP%\mtkdriv.exe" (
    echo Downloading Resources..
    powershell.exe -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri '%BASEURL%/DriverInstall.exe' -OutFile '%FILETEMP%\mtkdriv.exe'" >nul 2>&1
    cls
    goto Driverexist
)else (
echo Downloading Resources..
timeout /t 1 >nul 
cls
goto Driverexist 
)
:Driverexist
if not exist "%FILETEMP%\UsbDk.msi" (
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto 64
if not "%PROCESSOR_ARCHITEW6432%"=="" goto 64
goto 32
:64
echo Downloading Resources...
powershell.exe -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/daynix/UsbDk/releases/download/v1.00-22/UsbDk_1.0.22_x64.msi' -OutFile '%FILETEMP%\UsbDk.msi'" >nul 2>&1 
cls
goto z
:32
echo Downloading Resources...
powershell.exe -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/daynix/UsbDk/releases/download/v1.00-22/UsbDk_1.0.22_x86.msi' -OutFile '%FILETEMP%\UsbDk.msi'" >nul 2>&1 
cls
goto z
:z
goto Driverexist1
)else (
goto Driverexist1 
)
:Driverexist1
cls
echo Checking if Python is installed ...
python --version >nul 2>&1
if %errorlevel%==0 goto pythonf

echo No Python installed, downloading...
powershell.exe -NoLogo -NoProfile -Command ^
    "$url = (Invoke-WebRequest -UseBasicParsing 'https://www.python.org/downloads/').Links | Where-Object { $_.href -match '/ftp/python/.*/python-.*-amd64.exe' } | Select-Object -First 1 -ExpandProperty href; Invoke-WebRequest $url -OutFile '%PYTHON_EXE%'" >nul 2>&1
echo Installing Python...
start "" /wait "%PYTHON_EXE%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 >nul 2>&1
echo Deleting Python Installer resources...
del "%PYTHON_EXE%" >nul 2>&1
timeout /t 3 >nul
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path ^| find "Path"') do set "PATH=%%B"
timeout /t 3 >nul
:installedpython
echo Python is sucessfully installed now .
echo Rebooting the script ...
start cmd.exe /c "powershell -WindowStyle Minimized -Command "Start-Sleep -Seconds 0" && timeout /t 3 >nul && start %scriptPath%T-Dumper.bat"
exit
timeout /t 3 >nul

:pythonf
cls
echo Detecting python path
powershell.exe -c "Get-ChildItem "$env:ProgramFiles","${env:ProgramFiles(x86)}" -Directory *python3* | Select-Object -First 1 -ExpandProperty FullName" > "%ROOT%\test.txt" && for /f "usebackq delims=" %%i in ("%ROOT%\test.txt") do (
    set pythondir=%%i
    echo !pythondir!
)
timeout /t 2 >nul
cls
if exist "%SystemRoot%\System32\python3.exe" (
    echo Removing old symlink ...
    del %SystemRoot%\System32\python3.exe /q && echo Done
    timeout /t 2 >nul
    cls
)
echo Setting symlink up ...
mklink "%SystemRoot%\System32\python3.exe" "%pythondir%\python.exe"
timeout /t 3 >nul
cls 
echo Done
cls
timeout /t 2 >nul
echo Downloading and extracting extra resources ...
if not exist "%MTKCLI%\mtkclient-main\mtk.py" (
powershell.exe -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/bkerler/mtkclient/archive/refs/heads/main.zip' -OutFile '%FILETEMP%\mtkclient.zip'" >nul 2>&1   
powershell.exe -c "Expand-Archive -Path '%FILETEMP%\mtkclient.zip' -DestinationPath '%MTKCLI%' -Force"
goto bridge
)else (
powershell.exe -c "mkdir '%MTKCLIOUT%'"    >nul 2>&1
goto bridge
)
:bridge
if not exist "%FTOOL%\SP_Flash_Tool_v5.1924_Win\flash_tool.exe" (
powershell.exe -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri 'https://spflashtools.com/wp-content/uploads/SP_Flash_Tool_v5.1924_Win.zip' -OutFile '%FILETEMP%\ftool.zip'" >nul 2>&1
powershell.exe -c "Expand-Archive -Path '%FILETEMP%\ftool.zip' -DestinationPath '%FTOOL%' -Force"
)
cls
echo  Checking if MTK or the UsbDk Drivers exist ...
timeout /t 2 >nul 
if not exist "%MTKCHECK%\mtk_etw_log.exe" (
    cls
    echo MTKDRIVER: NO
    echo N >"%FILETEMP%\mtkdriv.txt"
    goto check2
)else (
    echo MTKDRIVER: YES
    echo Y >"%FILETEMP%\mtkdriv.txt"
    goto check2
)

:check2
if not exist "%USBCHECK%\UsbDk.sys" (
    echo USBDKDRIVER: NO
    echo N >"%FILETEMP%\usbdkdriv.txt"
   timeout /t 2 >nul 
   goto go2
   
)else (
    echo USBDKDRIVER: YES
    echo Y >"%FILETEMP%\usbdkdriv.txt"
  timeout /t 2 >nul 
  goto go2
)

:go2
cls
set "tempFile1=%FILETEMP%\mtkdriv.txt"
set "tempFile2=%FILETEMP%\usbdkdriv.txt"

for /f "usebackq delims=" %%a in ("%tempFile1%") do set "inst1=%%a"
for /f "usebackq delims=" %%a in ("%tempFile2%") do set "inst2=%%a"
set "inst1=%inst1: =%"
set "inst2=%inst2: =%"

if /i "%inst1%"=="Y" if /i "%inst2%"=="Y" goto go


if /i "%inst1%"=="Y" (
   echo MTK Drivers are installed
) else if /i "%inst1%"=="N" (
   echo MTK Drivers are not installed , installing ...
   timeout /t 2 >nul
start "" /wait "%FILETEMP%\mtkdriv.exe"
cls
echo Done
timeout /t 2 >nul
) else (
   exit
)

if /i "%inst2%"=="Y" (
   echo UsbDk Drivers are installed
) else if /i "%inst2%"=="N" (
   msiexec /i "%FILETEMP%\UsbDk.msi" /qn /norestart
cls
echo Done
timeout /t 2 >nul

) else (
  exit
)

:reboot
cls
echo Adding Autostart script and rebooting ...
echo %scriptPath% >"%FILETEMP%\path.txt"
start cmd.exe /c "powershell -WindowStyle Minimized -Command "Start-Sleep -Seconds 1" && @echo off && echo Making final setup ... && timeout /t 2 >nul && xcopy "%FILETEMP%\T-Start.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\" /Y" && start cmd.exe /c "@echo off && echo Waiting until other steps are finished && timeout /t 9 && cls && echo Rebooting... && shutdown /r /t 1 "
exit

:go 
cls
echo Done
timeout /t 3 >nul
if "%~1"=="1" (
    goto vscodesuccess
)
cls
echo Downloading and installing VS Buildtools 
winget uninstall --id Microsoft.VisualStudio.2022.BuildTools 2>nul
winget uninstall --id Microsoft.VisualStudio.2019.BuildTools 2>nul 
winget uninstall --id Microsoft.VisualStudio.2017.BuildTools 2>nul 
winget install --id Microsoft.VisualStudio.2022.BuildTools --override "--passive --wait --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended --add Microsoft.VisualStudio.Component.Windows10SDK.19041" --accept-package-agreements --accept-source-agreements --wait --disable-interactivity 
echo Done 
timeout /t 2 >nul
cls
Installing Chocolatey for Openssl ...
del "C:\ProgramData\chocolatey" /q
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force" >nul 2>&1
powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
echo Done 
timeout /t 2 >nul
cls 
echo Installing Openssl ...
choco install openssl -y
echo Done
timeout /t 2 >nul
cls
echo Rebooting Script ...
timeout /t 2 >nul
start cmd.exe /c "powershell -WindowStyle Minimized -Command "Start-Sleep -Seconds 0" && timeout /t 3 >nul && start %scriptPath%T-Dumper.bat 1 "
exit

:vscodesuccess
cls
echo Setting mtkclient up ...
cd %MTKCLI%\mtkclient-main
pip3 install -r requirements.txt && echo. || echo OH that dont work && pause
timeout /t 2 >nul
pause