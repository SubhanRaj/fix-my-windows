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

REM Detect Windows version to use appropriate audit method
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

if %VERSION% geq 10.0 (
    REM Windows 10+ - Use PowerShell Get-MpComputerStatus
    
    echo [DEFENDER ENGINE STATUS] >> "%DefenderReport%"
    powershell -Command "Get-MpComputerStatus | Select-Object -Property AntivirusEnabled, AntispywareEnabled, RealTimeProtectionEnabled, OnAccessProtectionEnabled, IoavProtectionEnabled, BehaviorMonitoringEnabled >> '%DefenderReport%'" 2>nul
    
    echo. >> "%DefenderReport%"
    echo [SIGNATURE UPDATES] >> "%DefenderReport%"
    powershell -Command "Get-MpComputerStatus | Select-Object -Property AntispywareSignatureLastUpdated, AntivirusSignatureLastUpdated >> '%DefenderReport%'" 2>nul
    
    echo. >> "%DefenderReport%"
    echo [THREAT DETECTION HISTORY] >> "%DefenderReport%"
    powershell -Command "Get-MpComputerStatus | Select-Object -Property TotalSuspiciousFilesDetected, TotalDetections >> '%DefenderReport%'" 2>nul
    
    echo.
    echo === SECURITY AUDIT COMPLETE (Windows 10+) ===
    echo Full report saved to: %DefenderReport%
    echo.
    echo Quick Status Check:
    echo.
    powershell -Command "Get-MpComputerStatus | Select-Object -Property AntivirusEnabled, RealTimeProtectionEnabled" 2>nul || echo [Unable to retrieve status - may require elevation]
    
) else (
    REM Windows 7-8.1 - Use WMIC fallback (Windows Defender exists but via different API)
    
    echo [SECURITY STATUS - WMIC METHOD] >> "%DefenderReport%"
    echo Note: Using WMI compatibility layer for Windows 7-8.1 >> "%DefenderReport%"
    echo. >> "%DefenderReport%"
    
    echo [INSTALLED ANTIVIRUS PRODUCTS] >> "%DefenderReport%"
    wmic /namespace:\\root\securitycenter2 path AntiVirusProduct get displayName, productState >> "%DefenderReport%" 2>nul
    
    echo. >> "%DefenderReport%"
    echo [INSTALLED FIREWALL PRODUCTS] >> "%DefenderReport%"
    wmic /namespace:\\root\securitycenter2 path FirewallProduct get displayName, productState >> "%DefenderReport%" 2>nul
    
    echo. >> "%DefenderReport%"
    echo [WINDOWS DEFENDER STATUS - via Registry] >> "%DefenderReport%"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender" >> "%DefenderReport%" 2>nul
    
    echo.
    echo === SECURITY AUDIT COMPLETE (Windows 7-8.1 Mode) ===
    echo Full report saved to: %DefenderReport%
    echo.
    echo Quick Status Check:
    echo.
    echo Note: Windows Defender status API is limited on Windows 7-8.1
    wmic /namespace:\\root\securitycenter2 path AntiVirusProduct get displayName 2>nul || echo [Unable to retrieve status]
)

echo.
pause
