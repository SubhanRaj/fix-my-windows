@echo off
echo.
echo === ADVANCED BOOT ^& SAFE MODE ===
echo.
echo Current Boot State:
bcdedit | findstr /i "safeboot" >nul 2>&1
if errorlevel 1 (
    echo [Normal Boot]
) else (
    echo [Safe Mode Staged]
)
echo.
echo [1] Stage 'Safe Mode with Networking' for next boot
echo [2] Revert to Normal Boot
echo [0] Return to Menu
echo.
choice /c 120 /n /m "Select option (1-2, 0): "

if errorlevel 3 goto :EOF
if errorlevel 2 goto :NormalBoot
if errorlevel 1 goto :SafeMode

:SafeMode
echo.
bcdedit /set {default} safeboot network >nul 2>&1
echo System is now staged to boot into Safe Mode with Networking.
echo.
choice /c YN /m "Restart the system immediately? "
if errorlevel 2 goto :EOF
shutdown /r /t 5 /f /c "fix-my-windows: Rebooting to Safe Mode..."
exit

:NormalBoot
echo.
bcdedit /deletevalue {default} safeboot >nul 2>&1
echo System restored to Normal Boot.
echo.
choice /c YN /m "Restart the system immediately? "
if errorlevel 2 goto :EOF
shutdown /r /t 5 /f /c "fix-my-windows: Rebooting to Normal Mode..."
exit