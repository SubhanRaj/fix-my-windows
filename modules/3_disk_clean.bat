@echo off
echo.
echo === RUNNING DISK MAINTENANCE ===
echo Clearing Temp folders...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
echo Running live disk scan...
chkdsk C: /scan
echo === DISK MAINTENANCE COMPLETE ===
pause
