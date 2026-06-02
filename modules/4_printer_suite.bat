@echo off
echo.
echo === PRINTER REPAIR SUITE ===
echo.
echo [1/2] Resetting Print Spooler Service...
net stop spooler /y
echo Clearing stuck print jobs from queue...
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*" >nul 2>&1
net start spooler

echo.
echo [2/2] Printer Features Configuration...

REM Detect Windows version to determine Print to PDF availability
REM Windows 10+ has Print to PDF, Windows 7-8.1 does not
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

if %VERSION% geq 10.0 (
    echo Ensuring 'Microsoft Print to PDF' is enabled...
    Dism /Online /Enable-Feature /FeatureName:Printing-PrintToPDFServices-Features /NoRestart
) else (
    echo Note: Print to PDF is a Windows 10+ feature. Skipping on this system.
    echo You can use third-party PDF printers or cloud printing as alternatives.
)

echo.
echo === PRINTER REPAIR COMPLETE ===
pause

