@echo off
echo.
echo === UAC INTEGRITY CHECK ===
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "UACReport=%ReportDir%\%COMPUTERNAME%_UAC_Integrity.txt"

echo Checking User Account Control integrity...
echo ======================================== > "%UACReport%"
echo UAC INTEGRITY AUDIT FOR %COMPUTERNAME% >> "%UACReport%"
echo ======================================== >> "%UACReport%"
echo Generated: %date% %time% >> "%UACReport%"
echo. >> "%UACReport%"

echo [UAC SETTINGS] >> "%UACReport%"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" >> "%UACReport%" 2>nul

echo. >> "%UACReport%"
echo [UAC CONSENT PROMPT LEVEL] >> "%UACReport%"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" >> "%UACReport%" 2>nul

echo. >> "%UACReport%"
echo [UAC PRIVILEGE ELEVATION] >> "%UACReport%"
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" >> "%UACReport%" 2>nul

echo. >> "%UACReport%"
echo [ADMIN ACCOUNTS] >> "%UACReport%"
net user >> "%UACReport%" 2>nul

echo. >> "%UACReport%"
echo [GROUP MEMBERSHIP] >> "%UACReport%"
net localgroup Administrators >> "%UACReport%" 2>nul

echo. >> "%UACReport%"
echo [SECURE BOOT STATUS] >> "%UACReport%"
powershell -Command "Get-SecureBootUEFI -Name *" >> "%UACReport%" 2>nul

echo.
echo === UAC INTEGRITY CHECK COMPLETE ===
echo Report saved to: %UACReport%
echo.
echo Summary:
echo   - UAC Status (Enabled/Disabled)
echo   - Admin Consent Prompt Level
echo   - Secure Desktop Prompts
echo   - Administrator Account List
echo.
echo UAC Levels:
echo   0 = Never notify
echo   1 = Notify on app changes (no desktop dimming)
echo   2 = Notify on app changes (with desktop dimming)
echo   3 = Always notify
echo.
pause
