@echo off
echo.
echo WARNING: This will immediately close all applications and force a deep restart.
echo Any unsaved work will be lost.
echo.
choice /c YN /m "Are you sure you want to reboot now?"
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo Rebooting...
    shutdown /r /f /t 0
)
