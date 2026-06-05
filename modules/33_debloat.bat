@echo off
:DebloatMenu
cls
echo.
echo === SYSTEM DEBLOAT ^& OEM CLEANER ===
echo.
echo [1] Disable Windows Telemetry ^& Background Apps
echo [2] Interactive Appx Remover (Windows Store Bloatware)
echo [3] Interactive Software Uninstaller (McAfee, OEM Tools, etc.)
echo [0] Return to Main Menu
echo.
choice /c 1230 /n /m "Select an option (1-3, 0): "

if errorlevel 4 goto :EOF
if errorlevel 3 goto :TraditionalUninstall
if errorlevel 2 goto :AppxUninstall
if errorlevel 1 goto :StripTelemetry

:StripTelemetry
echo.
echo Disabling Telemetry and Background Apps...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo [SUCCESS] Telemetry stripped.
pause
goto :DebloatMenu

:AppxUninstall
:: Dynamically generate PowerShell payload for Appx
set "PS_PAYLOAD=%TEMP%\fmw_appx.ps1"
echo $ErrorActionPreference = 'SilentlyContinue' > "%PS_PAYLOAD%"
echo while ($true) { >> "%PS_PAYLOAD%"
echo     Clear-Host >> "%PS_PAYLOAD%"
echo     Write-Host "=== APPX BLOATWARE REMOVER ===" -ForegroundColor Cyan >> "%PS_PAYLOAD%"
echo     Write-Host "Fetching removable packages..." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo     $apps = @(Get-AppxPackage ^| Where-Object { $_.NonRemovable -eq $false } ^| Sort-Object Name) >> "%PS_PAYLOAD%"
echo     $i = 1 >> "%PS_PAYLOAD%"
echo     foreach ($app in $apps) { Write-Host "[$i] $($app.Name)" -ForegroundColor White; $i++ } >> "%PS_PAYLOAD%"
echo     Write-Host "`n[0] Return to Menu" -ForegroundColor Green >> "%PS_PAYLOAD%"
echo     $choice = Read-Host "`nEnter number to remove" >> "%PS_PAYLOAD%"
echo     if ($choice -eq '0' -or [string]::IsNullOrWhiteSpace($choice)) { break } >> "%PS_PAYLOAD%"
echo     if ([int]::TryParse($choice, [ref]0) -and $choice -gt 0 -and $choice -le $apps.Count) { >> "%PS_PAYLOAD%"
echo         $target = $apps[$choice-1] >> "%PS_PAYLOAD%"
echo         Write-Host "Removing $($target.Name)..." -ForegroundColor Yellow >> "%PS_PAYLOAD%"
echo         Remove-AppxPackage -Package $target.PackageFullName >> "%PS_PAYLOAD%"
echo         Write-Host "Done." -ForegroundColor Green >> "%PS_PAYLOAD%"
echo         Start-Sleep -Seconds 2 >> "%PS_PAYLOAD%"
echo     } >> "%PS_PAYLOAD%"
echo } >> "%PS_PAYLOAD%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_PAYLOAD%"
del /q "%PS_PAYLOAD%" >nul 2>&1
goto :DebloatMenu

:TraditionalUninstall
:: Dynamically generate PowerShell payload for WMI Win32_Product
set "PS_PAYLOAD=%TEMP%\fmw_wmi.ps1"
echo $ErrorActionPreference = 'SilentlyContinue' > "%PS_PAYLOAD%"
echo while ($true) { >> "%PS_PAYLOAD%"
echo     Clear-Host >> "%PS_PAYLOAD%"
echo     Write-Host "=== TRADITIONAL SOFTWARE UNINSTALLER ===" -ForegroundColor Cyan >> "%PS_PAYLOAD%"
echo     Write-Host "Scanning WMI for installed software (This takes a few seconds)..." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo     $progs = @(Get-WmiObject -Class Win32_Product ^| Sort-Object Name) >> "%PS_PAYLOAD%"
echo     $i = 1 >> "%PS_PAYLOAD%"
echo     foreach ($p in $progs) { Write-Host "[$i] $($p.Name) [$($p.Version)]" -ForegroundColor White; $i++ } >> "%PS_PAYLOAD%"
echo     Write-Host "`n[0] Return to Menu" -ForegroundColor Green >> "%PS_PAYLOAD%"
echo     $choice = Read-Host "`nEnter number to uninstall" >> "%PS_PAYLOAD%"
echo     if ($choice -eq '0' -or [string]::IsNullOrWhiteSpace($choice)) { break } >> "%PS_PAYLOAD%"
echo     if ([int]::TryParse($choice, [ref]0) -and $choice -gt 0 -and $choice -le $progs.Count) { >> "%PS_PAYLOAD%"
echo         $target = $progs[$choice-1] >> "%PS_PAYLOAD%"
echo         Write-Host "Attempting silent uninstall of $($target.Name)..." -ForegroundColor Yellow >> "%PS_PAYLOAD%"
echo         $target.Uninstall() ^| Out-Null >> "%PS_PAYLOAD%"
echo         Write-Host "Uninstall command sent." -ForegroundColor Green >> "%PS_PAYLOAD%"
echo         Start-Sleep -Seconds 3 >> "%PS_PAYLOAD%"
echo     } >> "%PS_PAYLOAD%"
echo } >> "%PS_PAYLOAD%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_PAYLOAD%"
del /q "%PS_PAYLOAD%" >nul 2>&1
goto :DebloatMenu