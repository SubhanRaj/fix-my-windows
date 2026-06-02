@echo off
echo.
echo === SYSTEM RESTORE POINT CREATION ===
echo.
echo This creates a safe recovery checkpoint before running aggressive repairs.
echo No data loss risk - this is purely a rollback point.
echo.
choice /c YN /m "Create a system restore point now? (Y=Yes, N=Skip): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo Creating restore point. This may take 1-2 minutes...
    echo.
    
    REM Hybrid approach: Try PowerShell first (Windows 10+), fall back to WMIC (Windows 7-10)
    
    REM METHOD 1: PowerShell (Modern approach for Windows 10+)
    powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'fix-my-windows' -RestorePointType MODIFY" >nul 2>&1
    
    if %errorlevel% equ 0 (
        echo.
        echo === RESTORE POINT CREATED SUCCESSFULLY ===
        echo You can now run aggressive repairs with confidence.
        echo To restore if needed: Settings ^> System ^> Recovery ^> System Restore
        goto :RestoreSuccess
    )
    
    REM METHOD 2: WMIC Fallback (Windows 7-10 compatibility)
    echo PowerShell method unavailable, trying WMIC fallback...
    
    REM Parse date safely without spaces: "Mon 06/02/2026" becomes "2026-06-02"
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
    REM Parse time safely: "14:30:45" becomes "1430"
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
    
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "fix-my-windows-%mydate%-%mytime%", 100, 7 >nul 2>&1
    
    if %errorlevel% equ 0 (
        echo.
        echo === RESTORE POINT CREATED SUCCESSFULLY ===
        echo You can now run aggressive repairs with confidence.
        echo To restore if needed: Settings ^> System ^> Recovery ^> System Restore
        goto :RestoreSuccess
    )
    
    REM Both methods failed
    echo.
    echo WARNING: Restore point creation failed.
    echo Possible causes:
    echo   - System Restore is disabled on this drive
    echo   - Insufficient disk space ^(need at least 300MB^)
    echo   - Network drive ^(restore points require local disks^)
    echo   - Insufficient permissions for restore point creation
    echo.
    echo You can still proceed with repairs, but you won't have a rollback point.
    goto :RestoreEnd
    
    :RestoreSuccess
    echo.
    :RestoreEnd
)
pause


