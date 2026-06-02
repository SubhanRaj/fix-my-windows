@echo off
echo.
echo === WINDOWS DEFENDER HEALTH AUDIT ===
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "DefenderReport=%ReportDir%\%COMPUTERNAME%_Defender.txt"

echo Scanning system security status...
echo ======================================== > "%DefenderReport%"
echo WINDOWS DEFENDER AUDIT FOR %COMPUTERNAME% >> "%DefenderReport%"
echo ======================================== >> "%DefenderReport%"
echo Generated: %date% %time% >> "%DefenderReport%"
echo. >> "%DefenderReport%"

echo [DEFENDER ENGINE STATUS] >> "%DefenderReport%"
powershell -Command "Get-MpComputerStatus | Select-Object -Property AntivirusEnabled, AntispywareEnabled, RealTimeProtectionEnabled, OnAccessProtectionEnabled, IoavProtectionEnabled, BehaviorMonitoringEnabled >> '%DefenderReport%'" 2>nul

echo. >> "%DefenderReport%"
echo [SIGNATURE UPDATES] >> "%DefenderReport%"
powershell -Command "Get-MpComputerStatus | Select-Object -Property AntispywareSignatureLastUpdated, AntivirusSignatureLastUpdated >> '%DefenderReport%'" 2>nul

echo. >> "%DefenderReport%"
echo [THREAT DETECTION HISTORY] >> "%DefenderReport%"
powershell -Command "Get-MpComputerStatus | Select-Object -Property TotalSuspiciousFilesDetected, TotalDetections >> '%DefenderReport%'" 2>nul

echo.
echo === SECURITY AUDIT COMPLETE ===
echo Full report saved to: %DefenderReport%
echo.
echo Quick Status Check:
echo.
powershell -Command "Get-MpComputerStatus | Select-Object -Property AntivirusEnabled, RealTimeProtectionEnabled" 2>nul || echo [Unable to retrieve status - may require elevation]
echo.
pause
