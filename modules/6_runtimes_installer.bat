@echo off
:RuntimeMenu
cls
echo.
echo === RUNTIMES ^& REDISTRIBUTABLES INSTALLER ===
echo.
echo [1] Install .NET Desktop Runtime (Latest x64)
echo [2] Install Visual C++ Redistributable (2015-2022 x64)
echo [3] Install .NET Framework 3.5 (Legacy)
echo [0] Return to Main Menu
echo.
choice /c 1230 /n /m "Select option (1-3, 0): "

if errorlevel 4 goto :EOF
if errorlevel 3 goto :Net35
if errorlevel 2 goto :VCRedist
if errorlevel 1 goto :NetDesktop

:NetDesktop
echo.
echo Installing latest .NET Desktop Runtime via Winget...
:: Native Windows package manager handles the correct architecture and version silently
winget install Microsoft.DotNet.DesktopRuntime --silent --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    echo [ERROR] Winget failed or is not installed on this OS version.
) else (
    echo [SUCCESS] .NET Desktop Runtime installed successfully.
)
echo.
pause
goto :RuntimeMenu

:VCRedist
echo.
echo [1/2] Downloading Visual C++ 2015-2022 (x64)...
set "VC_INSTALLER=%TEMP%\vc_redist.x64.exe"
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile '%VC_INSTALLER%'"

echo [2/2] Silently installing...
"%VC_INSTALLER%" /install /quiet /norestart
del /q "%VC_INSTALLER%" >nul 2>&1

echo.
echo [SUCCESS] Visual C++ Redistributable installed.
pause
goto :RuntimeMenu

:Net35
echo.
echo Installing .NET Framework 3.5 via DISM...
Dism /online /Enable-Feature /FeatureName:"NetFx3" /All >nul 2>&1
echo.
echo [SUCCESS] .NET 3.5 Installation command finished.
pause
goto :RuntimeMenu