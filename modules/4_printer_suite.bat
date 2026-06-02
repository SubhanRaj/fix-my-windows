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
echo [2/2] Ensuring 'Microsoft Print to PDF' is enabled...
Dism /Online /Enable-Feature /FeatureName:Printing-PrintToPDFServices-Features /NoRestart
echo.
echo === PRINTER REPAIR COMPLETE ===
pause
