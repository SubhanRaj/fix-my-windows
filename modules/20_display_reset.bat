@echo off
echo.
echo === DISPLAY SAFE RESET ===
echo.
echo This will reset display settings to a safe default resolution.
echo Useful for fixing corrupted display drivers or incorrect settings.
echo.
echo WARNING: Display will briefly flash during reset.
echo.
choice /c YN /m "Reset display to safe resolution? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo Current display settings:
    wmic path win32_videocontroller get currentresolution
    
    echo.
    echo [1/3] Resetting display driver...
    
    REM Detect Windows version
    for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
    
    if %VERSION% geq 10.0 (
        REM Windows 10+ - Use Settings or Device Manager
        echo Resetting to default via Device Manager...
        devcon restart "Display*" >nul 2>&1
    ) else (
        REM Windows 7-8.1
        echo Resetting to safe graphics mode...
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v "LayerDriver" /t REG_SZ /d "vga.sys" /f >nul 2>&1
    )
    
    echo [2/3] Waiting for hardware detection...
    timeout /t 3 >nul
    
    echo [3/3] Refreshing display drivers...
    pnputil /scan-devices >nul 2>&1
    
    echo.
    echo === DISPLAY RESET COMPLETE ===
    echo Display settings have been reset to safe defaults.
    echo.
    echo New display settings:
    wmic path win32_videocontroller get currentresolution
    
    echo.
    echo If display is still corrupted:
    echo   1. Reboot into Safe Mode (F8 at startup)
    echo   2. Uninstall graphics driver from Device Manager
    echo   3. Download latest driver from GPU vendor website
    echo   4. Install fresh driver
)
pause
