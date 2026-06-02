@echo off
echo.
echo === GPU ^& DIRECTX DIAGNOSTICS ===
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "GPUReport=%ReportDir%\%COMPUTERNAME%_GPU_DirectX.txt"

echo Gathering GPU and DirectX information...
echo ======================================== > "%GPUReport%"
echo GPU ^& DIRECTX AUDIT FOR %COMPUTERNAME% >> "%GPUReport%"
echo ======================================== >> "%GPUReport%"
echo Generated: %date% %time% >> "%GPUReport%"
echo. >> "%GPUReport%"

echo [GRAPHICS DEVICE INFORMATION] >> "%GPUReport%"
wmic path win32_videocontroller get name,driverversion,currentresolution,currentrefreshrate >> "%GPUReport%" 2>nul

echo. >> "%GPUReport%"
echo [DISPLAY ADAPTER DETAILS] >> "%GPUReport%"
wmic path win32_displayconfiguration get description,screenshotheight,screenshotwidth >> "%GPUReport%" 2>nul

echo. >> "%GPUReport%"
echo [MONITORS] >> "%GPUReport%"
wmic path win32_desktopmonitor get description,monitortype >> "%GPUReport%" 2>nul

echo. >> "%GPUReport%"
echo [DIRECTX VERSION] >> "%GPUReport%"
for /f "tokens=5" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\DirectX" /v "Version" 2^>nul') do (
    echo DirectX Version: %%i >> "%GPUReport%"
)

echo. >> "%GPUReport%"
echo [3D GRAPHICS FEATURES] >> "%GPUReport%"
wmic path win32_videocontroller get name,videoarchitecture,videoprocessor >> "%GPUReport%" 2>nul

echo.
echo === GPU DIAGNOSTICS COMPLETE ===
echo Report saved to: %GPUReport%
echo.
echo To export detailed DirectX information:
echo   1. Press Windows Key + R
echo   2. Type: dxdiag
echo   3. Save Report...
echo.
pause
