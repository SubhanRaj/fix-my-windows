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

echo.
echo [1/3] Resetting USB Host Controllers...

:: Detect Windows version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

:: CRITICAL FIX: Use GOTO instead of parenthetical IF blocks to completely bypass CMD parser crashes
if "%VERSION%" GEQ "10.0" goto :modern_win
goto :legacy_win

:modern_win
echo Windows 10/11 detected. Executing via safe PowerShell blocks...
:: Target the correct 'USB' class instead of 'System' to hit the hardware directly
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-PnpDevice -Class USB | Where-Object { $_.FriendlyName -like '*Host Controller*' } | Disable-PnpDevice -Confirm:$false" >nul 2>&1
timeout /t 2 >nul
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-PnpDevice -Class USB | Where-Object { $_.FriendlyName -like '*Host Controller*' } | Enable-PnpDevice -Confirm:$false" >nul 2>&1
goto :complete

:legacy_win
echo Windows 7/8.1 detected. Using DevCon method...
devcon disable "USB*" >nul 2>&1
timeout /t 2 >nul
devcon enable "USB*" >nul 2>&1
goto :complete

:complete
echo [2/3] Waiting for USB enumeration...
timeout /t 3 >nul

echo [3/3] Refreshing USB drivers...
pnputil /scan-devices >nul 2>&1

echo.
echo === USB RESET COMPLETE ===
echo USB controllers have been reset.
echo Reconnect USB devices now if needed.
echo.
pause