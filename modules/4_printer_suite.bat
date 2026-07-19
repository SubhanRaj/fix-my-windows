@echo off
:PrinterMenu
cls
echo.
echo === PRINTER REPAIR SUITE ===
echo.
echo [1] Reset Print Spooler (clears stuck print jobs)
echo [2] Enable 'Microsoft Print to PDF' (Windows 10+)
echo [3] Interactive Printer Manager (view / remove printers)
echo [4] Run All (Spooler + PDF + Manager)
echo [0] Return to Main Menu
echo.
choice /c 12340 /n /m "Select an option (1-4, 0): "

if errorlevel 5 goto :EOF
if errorlevel 4 call :ResetSpooler & call :EnablePDF & call :PrinterManager & goto :Done
if errorlevel 3 call :PrinterManager & goto :Done
if errorlevel 2 call :EnablePDF & goto :Done
if errorlevel 1 call :ResetSpooler & goto :Done

goto :PrinterMenu

:ResetSpooler
echo.
echo Resetting Print Spooler Service...
net stop spooler /y >nul 2>&1
echo Clearing stuck print jobs from queue...
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*" >nul 2>&1
net start spooler >nul 2>&1
echo Spooler reset complete.
goto :eof

:EnablePDF
echo.
echo Checking 'Microsoft Print to PDF' feature...
:: Detect Windows version to determine Print to PDF availability
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

if "%VERSION%" GEQ "10.0" (
    echo Ensuring 'Microsoft Print to PDF' is enabled...
    Dism /Online /Enable-Feature /FeatureName:Printing-PrintToPDFServices-Features /NoRestart >nul 2>&1
    echo Print to PDF enabled.
) else (
    echo Note: Print to PDF is a Windows 10+ feature. Skipping on this system.
)
goto :eof

:PrinterManager
echo.
echo This tool allows you to view and delete duplicate or ghost printers.

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
goto :eof

:Done
echo.
echo === PRINTER REPAIR COMPLETE ===
pause
