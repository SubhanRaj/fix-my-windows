@echo off
echo.
echo === FIREWALL APPLICATION MANAGER ===
echo.
echo Initializing interactive module...

:: =====================================================================
:: Generate the Interactive PowerShell Payload dynamically
:: =====================================================================
set "PS_PAYLOAD=%TEMP%\fmw_firewall.ps1"

echo $ErrorActionPreference = 'SilentlyContinue' > "%PS_PAYLOAD%"
echo while ($true) { >> "%PS_PAYLOAD%"
echo     Clear-Host >> "%PS_PAYLOAD%"
echo     Write-Host "=== FIREWALL RULE MANAGER ===" -ForegroundColor Cyan >> "%PS_PAYLOAD%"
echo     Write-Host "Drag and drop an .exe file, OR drop a folder to scan for executables." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo     Write-Host "Type '0' to exit to Main Menu." -ForegroundColor Green >> "%PS_PAYLOAD%"
echo     Write-Host "" >> "%PS_PAYLOAD%"
echo     $inputPath = Read-Host "Enter Path" >> "%PS_PAYLOAD%"
::       Clean up quotes and rogue ampersands from Windows drag-and-drop
echo     $inputPath = $inputPath.Replace('"', '').Trim() >> "%PS_PAYLOAD%"
echo     if ($inputPath -eq '0' -or [string]::IsNullOrWhiteSpace($inputPath)) { break } >> "%PS_PAYLOAD%"
echo     if (-not (Test-Path $inputPath)) { Write-Host "Path not found!" -ForegroundColor Red; Start-Sleep -Seconds 2; continue } >> "%PS_PAYLOAD%"
echo     $item = Get-Item $inputPath >> "%PS_PAYLOAD%"
echo     $targetExe = "" >> "%PS_PAYLOAD%"
echo     if ($item.PSIsContainer) { >> "%PS_PAYLOAD%"
echo         Write-Host "Scanning folder for executables..." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo         $exes = @(Get-ChildItem -Path $inputPath -Filter "*.exe" -File) >> "%PS_PAYLOAD%"
echo         if (-not $exes) { Write-Host "No .exe files found in this directory." -ForegroundColor Yellow; Start-Sleep -Seconds 2; continue } >> "%PS_PAYLOAD%"
echo         $i = 1 >> "%PS_PAYLOAD%"
echo         Write-Host "`nFound Executables:" -ForegroundColor Cyan >> "%PS_PAYLOAD%"
echo         foreach ($exe in $exes) { >> "%PS_PAYLOAD%"
echo             Write-Host "[$i] $($exe.Name)" -ForegroundColor White >> "%PS_PAYLOAD%"
echo             $i++ >> "%PS_PAYLOAD%"
echo         } >> "%PS_PAYLOAD%"
echo         $choice = Read-Host "`nSelect an EXE (1-$($exes.Count)) or 0 to cancel" >> "%PS_PAYLOAD%"
echo         if ($choice -eq '0' -or -not [int]::TryParse($choice, [ref]0) -or $choice -lt 1 -or $choice -gt $exes.Count) { continue } >> "%PS_PAYLOAD%"
echo         $targetExe = $exes[$choice-1].FullName >> "%PS_PAYLOAD%"
echo     } else { >> "%PS_PAYLOAD%"
echo         if ($item.Extension -ne '.exe') { Write-Host "Please select a valid .exe file or a directory." -ForegroundColor Red; Start-Sleep -Seconds 2; continue } >> "%PS_PAYLOAD%"
echo         $targetExe = $item.FullName >> "%PS_PAYLOAD%"
echo     } >> "%PS_PAYLOAD%"
echo     Write-Host "`nTarget: $targetExe" -ForegroundColor Yellow >> "%PS_PAYLOAD%"
echo     $action = Read-Host "Do you want to [B]lock or [A]llow this app? (B/A)" >> "%PS_PAYLOAD%"
echo     if ($action -match '^[Bb]') { $actStr = "block"; $rulePrefix = "Blocked" } >> "%PS_PAYLOAD%"
echo     elseif ($action -match '^[Aa]') { $actStr = "allow"; $rulePrefix = "Allowed" } >> "%PS_PAYLOAD%"
echo     else { continue } >> "%PS_PAYLOAD%"
echo     $ruleName = "FMW $rulePrefix - $(Split-Path $targetExe -Leaf)" >> "%PS_PAYLOAD%"
echo     Write-Host "`nApplying Inbound Rule..." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo     netsh advfirewall firewall add rule name="$ruleName" dir=in action=$actStr program="$targetExe" enable=yes profile=any ^| Out-Null >> "%PS_PAYLOAD%"
echo     Write-Host "Applying Outbound Rule..." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo     netsh advfirewall firewall add rule name="$ruleName" dir=out action=$actStr program="$targetExe" enable=yes profile=any ^| Out-Null >> "%PS_PAYLOAD%"
echo     Write-Host "Success! $actStr rules created for $(Split-Path $targetExe -Leaf)." -ForegroundColor Green >> "%PS_PAYLOAD%"
echo     Start-Sleep -Seconds 2 >> "%PS_PAYLOAD%"
echo } >> "%PS_PAYLOAD%"

:: Execute the payload and clean up
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_PAYLOAD%"
del /q "%PS_PAYLOAD%" >nul 2>&1