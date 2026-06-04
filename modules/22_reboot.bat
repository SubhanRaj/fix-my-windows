@echo off
echo.
echo WARNING: This will immediately close all applications and force a deep restart.
echo Any unsaved work will be lost.
echo.
choice /c YN /m "Are you sure you want to reboot now?"
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo Scheduling deep reboot in 5 seconds...
    
    :: Schedule the reboot with a 5-second buffer and a custom message
    shutdown /r /f /t 5 /c "fix-my-windows: Cleaning up temporary files and rebooting..."
    
    :: Instantly kill the batch script so PowerShell can run its zero-trace cleanup
    exit
)