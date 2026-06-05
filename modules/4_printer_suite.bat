@echo off
echo.
echo === PRINTER REPAIR SUITE ===
echo.
echo [1/3] Resetting Print Spooler Service...
net stop spooler /y >nul 2>&1
echo Clearing stuck print jobs from queue...
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*" >nul 2>&1
net start spooler >nul 2>&1

echo.
echo [2/3] Printer Features Configuration...

:: Detect Windows version to determine Print to PDF availability
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

if "%VERSION%" GEQ "10.0" (
    echo Ensuring 'Microsoft Print to PDF' is enabled...
    Dism /Online /Enable-Feature /FeatureName:Printing-PrintToPDFServices-Features /NoRestart >nul 2>&1
) else (
    echo Note: Print to PDF is a Windows 10+ feature. Skipping on this system.
)

echo.
echo [3/3] Advanced Printer Management
echo This tool allows you to view and delete duplicate or ghost printers.
choice /c YN /m "Open interactive Printer Manager? (Y=Yes, N=Skip): "
if errorlevel 2 goto :SkipPrinterManager

:: =====================================================================
:: Generate the Interactive PowerShell Payload dynamically
:: (Using sequential echo avoids CMD's parenthetical parser crashes)
:: =====================================================================
set "PS_PAYLOAD=%TEMP%\fmw_printer_manager.ps1"

echo $ErrorActionPreference = 'SilentlyContinue' > "%PS_PAYLOAD%"
echo while ($true^) { >> "%PS_PAYLOAD%"
echo     Clear-Host >> "%PS_PAYLOAD%"
echo     Write-Host "=== PRINTER MANAGER ===" -ForegroundColor Cyan >> "%PS_PAYLOAD%"
echo     Write-Host "Fetching installed printers..." -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo     $printers = @(Get-WmiObject -Class Win32_Printer^) >> "%PS_PAYLOAD%"
echo     if (-not $printers^) { >> "%PS_PAYLOAD%"
echo         Write-Host "No printers found." -ForegroundColor Yellow >> "%PS_PAYLOAD%"
echo         Start-Sleep -Seconds 2 >> "%PS_PAYLOAD%"
echo         break >> "%PS_PAYLOAD%"
echo     } >> "%PS_PAYLOAD%"
echo     Write-Host "" >> "%PS_PAYLOAD%"
echo     $i = 1 >> "%PS_PAYLOAD%"
echo     foreach ($p in $printers^) { >> "%PS_PAYLOAD%"
echo         Write-Host "[$i] $($p.Name^)" -ForegroundColor White >> "%PS_PAYLOAD%"
echo         Write-Host "    Driver: $($p.DriverName^)" -ForegroundColor DarkGray >> "%PS_PAYLOAD%"
echo         $i++ >> "%PS_PAYLOAD%"
echo     } >> "%PS_PAYLOAD%"
echo     Write-Host "" >> "%PS_PAYLOAD%"
echo     Write-Host "[0] Exit to Menu" -ForegroundColor Green >> "%PS_PAYLOAD%"
echo     Write-Host "" >> "%PS_PAYLOAD%"
echo     $choice = Read-Host "Enter the number of the printer to REMOVE" >> "%PS_PAYLOAD%"
echo     if ($choice -eq '0' -or [string]::IsNullOrWhiteSpace($choice^)^) { break } >> "%PS_PAYLOAD%"
::       Legacy PowerShell 2.0 compatible integer check
echo     if ([int]::TryParse($choice, [ref]0^) -and $choice -gt 0 -and $choice -le $printers.Count^) { >> "%PS_PAYLOAD%"
echo         $target = $printers[$choice-1] >> "%PS_PAYLOAD%"
echo         Write-Host "Attempting to remove $($target.Name^)..." -ForegroundColor Yellow >> "%PS_PAYLOAD%"
echo         try { >> "%PS_PAYLOAD%"
echo             $target.Delete(^) ^| Out-Null >> "%PS_PAYLOAD%"
echo             Write-Host "Successfully removed." -ForegroundColor Green >> "%PS_PAYLOAD%"
echo         } catch { >> "%PS_PAYLOAD%"
echo             Write-Host "Failed to remove printer. It may be locked by a service." -ForegroundColor Red >> "%PS_PAYLOAD%"
echo         } >> "%PS_PAYLOAD%"
echo         Start-Sleep -Seconds 2 >> "%PS_PAYLOAD%"
echo     } >> "%PS_PAYLOAD%"
echo } >> "%PS_PAYLOAD%"

:: Execute the payload and clean up
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_PAYLOAD%"
del /q "%PS_PAYLOAD%" >nul 2>&1

:SkipPrinterManager
echo.
echo === PRINTER REPAIR COMPLETE ===
pause