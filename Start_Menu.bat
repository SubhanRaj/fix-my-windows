@echo off
TITLE fix-my-windows Diagnostic Toolkit
COLOR 0B

:: Elevate to Admin
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :UnblockFiles
) else (
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:UnblockFiles
:: Strip the "Mark of the Web" to prevent silent execution blocks on modules
powershell -Command "Get-ChildItem -Path '%~dp0' -Recurse -File | Unblock-File" >nul 2>&1

:: FIX: Force the elevated prompt back to the script's actual directory
cd /d "%~dp0"

goto :MainMenu

:MainMenu
cls
echo ========================================================
echo                 IT DIAGNOSTIC TOOLKIT (PAGE 1/3)
echo ========================================================
echo.
echo === CORE SYSTEM REPAIR ===
echo [1] Repair Windows OS (SFC / DISM)
echo [2] Safe Network Reset (Keeps Static IPs)
echo [3] Disk Check and Temp Cleanup
echo [4] Printer Repair Suite (Spooler ^& Print to PDF)
echo [5] Hard Reset Windows Update Cache
echo [6] Install Runtimes (.NET Framework ^& VC++ Redists)
echo.
echo === BASIC SYSTEM AUDIT ===
echo [7] Export System Info ^& Battery Report
echo [8] Create System Restore Point
echo [9] Windows Defender Security Audit
echo [A] Startup Programs Audit
echo.
choice /c 123456789ANQ /n /m "Select (1-9, A) [N]ext or [Q]uit: "

if errorlevel 12 goto :EOF
if errorlevel 11 goto :MainMenu2
if errorlevel 10 call ".\modules\10_startup_audit.bat" & goto :MainMenu
if errorlevel 9 call ".\modules\9_defender_audit.bat" & goto :MainMenu
if errorlevel 8 call ".\modules\8_restore_point.bat" & goto :MainMenu
if errorlevel 7 call ".\modules\7_sys_info.bat" & goto :MainMenu
if errorlevel 6 call ".\modules\6_runtimes_installer.bat" & goto :MainMenu
if errorlevel 5 call ".\modules\5_update_reset.bat" & goto :MainMenu
if errorlevel 4 call ".\modules\4_printer_suite.bat" & goto :MainMenu
if errorlevel 3 call ".\modules\3_disk_clean.bat" & goto :MainMenu
if errorlevel 2 call ".\modules\2_network_safe.bat" & goto :MainMenu
if errorlevel 1 call ".\modules\1_os_repair.bat" & goto :MainMenu

goto :MainMenu

:MainMenu2
cls
echo ========================================================
echo                 IT DIAGNOSTIC TOOLKIT (PAGE 2/3)
echo ========================================================
echo.
echo === ADVANCED DIAGNOSTICS ===
echo [B] RAM Diagnostics (Memory Test)
echo [C] Registry Backup
echo [D] License ^& Activation Status
echo [E] Audio Reset
echo [F] Event Viewer Error Export
echo [G] Scheduled Tasks Audit
echo.
choice /c BCDEFGPNQ /n /m "Select (B-G) [P]revious [N]ext or [Q]uit: "

if errorlevel 9 goto :EOF
if errorlevel 8 goto :MainMenu3
if errorlevel 7 goto :MainMenu
if errorlevel 6 call ".\modules\17_scheduled_tasks.bat" & goto :MainMenu2
if errorlevel 5 call ".\modules\16_eventviewer_export.bat" & goto :MainMenu2
if errorlevel 4 call ".\modules\15_audio_reset.bat" & goto :MainMenu2
if errorlevel 3 call ".\modules\14_license_activation.bat" & goto :MainMenu2
if errorlevel 2 call ".\modules\13_registry_backup.bat" & goto :MainMenu2
if errorlevel 1 call ".\modules\12_ram_diagnostics.bat" & goto :MainMenu2

goto :MainMenu2

:MainMenu3
cls
echo ========================================================
echo                 IT DIAGNOSTIC TOOLKIT (PAGE 3/3)
echo ========================================================
echo.
echo === HARDWARE ^& SECURITY ===
echo [H] GPU ^& DirectX Diagnostics
echo [I] USB Controller Reset
echo [J] Display Settings Reset
echo [K] Bluetooth Troubleshooter
echo [L] UAC ^& Security Integrity Check
echo [M] SPPSVC Malware Repair (Error 577)
echo.
echo === NETWORKING ^& SHARING ===
echo [N] Network ^& File Sharing Setup
echo [O] Wi-Fi Profile Manager ^& Key Extractor
echo [T] Application Firewall Manager
echo [W] DNS Fast-Switcher ^& Hosts Manager
echo.
echo === SYSTEM CONTROL ^& RECOVERY ===
echo [U] Create WinPE Rescue USB
echo [V] Hardware Monitor (Portable / Install)
echo [R] Advanced Boot (Safe Mode Toggle)
echo [S] Deep System Reboot
echo.
:: Note: P=Previous, Q=Quit. Do not use them for modules.
choice /c HIJKLMNOTWUVRS PQ /n /m "Select (H-W) [P]revious or [Q]uit: "

if errorlevel 16 goto :EOF
if errorlevel 15 goto :MainMenu2
if errorlevel 14 call ".\modules\22_reboot.bat" & goto :MainMenu3
if errorlevel 13 call ".\modules\26_safe_mode.bat" & goto :MainMenu3
if errorlevel 12 call ".\modules\29_hardware_monitor.bat" & goto :MainMenu3
if errorlevel 11 call ".\modules\28_winpe_usb_creator.bat" & goto :MainMenu3
if errorlevel 10 call ".\modules\30_dns_manager.bat" & goto :MainMenu3
if errorlevel 9 call ".\modules\27_firewall_manager.bat" & goto :MainMenu3
if errorlevel 8 call ".\modules\25_wifi_manager.bat" & goto :MainMenu3
if errorlevel 7 call ".\modules\24_network_sharing.bat" & goto :MainMenu3
if errorlevel 6 call ".\modules\23_sppsvc_repair.bat" & goto :MainMenu3
if errorlevel 5 call ".\modules\22_uac_integrity.bat" & goto :MainMenu3
if errorlevel 4 call ".\modules\21_bluetooth_reset.bat" & goto :MainMenu3
if errorlevel 3 call ".\modules\20_display_reset.bat" & goto :MainMenu3
if errorlevel 2 call ".\modules\19_usb_reset.bat" & goto :MainMenu3
if errorlevel 1 call ".\modules\18_gpu_directx.bat" & goto :MainMenu3

goto :MainMenu3