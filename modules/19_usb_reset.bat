@echo off
echo.
echo === USB CONTROLLER RESET ===
echo.
echo This will reset USB controllers and hub drivers.
echo Useful for fixing undetected USB devices or USB ports.
echo.
echo WARNING: All USB devices will be temporarily disconnected.
echo.
choice /c YN /m "Reset USB controllers? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo [1/3] Disabling USB Universal Host Controller Interface...
    
    REM Detect Windows version for registry path differences
    for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
    
    if %VERSION% geq 10.0 (
        REM Windows 10+ method
        powershell -Command "Get-PnpDevice -Class System | Where-Object {$_.friendlyName -like '*USB*' -or $_.friendlyName -like '*Host Controller*'} | Disable-PnpDevice -Confirm:$false" >nul 2>&1
        timeout /t 2 >nul
        powershell -Command "Get-PnpDevice -Class System | Where-Object {$_.friendlyName -like '*USB*' -or $_.friendlyName -like '*Host Controller*'} | Enable-PnpDevice -Confirm:$false" >nul 2>&1
    ) else (
        REM Windows 7-8.1 method using device manager
        echo Windows 7-8.1 detected. Using device manager method...
        devcon disable "USB*" >nul 2>&1
        timeout /t 2 >nul
        devcon enable "USB*" >nul 2>&1
    )
    
    echo [2/3] Waiting for USB enumeration...
    timeout /t 3 >nul
    
    echo [3/3] Refreshing USB drivers...
    pnputil /scan-devices >nul 2>&1
    
    echo.
    echo === USB RESET COMPLETE ===
    echo USB controllers have been reset.
    echo Reconnect USB devices now if needed.
    echo.
    echo If USB devices still not detected:
    echo   1. Check Device Manager for unknown devices
    echo   2. Right-click and select "Update driver"
    echo   3. Update chipset drivers from motherboard vendor
)
pause
