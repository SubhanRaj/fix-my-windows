@echo off
echo.
echo === WINDOWS LICENSE ^& ACTIVATION CHECK ===
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "LicenseReport=%ReportDir%\%COMPUTERNAME%_License.txt"

echo Checking Windows licensing and activation status...
echo ======================================== > "%LicenseReport%"
echo WINDOWS LICENSE AUDIT FOR %COMPUTERNAME% >> "%LicenseReport%"
echo ======================================== >> "%LicenseReport%"
echo Generated: %date% %time% >> "%LicenseReport%"
echo. >> "%LicenseReport%"

echo [ACTIVATION STATUS] >> "%LicenseReport%"
slmgr.vbs /dli >> "%LicenseReport%" 2>&1

echo. >> "%LicenseReport%"
echo [LICENSE STATUS] >> "%LicenseReport%"
slmgr.vbs /dlv >> "%LicenseReport%" 2>&1

echo. >> "%LicenseReport%"
echo [PRODUCT INFORMATION] >> "%LicenseReport%"
wmic os get caption, version, buildnumber, installdate >> "%LicenseReport%" 2>nul

echo. >> "%LicenseReport%"
echo [REGISTRY SERIAL NUMBER] >> "%LicenseReport%"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationId" >> "%LicenseReport%" 2>nul

echo.
echo === LICENSE AUDIT COMPLETE ===
echo Full report saved to: %LicenseReport%
echo.
echo Quick Status:
echo.
powershell -Command "Get-CimInstance -ClassName SoftwareLicensingProduct -Filter 'PartialProductKey !=null' | Select-Object -Property Name,LicenseStatus" 2>nul || slmgr.vbs /dli

echo.
echo NOTE: If license shows invalid, try running: slmgr.vbs /ato (Activate Windows)
echo.
pause
