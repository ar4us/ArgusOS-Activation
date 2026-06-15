@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title ArgusOS Activation v1.0
cd /d "%~dp0"

set "VERSION=1.0"
set "PROJECT=ArgusOS Activation"
set "MAS_REPO=https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master"

:: ========== CHECK ADMIN ==========
fltmc >nul 2>&1 || (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs" >nul 2>&1
    exit /b
)

:: ========== CHECK WINDOWS VERSION ==========
set winbuild=1
for /f "tokens=2 delims=[]" %%G in ('ver') do for /f "tokens=2,3,4 delims=. " %%H in ("%%~G") do set "winbuild=%%J"
if %winbuild% LSS 10240 (
    cls
    echo ArgusOS Activation v%VERSION%
    echo ================================
    echo Unsupported OS version.
    echo HWID requires Windows 10/11.
    echo Use KMS for older versions.
    pause
    exit /b
)

:: ========== DETECT OS ==========
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do set "winos=%%b"
if %winbuild% GEQ 22000 set winos=!winos:Windows 10=Windows 11!
echo "%winos%" | find /i "Windows" >nul || set winos=Windows %winbuild%

:: ========== DETECT OFFICE ==========
set office_detected=
for %%v in (16.0 15.0 14.0) do (
    if exist "%ProgramFiles%\Microsoft Office\Office%%v\WINWORD.EXE" set office_detected=1
    if exist "%ProgramFiles(x86)%\Microsoft Office\Office%%v\WINWORD.EXE" set office_detected=1
)
if not defined office_detected (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" /v ProductReleaseIds 2^>nul') do set office_detected=1
)

:: ========== COLOR SETUP ==========
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
set "Red=41;97m"
set "Green=42;97m"
set "Blue=44;97m"
set "Yellow=43;97m"
set "Cyan=46;97m"
set "White=107;30m"

:menu
cls
echo.
echo %esc%[%Green%  ========================================================%esc%[0m
echo %esc%[%Green%  %esc%[0m
echo %esc%[%Cyan%           AAA                                         %esc%[0m
echo %esc%[%Cyan%          AAAAA   rrrrr   gggggg  uu   uu  sssss       %esc%[0m
echo %esc%[%Cyan%         AA   AA  rr  rr  gg   gg uu   uu ss   s      %esc%[0m
echo %esc%[%Cyan%        AAAAAAAAA rrrrrr  ggggggg uu   uu ssssss      %esc%[0m
echo %esc%[%Cyan%        AA   AA  rr  rr  gg   gg uu   uu    ss      %esc%[0m
echo %esc%[%Cyan%        AA   AA  rr   rr  gggggg   uuuuu  sssss      %esc%[0m
echo %esc%[%Cyan%                                                     %esc%[0m
echo %esc%[%Green%  %esc%[0m
echo %esc%[%Green%  ========================================================%esc%[0m
echo %esc%[%Yellow%             ArgusOS Activation v%VERSION%         %esc%[0m
echo %esc%[%Yellow%          Windows ^& Office Activator              %esc%[0m
echo %esc%[%Green%  ========================================================%esc%[0m
echo.
echo %esc%[%Green%  [1] HWID Activation        Windows 10/11 Permanent%esc%[0m
echo %esc%[%Green%  [2] Ohook Activation       Office (All Versions)%esc%[0m
echo %esc%[%Green%  [3] Online KMS Activation  Windows + Office 180d%esc%[0m
echo.
echo %esc%[%Blue%  [4] Check Activation Status%esc%[0m
echo %esc%[%Blue%  [5] Troubleshooting%esc%[0m
echo.
echo %esc%[%Red%  [0] Exit%esc%[0m
echo.
echo %esc%[%Yellow%  OS: %winos% %esc%[0m
if defined office_detected echo %esc%[%Yellow%  Office: Installed %esc%[0m
echo.
set /p "choice= Select option [0-5]: "

if "%choice%"=="1" goto hwid
if "%choice%"=="2" goto ohook
if "%choice%"=="3" goto onlinekms
if "%choice%"=="4" goto checkstatus
if "%choice%"=="5" goto troubleshoot
if "%choice%"=="0" exit /b
goto menu

:: =====================================================================
:: HWID ACTIVATION - Windows 10/11 Digital License (Permanent)
:: =====================================================================
:hwid
cls
echo.
echo %esc%[%Cyan%  =============================================%esc%[0m
echo %esc%[%Cyan%         HWID Activation                        %esc%[0m
echo %esc%[%Cyan%    Windows 10/11 Digital License               %esc%[0m
echo %esc%[%Cyan%  =============================================%esc%[0m
echo.
echo %esc%[%Yellow%  [!] Internet required for this method%esc%[0m
echo.

:: Check internet
set _int=
for %%a in (l.root-servers.net google.com) do if not defined _int (
    for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do if not "%%#"=="" set _int=1
)
if not defined _int (
    echo %esc%[%Red%  [ERROR] No internet connection detected%esc%[0m
    echo %esc%[%Blue%  HWID activation requires internet.%esc%[0m
    pause
    goto menu
)

echo %esc%[%Blue%  [*] Downloading HWID module from MAS...%esc%[0m

:: Download the MAS HWID activator and run it
set "hwid_temp=%temp%\ArgusOS_HWID_Activation.cmd"
powershell -Command "try { Invoke-WebRequest -Uri '%MAS_REPO%/MAS/Separate-Files-Version/Activators/HWID_Activation.cmd' -OutFile '%hwid_temp%' -UseBasicParsing; exit 0 } catch { exit 1 }" >nul 2>&1

if not exist "%hwid_temp%" (
    echo %esc%[%Red%  [ERROR] Failed to download HWID module%esc%[0m
    pause
    goto menu
)

echo %esc%[%Green%  [G£ô] HWID module downloaded%esc%[0m
echo %esc%[%Yellow%  [!] The MAS HWID script will now run.%esc%[0m
echo %esc%[%Yellow%  [!] Follow its instructions to activate.%esc%[0m
echo.
pause
call "%hwid_temp%"

if exist "%hwid_temp%" del /f /q "%hwid_temp%" >nul 2>&1

echo.
pause
goto menu

:: =====================================================================
:: OHOOK ACTIVATION - Office Activation (Permanent via DLL hook)
:: =====================================================================
:ohook
cls
echo.
echo %esc%[%Cyan%  =============================================%esc%[0m
echo %esc%[%Cyan%         Ohook Activation                       %esc%[0m
echo %esc%[%Cyan%    Office Permanent Activation                 %esc%[0m
echo %esc%[%Cyan%  =============================================%esc%[0m
echo.
echo %esc%[%Yellow%  [!] Internet required%esc%[0m
echo.

:: Check internet
set _int=
for %%a in (l.root-servers.net google.com) do if not defined _int (
    for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%a') do if not "%%#"=="" set _int=1
)
if not defined _int (
    echo %esc%[%Red%  [ERROR] No internet connection detected%esc%[0m
    pause
    goto menu
)

echo %esc%[%Blue%  [*] Downloading Ohook module from MAS...%esc%[0m

:: Download the MAS Ohook activator
set "ohook_temp=%temp%\ArgusOS_Ohook_Activation.cmd"
powershell -Command "try { Invoke-WebRequest -Uri '%MAS_REPO%/MAS/Separate-Files-Version/Activators/Ohook_Activation_AIO.cmd' -OutFile '%ohook_temp%' -UseBasicParsing; exit 0 } catch { exit 1 }" >nul 2>&1

if not exist "%ohook_temp%" (
    echo %esc%[%Red%  [ERROR] Failed to download Ohook module%esc%[0m
    pause
    goto menu
)

echo %esc%[%Green%  [G£ô] Ohook module downloaded%esc%[0m
echo %esc%[%Yellow%  [!] The MAS Ohook script will now run.%esc%[0m
echo %esc%[%Yellow%  [!] Follow its instructions to activate Office.%esc%[0m
echo.
pause
call "%ohook_temp%"

if exist "%ohook_temp%" del /f /q "%ohook_temp%" >nul 2>&1

echo.
pause
goto menu

:: =====================================================================
:: ONLINE KMS ACTIVATION - Windows/Office 180-day renewable
:: =====================================================================
:onlinekms
cls
echo.
echo %esc%[%Cyan%  =============================================%esc%[0m
echo %esc%[%Cyan%       Online KMS Activation                    %esc%[0m
echo %esc%[%Cyan%    Windows + Office - 180 Days Auto-Renew      %esc%[0m
echo %esc%[%Cyan%  =============================================%esc%[0m
echo.
echo %esc%[%Yellow%  [!] Internet required%esc%[0m
echo.
echo  Select target:
echo.
echo %esc%[%Green%  [1] Activate Windows%esc%[0m
echo %esc%[%Green%  [2] Activate Office%esc%[0m
echo %esc%[%Green%  [3] Activate Both (Windows + Office)%esc%[0m
echo %esc%[%Red%  [0] Back to Main Menu%esc%[0m
echo.
set /p "kms_choice= Select [0-3]: "

if "%kms_choice%"=="1" goto kmswin
if "%kms_choice%"=="2" goto kmsoffice
if "%kms_choice%"=="3" goto kmsboth
if "%kms_choice%"=="0" goto menu
goto onlinekms

:kmswin
call :do_kmswin
goto kmsdone

:kmsoffice
call :do_kmsoffice
goto kmsdone

:kmsboth
call :do_kmswin
call :do_kmsoffice
goto kmsdone

:do_kmswin
echo.
echo %esc%[%Blue%  [*] Installing Windows GVLK key...%esc%[0m
call :install_gvlk
echo %esc%[%Blue%  [*] Configuring KMS server...%esc%[0m
call :set_kms_server
echo %esc%[%Blue%  [*] Activating Windows...%esc%[0m
cscript //nologo %windir%\system32\slmgr.vbs /ato >nul 2>&1
call :check_win_activation
call :create_renewal_task Windows
goto :eof

:do_kmsoffice
echo.
echo %esc%[%Blue%  [*] Detecting Office...%esc%[0m
set office_found=
for %%v in (16.0 15.0 14.0) do (
    set "ospp_path=%ProgramFiles%\Microsoft Office\Office%%v\OSPP.VBS"
    if not exist "!ospp_path!" set "ospp_path=%ProgramFiles(x86)%\Microsoft Office\Office%%v\OSPP.VBS"
    if exist "!ospp_path!" (
        set office_found=1
        echo %esc%[%Blue%  [*] Installing Office volume key...%esc%[0m
        cscript //nologo "!ospp_path!" /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul 2>&1
        cscript //nologo "!ospp_path!" /sethst:kms.srv.crsoo.com >nul 2>&1
        cscript //nologo "!ospp_path!" /setprt:1688 >nul 2>&1
        echo %esc%[%Blue%  [*] Activating Office...%esc%[0m
        cscript //nologo "!ospp_path!" /act >nul 2>&1
    )
)
if not defined office_found echo %esc%[%Red%  [G£ù] Office not found%esc%[0m
call :create_renewal_task Office
goto :eof

:kmsdone
echo.
echo %esc%[%Green%  [G£ô] KMS activation process complete!%esc%[0m
echo %esc%[%Yellow%  A scheduled task will auto-renew every 7 days%esc%[0m
pause
goto menu

:: =====================================================================
:: CHECK ACTIVATION STATUS
:: =====================================================================
:checkstatus
cls
echo.
echo %esc%[%Cyan%  =============================================%esc%[0m
echo %esc%[%Cyan%        Activation Status Check                %esc%[0m
echo %esc%[%Cyan%  =============================================%esc%[0m
echo.
echo %esc%[%Blue%  Windows Status:%esc%[0m
cscript //nologo %windir%\system32\slmgr.vbs /xpr 2>nul | findstr /v "ERROR"
cscript //nologo %windir%\system32\slmgr.vbs /dli 2>nul | findstr /i "description status"
echo.

:: Check Office
set osp_found=
for %%v in (16.0 15.0 14.0) do (
    if exist "%ProgramFiles%\Microsoft Office\Office%%v\OSPP.VBS" set "osp_path=%ProgramFiles%\Microsoft Office\Office%%v\OSPP.VBS"&set osp_found=1
    if exist "%ProgramFiles(x86)%\Microsoft Office\Office%%v\OSPP.VBS" set "osp_path=%ProgramFiles(x86)%\Microsoft Office\Office%%v\OSPP.VBS"&set osp_found=1
)
if defined osp_found (
    echo %esc%[%Blue%  Office Status:%esc%[0m
    cscript //nologo "%osp_path%" /dstatus 2>nul | findstr /i "license"
) else (
    echo %esc%[%Yellow%  Office: Not detected%esc%[0m
)
echo.
pause
goto menu

:: =====================================================================
:: TROUBLESHOOTING
:: =====================================================================
:troubleshoot
cls
echo.
echo %esc%[%Cyan%  =============================================%esc%[0m
echo %esc%[%Cyan%         Troubleshooting Tools                 %esc%[0m
echo %esc%[%Cyan%  =============================================%esc%[0m
echo.
echo %esc%[%Green%  [1] Reset Windows Activation%esc%[0m
echo %esc%[%Green%  [2] Reset Office Activation%esc%[0m
echo %esc%[%Green%  [3] Check Services%esc%[0m
echo %esc%[%Green%  [4] Fix Licensing (Reinstall tokens)%esc%[0m
echo %esc%[%Red%  [0] Back to Menu%esc%[0m
echo.
set /p "tch= Select [0-4]: "

if "%tch%"=="1" (
    echo %esc%[%Yellow%  [*] Resetting Windows activation...%esc%[0m
    cscript //nologo %windir%\system32\slmgr.vbs /upk >nul 2>&1
    cscript //nologo %windir%\system32\slmgr.vbs /cpky >nul 2>&1
    cscript //nologo %windir%\system32\slmgr.vbs /rearm >nul 2>&1
    echo %esc%[%Green%  [G£ô] Windows activation reset%esc%[0m
    echo %esc%[%Yellow%  Reboot required%esc%[0m
    pause
    goto troubleshoot
)
if "%tch%"=="2" goto resetoffice
if "%tch%"=="3" (
    echo.
    for %%s in (sppsvc ClipSVC LicenseManager Winmgmt wlidsvc) do (
        sc query %%s | find "RUNNING" >nul && echo %esc%[%Green%  [G£ô] %%s - Running%esc%[0m || echo %esc%[%Red%  [G£ù] %%s - Stopped%esc%[0m
    )
    pause
    goto troubleshoot
)
if "%tch%"=="4" (
    echo %esc%[%Yellow%  [*] Reinstalling Windows licensing files...%esc%[0m
    if exist "%windir%\system32\spp\tokens\skus" (
        for /r "%windir%\system32\spp\tokens\skus" %%f in (*.xrm-ms) do (
            cscript //nologo %windir%\system32\slmgr.vbs /ilc "%%f" >nul 2>&1
        )
        echo %esc%[%Green%  [G£ô] Licensing files reinstalled%esc%[0m
    )
    pause
    goto troubleshoot
)
if "%tch%"=="0" goto menu
goto troubleshoot

:resetoffice
set "osp_path="
for %%v in (16.0 15.0 14.0) do (
    if exist "%ProgramFiles%\Microsoft Office\Office%%v\OSPP.VBS" set "osp_path=%ProgramFiles%\Microsoft Office\Office%%v\OSPP.VBS"
    if exist "%ProgramFiles(x86)%\Microsoft Office\Office%%v\OSPP.VBS" set "osp_path=%ProgramFiles(x86)%\Microsoft Office\Office%%v\OSPP.VBS"
)
if defined osp_path (
    echo %esc%[%Yellow%  [*] Resetting Office activation...%esc%[0m
    cscript //nologo "%osp_path%" /dstatus >nul 2>&1
    for /f "tokens=2" %%a in ('cscript //nologo "%osp_path%" /dstatus 2^>nul ^| find "Last 5"') do (
        cscript //nologo "%osp_path%" /unpkey:%%a >nul 2>&1
    )
    cscript //nologo "%osp_path%" /rearm >nul 2>&1
    echo %esc%[%Green%  [G£ô] Office activation reset%esc%[0m
)
pause
goto troubleshoot

:: =====================================================================
:: UTILITY FUNCTIONS
:: =====================================================================

:install_gvlk
:: Install generic volume license key for current Windows edition
set key_installed=0

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID 2^>nul') do set edition=%%a

:: Map edition to GVLK
if /i "%edition%"=="Professional" set gvlk=W269N-WFGWX-YVC9B-4J6C9-T83GX
if /i "%edition%"=="ProfessionalN" set gvlk=MH37W-N47XK-V7XM9-C7227-GCQG9
if /i "%edition%"=="ProfessionalEducation" set gvlk=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB
if /i "%edition%"=="ProfessionalEducationN" set gvlk=GJTYN-HDMQY-FRR76-HVGC7-QPF8Q
if /i "%edition%"=="ProfessionalWorkstation" set gvlk=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
if /i "%edition%"=="ProfessionalWorkstationN" set gvlk=9FNHH-K3HBT-3W4TD-6383H-6XYWF
if /i "%edition%"=="Enterprise" set gvlk=NPPR9-FWDCX-D2C8J-H872K-2YT43
if /i "%edition%"=="EnterpriseN" set gvlk=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
if /i "%edition%"=="EnterpriseS" set gvlk=FWN7H-PF93Q-4GGP8-M8RF3-MDWWW
if /i "%edition%"=="EnterpriseSN" set gvlk=GTP8N-RX2J8-F9J7T-V7B4J-69G48
if /i "%edition%"=="Education" set gvlk=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
if /i "%edition%"=="EducationN" set gvlk=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
if /i "%edition%"=="Core" set gvlk=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
if /i "%edition%"=="CoreN" set gvlk=3KHY7-WNT83-DGQKR-F7HPR-844BM
if /i "%edition%"=="CoreCountrySpecific" set gvlk=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
if /i "%edition%"=="CoreSingleLanguage" set gvlk=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH

if defined gvlk (
    cscript //nologo %windir%\system32\slmgr.vbs /ipk %gvlk% >nul 2>&1
    if !errorlevel! EQU 0 (
        echo %esc%[%Green%  [G£ô] GVLK key installed: %gvlk%%esc%[0m
        set key_installed=1
    ) else (
        echo %esc%[%Yellow%  [!] Generic key failed, trying alternative...%esc%[0m
    )
)

:: Fallback: try common keys
if %key_installed% EQU 0 (
    for %%k in (W269N-WFGWX-YVC9B-4J6C9-T83GX TX9XD-98N7V-6WMQ6-BX7FG-H8Q99) do (
        cscript //nologo %windir%\system32\slmgr.vbs /ipk %%k >nul 2>&1
        if !errorlevel! EQU 0 (
            echo %esc%[%Green%  [G£ô] Fallback key installed: %%k%esc%[0m
            goto :eof
        )
    )
    echo %esc%[%Red%  [G£ù] Could not find matching GVLK key%esc%[0m
    exit /b 1
)
exit /b 0

:set_kms_server
:: Configure KMS server
set "kms_list=kms.srv.crsoo.com kms.chinamacale.com kms.digiboy.ir kms.nettop01.com 45.155.169.75"
set kms_selected=
for %%s in (%kms_list%) do (
    if not defined kms_selected (
        for /f "delims=[] tokens=2" %%# in ('ping -n 1 %%s 2^>nul') do if not "%%#"=="" set kms_selected=%%s
    )
)
if not defined kms_selected set kms_selected=kms.srv.crsoo.com

echo %esc%[%Blue%  [*] Using KMS server: %kms_selected%%esc%[0m
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v KeyManagementServiceName /t REG_SZ /d "%kms_selected%" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v KeyManagementServicePort /t REG_SZ /d "1688" /f >nul 2>&1
goto :eof

:check_win_activation
cscript //nologo %windir%\system32\slmgr.vbs /xpr 2>nul | findstr /i "permanently" >nul 2>&1
if %errorlevel% EQU 0 (
    echo %esc%[%Green%  [G£ô] Windows is permanently activated%esc%[0m
) else (
    cscript //nologo %windir%\system32\slmgr.vbs /xpr 2>nul | findstr /i "days" >nul 2>&1
    if !errorlevel! EQU 0 (
        for /f "delims=" %%a in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr 2^>nul ^| find "days"') do echo %esc%[%Green%  [G£ô] %%a%esc%[0m
    ) else (
        echo %esc%[%Red%  [G£ù] Activation status unknown%esc%[0m
    )
)
goto :eof

:create_renewal_task
set "task_name=ArgusOS Activation Renewal %~1"
set "task_path=%ProgramData%\ArgusOS"
if not exist "%task_path%" md "%task_path%"

:: Create renewal script
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo :: ArgusOS Auto-Renewal Task
echo.
echo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v KeyManagementServiceName /t REG_SZ /d "kms.srv.crsoo.com" /f ^>nul 2^>^&1
echo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v KeyManagementServicePort /t REG_SZ /d "1688" /f ^>nul 2^>^&1
echo cscript //nologo %%windir%%\system32\slmgr.vbs /ato ^>nul 2^>^&1
echo.
echo for %%%%v in (16.0 15.0 14.0) do (
echo     if exist "%%ProgramFiles%%%%\Microsoft Office\Office%%%%v\OSPP.VBS" (
echo         cscript //nologo "%%ProgramFiles%%%%\Microsoft Office\Office%%%%v\OSPP.VBS" /sethst:kms.srv.crsoo.com ^>nul 2^>^&1
echo         cscript //nologo "%%ProgramFiles%%%%\Microsoft Office\Office%%%%v\OSPP.VBS" /act ^>nul 2^>^&1
echo     ^)
echo     if exist "%%ProgramFiles(x86)%%%%\Microsoft Office\Office%%%%v\OSPP.VBS" (
echo         cscript //nologo "%%ProgramFiles(x86)%%%%\Microsoft Office\Office%%%%v\OSPP.VBS" /sethst:kms.srv.crsoo.com ^>nul 2^>^&1
echo         cscript //nologo "%%ProgramFiles(x86)%%%%\Microsoft Office\Office%%%%v\OSPP.VBS" /act ^>nul 2^>^&1
echo     ^)
echo ^)
) > "%task_path%\renew_%~1.cmd"

:: Create scheduled task (runs every 7 days)
schtasks /create /tn "%task_name%" /tr "cmd.exe /c \"%task_path%\renew_%~1.cmd\"" /sc weekly /d SUN /st 09:00 /f >nul 2>&1
if %errorlevel% EQU 0 (
    echo %esc%[%Green%  [G£ô] Auto-renewal task created: Weekly on Sunday 9:00 AM%esc%[0m
) else (
    echo %esc%[%Yellow%  [!] Could not create scheduled task (run as admin)%esc%[0m
)
goto :eof


