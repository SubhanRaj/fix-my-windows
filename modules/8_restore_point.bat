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
    
    REM Use PowerShell for reliable restore point creation (works on Windows 10+)
    powershell -Command "try { $result = Checkpoint-Computer -Description 'fix-my-windows-repair' -RestorePointType MODIFY; Write-Host 'SUCCESS: Restore point created'; exit 0 } catch { Write-Host 'ERROR: Could not create restore point'; exit 1 }" >nul 2>&1
    
    if %errorlevel% equ 0 (
        echo.
        echo === RESTORE POINT CREATED SUCCESSFULLY ===
        echo You can now run aggressive repairs with confidence.
        echo To restore if needed: Settings ^> System ^> Recovery ^> System Restore
    ) else (
        echo.
        echo WARNING: Restore point creation failed.
        echo Possible causes:
        echo   - System Restore is disabled on this drive
        echo   - Insufficient disk space ^(need at least 300MB^)
        echo   - Network drive ^(restore points require local disks^)
        echo   - Insufficient permissions
        echo.
        echo You can still proceed with repairs, but you won't have a rollback point.
    )
)
pause

