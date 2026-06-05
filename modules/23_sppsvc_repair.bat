@echo off
echo.
echo === SPPSVC REPAIR ^& KMS MALWARE CLEANUP ===
echo.
echo WARNING: Error 577 indicates severe malware infection (File Infector)
echo that has overwritten core Windows licensing binaries.
echo This module will attempt to strip KMS hooks and force a binary repair.
echo.
choice /c YN /m "Attempt deep SPPSVC repair? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF

echo.
echo [1/5] Stopping corrupted services and KMS emulators...
net stop sppsvc /y >nul 2>&1
net stop OsppSvc /y >nul 2>&1
taskkill /f /im AutoKMS.exe >nul 2>&1
taskkill /f /im SppExtComObjHook.dll >nul 2>&1

echo [2/5] Purging KMS Scheduled Tasks...
schtasks /delete /tn "AutoKMS" /f >nul 2>&1
schtasks /delete /tn "AutoPico Daily Restart" /f >nul 2>&1
schtasks /delete /tn "KMSAutoNet" /f >nul 2>&1

echo [3/5] Deleting known KMS Emulator files...
if exist "C:\Windows\System32\SppExtComObjHook.dll" del /f /q "C:\Windows\System32\SppExtComObjHook.dll"
if exist "C:\Windows\AutoKMS" rmdir /s /q "C:\Windows\AutoKMS"
if exist "C:\Program Files\KMSpico" rmdir /s /q "C:\Program Files\KMSpico"

echo [4/5] Resetting SPPSVC Registry and Permissions...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\sppsvc" /v Start /t REG_DWORD /d 2 /f >nul 2>&1

echo [5/5] Forcing Binary Repair on Licensing Services...
echo Running SFC targeted specifically at SPPSVC and SPPC...
sfc /scanfile="C:\Windows\System32\sppsvc.exe"
sfc /scanfile="C:\Windows\System32\sppc.dll"

echo.
echo Attempting to start the Software Protection Service...
sc start sppsvc

echo.
echo === REPAIR COMPLETE ===
echo If the service started successfully, run your activation script again.
echo.
echo CRITICAL NOTE: If it still fails with Error 577, the official fix from 
echo MAS is to perform a clean Windows installation from a bootable USB.
echo.
pause