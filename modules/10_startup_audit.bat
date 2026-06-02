@echo off
echo.
echo === STARTUP PROGRAMS AUDIT ===
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "StartupReport=%ReportDir%\%COMPUTERNAME%_Startup.txt"

echo Generating startup programs report...
echo ======================================== > "%StartupReport%"
echo STARTUP PROGRAMS AUDIT FOR %COMPUTERNAME% >> "%StartupReport%"
echo ======================================== >> "%StartupReport%"
echo Generated: %date% %time% >> "%StartupReport%"
echo. >> "%StartupReport%"

echo [PROGRAMS IN STARTUP FOLDER] >> "%StartupReport%"
dir /b "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >> "%StartupReport%" 2>nul

echo. >> "%StartupReport%"
echo [REGISTRY STARTUP ENTRIES - HKLM\RUN] >> "%StartupReport%"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" >> "%StartupReport%" 2>nul

echo. >> "%StartupReport%"
echo [REGISTRY STARTUP ENTRIES - HKCU\RUN] >> "%StartupReport%"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" >> "%StartupReport%" 2>nul

echo.
echo === STARTUP AUDIT COMPLETE ===
echo Report saved to: %StartupReport%
echo.
echo COMMON BLOATWARE TO DISABLE:
echo   - McAfee, Norton, Avast, AVG (if using Windows Defender)
echo   - Dropbox, OneDrive (if not needed)
echo   - Spotify, Discord, Slack (if not required)
echo   - HP Smart, Canon Print (if not using printer)
echo.
echo To disable startup items:
echo   1. Press Win+R, type "msconfig"
echo   2. Go to Startup tab
echo   3. Uncheck unwanted programs
echo   4. Click OK and reboot
echo.
pause
