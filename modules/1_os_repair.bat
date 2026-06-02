@echo off
echo.
echo === RUNNING OS REPAIR ===
sfc /scannow
Dism /Online /Cleanup-Image /StartComponentCleanup
Dism /Online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /CheckHealth
Dism /Online /Cleanup-Image /RestoreHealth
echo === OS REPAIR COMPLETE ===
pause
