@echo off
TITLE fix-my-windows Diagnostic Toolkit
COLOR 0B

:: Elevate to Admin
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :MainMenu
) else (
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:MainMenu
cls
echo ========================================================
echo                 IT DIAGNOSTIC TOOLKIT
echo ========================================================
echo.
echo [1] Repair Windows OS (SFC / DISM)
echo [2] Safe Network Reset (Keeps Static IPs)
echo [3] Disk Check and Temp Cleanup
echo [4] Deep System Reboot
echo [Q] Quit
echo.

choice /c 1234Q /n /m "Select an option: "

if errorlevel 5 goto :EOF
if errorlevel 4 call ".\modules\4_reboot.bat"
if errorlevel 3 call ".\modules\3_disk_clean.bat"
if errorlevel 2 call ".\modules\2_network_safe.bat"
if errorlevel 1 call ".\modules\1_os_repair.bat"

goto :MainMenu
