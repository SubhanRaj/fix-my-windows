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
    echo Creating restore point named 'fix-my-windows-%date%'...
    echo This may take 1-2 minutes...
    echo.
    
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "fix-my-windows-%date% %time%", 100, 7
    
    if %errorlevel% equ 0 (
        echo.
        echo === RESTORE POINT CREATED SUCCESSFULLY ===
        echo You can now run aggressive repairs with confidence.
        echo To restore if needed: Settings ^> System ^> Recovery ^> System Restore
    ) else (
        echo.
        echo WARNING: Restore point creation may have failed.
        echo Possible causes:
        echo   - System Restore is disabled on this drive
        echo   - Insufficient disk space
        echo   - Network drive (restore points require local disks)
    )
)
pause
