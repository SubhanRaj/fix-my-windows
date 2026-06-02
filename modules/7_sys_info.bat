@echo off
echo.
echo === EXPORTING SYSTEM INFO ===
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "PCName=%COMPUTERNAME%"
set "ReportFile=%ReportDir%\%PCName%_Report.txt"

echo Generating Hardware Report for %PCName%...
echo ======================================== > "%ReportFile%"
echo SYSTEM INFORMATION FOR %PCName% >> "%ReportFile%"
echo ======================================== >> "%ReportFile%"
echo. >> "%ReportFile%"
echo [SERIAL NUMBER] >> "%ReportFile%"
wmic bios get serialnumber >> "%ReportFile%"
echo [OS VERSION] >> "%ReportFile%"
wmic os get Caption, Version >> "%ReportFile%"
echo [IP CONFIGURATION] >> "%ReportFile%"
ipconfig | findstr "IPv4" >> "%ReportFile%"

echo Generating Battery Report (HTML)...
powercfg /batteryreport /output "%ReportDir%\%PCName%_Battery.html" >nul 2>&1

echo.
echo === REPORTS SAVED TO /Reports FOLDER ===
echo Opening the reports directory for you now...
explorer.exe "%ReportDir%"
echo.
pause
