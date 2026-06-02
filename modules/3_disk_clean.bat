@echo off
echo.
echo === RUNNING DISK MAINTENANCE ===

echo [1/3] Clearing Temp folders...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1

echo.
echo [2/3] Deep System Cleanup (cleanmgr)
echo WARNING: This process will permanently empty the Recycle Bin, 
echo DirectX caches, and old Windows Update files.
choice /c YN /m "Do you want to run Deep Cleanup? (Y=Yes, N=Skip): "
if errorlevel 2 goto :SkipCleanmgr
if errorlevel 1 (
    echo.
    echo Running Silent Disk Cleanup... Please wait.
    cleanmgr.exe /d c: /verylowdisk
)

:SkipCleanmgr
echo.
echo [3/3] Running live disk scan (CHKDSK)...
chkdsk C: /scan

echo === DISK MAINTENANCE COMPLETE ===
pause
