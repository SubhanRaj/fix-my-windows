@echo off
:WifiMenu
cls
echo.
echo === WI-FI PROFILE MANAGER ===
echo.
echo [1] View All Saved Wi-Fi Profiles
echo [2] View Password for a Specific Network
echo [3] Bulk Export All Profiles ^& Passwords (to /Reports)
echo [4] Delete a Corrupted Wi-Fi Profile
echo [0] Return to Main Menu
echo.
choice /c 12340 /n /m "Select an option (1-4, 0): "

if errorlevel 5 goto :EOF
if errorlevel 4 goto :DeleteWifi
if errorlevel 3 goto :ExportWifi
if errorlevel 2 goto :ShowPassword
if errorlevel 1 goto :ListWifi

:ListWifi
echo.
echo === SAVED WI-FI PROFILES ===
netsh wlan show profiles
echo.
pause
goto :WifiMenu

:ShowPassword
echo.
set /p "wifiName=Enter the exact Wi-Fi Profile Name: "
echo.
echo Fetching Key Content for "%wifiName%"...
netsh wlan show profile name="%wifiName%" key=clear | findstr /R /C:"Key Content"
if errorlevel 1 echo Password not found, network is open, or profile does not exist.
echo.
pause
goto :WifiMenu

:ExportWifi
echo.
echo Exporting all Wi-Fi profiles to XML...
if not exist "%~dp0Reports\WiFi_Exports" mkdir "%~dp0Reports\WiFi_Exports"
netsh wlan export profile folder="%~dp0Reports\WiFi_Exports" key=clear >nul 2>&1
echo.
echo === EXPORT COMPLETE ===
echo Profiles and plaintext passwords saved to:
echo %~dp0Reports\WiFi_Exports
echo.
pause
goto :WifiMenu

:DeleteWifi
echo.
netsh wlan show profiles
echo.
set /p "delName=Enter the Profile Name to delete: "
netsh wlan delete profile name="%delName%"
echo.
pause
goto :WifiMenu