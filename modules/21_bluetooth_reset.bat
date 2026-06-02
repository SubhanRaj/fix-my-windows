@echo off
echo.
echo === BLUETOOTH TROUBLESHOOTER ===
echo.
echo This will reset Bluetooth services and drivers.
echo Useful for fixing Bluetooth connectivity issues.
echo.
choice /c YN /m "Reset Bluetooth services? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo [1/4] Stopping Bluetooth services...
    net stop bthserv /y >nul 2>&1
    
    echo [2/4] Clearing Bluetooth device cache...
    del /q /f /s "%PROGRAMDATA%\Microsoft\Windows\Bluetooth\*" >nul 2>&1
    
    echo [3/4] Clearing Bluetooth registry cache...
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Bluetooth" /v "LastProfileLoad" /f >nul 2>&1
    
    echo [4/4] Restarting Bluetooth service...
    net start bthserv >nul 2>&1
    
    echo.
    echo === BLUETOOTH RESET COMPLETE ===
    echo Bluetooth service has been restarted.
    echo.
    echo If Bluetooth still not working:
    echo   1. Remove Bluetooth devices from Settings ^> Devices ^> Bluetooth
    echo   2. Open Device Manager and look for Bluetooth adapter
    echo   3. Right-click and select "Update driver"
    echo   4. Download latest Bluetooth driver from system vendor
    echo   5. Re-pair Bluetooth devices
    echo.
    echo NOTE: Some systems may require a reboot for changes to take effect.
)
pause
