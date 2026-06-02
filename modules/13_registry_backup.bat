@echo off
echo.
echo === REGISTRY BACKUP ===
echo.
echo This will create a complete backup of your Windows Registry.
echo This is a safety measure before running aggressive system repairs.
echo.
set "BackupDir=%~dp0..\Backups"
if not exist "%BackupDir%" mkdir "%BackupDir%"

set "BackupFile=%BackupDir%\Registry_Backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.reg"

REM Replace colons with valid filename characters
set "BackupFile=%BackupFile::=-%.reg"
set "BackupFile=%BackupFile: =_%.reg"

echo Creating Registry backup...
echo Current backup location: %BackupDir%
echo.

choice /c YN /m "Proceed with Registry backup? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo [1/4] Backing up HKEY_LOCAL_MACHINE...
    reg export HKLM "%BackupDir%\HKLM_Backup.reg" /y >nul 2>&1
    
    echo [2/4] Backing up HKEY_CURRENT_USER...
    reg export HKCU "%BackupDir%\HKCU_Backup.reg" /y >nul 2>&1
    
    echo [3/4] Backing up HKEY_CLASSES_ROOT...
    reg export HKCR "%BackupDir%\HKCR_Backup.reg" /y >nul 2>&1
    
    echo [4/4] Backing up HKEY_CURRENT_CONFIG...
    reg export HKCC "%BackupDir%\HKCC_Backup.reg" /y >nul 2>&1
    
    echo.
    echo === REGISTRY BACKUP COMPLETE ===
    echo Backup files saved to: %BackupDir%
    echo.
    echo Backup contents:
    echo   - HKLM_Backup.reg (Local Machine settings)
    echo   - HKCU_Backup.reg (User settings)
    echo   - HKCR_Backup.reg (Class registration)
    echo   - HKCC_Backup.reg (Current hardware profile)
    echo.
    echo To restore: Right-click any .reg file and select "Merge"
    echo Or: reg import filename.reg
)
pause
