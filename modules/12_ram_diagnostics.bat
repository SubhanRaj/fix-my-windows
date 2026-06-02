@echo off
echo.
echo === RAM DIAGNOSTICS ===
echo.
echo This will run Windows Memory Diagnostic to check for RAM issues.
echo A reboot is required to run the test.
echo.
choice /c YN /m "Run Windows Memory Diagnostic? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo Scheduling Memory Diagnostic for next reboot...
    
    REM Detect Windows version
    for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
    
    if %VERSION% geq 10.0 (
        REM Windows 10+ - Use native Windows Memory Diagnostic via MsConfig
        powershell -Command "Start-Process ms-settings:recovery" >nul 2>&1
        echo.
        echo 1. Click "Troubleshoot" ^> "Advanced options" ^> "Startup Settings"
        echo 2. Click "Restart" and select "Safe Mode with Command Prompt"
        echo 3. Run: mdsched.exe to launch Memory Diagnostic
    ) else (
        REM Windows 7-8.1 - Use mdsched.exe directly
        mdsched.exe
    )
    
    echo.
    echo === MEMORY DIAGNOSTIC SCHEDULED ===
    echo The test will run at next system startup.
    echo This may take 10-30 minutes depending on RAM size.
)
pause
