@echo off
:RuntimeMenu
cls
echo ========================================================
echo               RUNTIMES ^& FEATURES INSTALLER
echo ========================================================
echo.
echo [1] Enable .NET Framework 3.5 (Includes .NET 2.0 ^& 3.0)
echo [2] Install Latest Visual C++ Redistributables (x86 ^& x64)
echo [B] Back to Main Menu
echo.

choice /c 12B /n /m "Select an option: "

if errorlevel 3 goto :EOF
if errorlevel 2 goto :InstallVC
if errorlevel 1 goto :InstallNet

:InstallNet
echo.
echo Enabling .NET Framework 3.5 via DISM...
Dism /Online /Enable-Feature /FeatureName:NetFx3 /All
echo.
echo .NET Framework 3.5 configuration complete.
pause
goto :RuntimeMenu

:InstallVC
echo.
echo Downloading and installing Visual C++ Redistributables...
echo This uses official Microsoft permalinks and installs silently.
echo.
echo Downloading x64 Redistributable...
curl -L -o "%TEMP%\vc_redist.x64.exe" "https://aka.ms/vc14/vc_redist.x64.exe"
echo Installing x64 Redistributable...
"%TEMP%\vc_redist.x64.exe" /quiet /norestart
del "%TEMP%\vc_redist.x64.exe"

echo.
echo Downloading x86 Redistributable...
curl -L -o "%TEMP%\vc_redist.x86.exe" "https://aka.ms/vc14/vc_redist.x86.exe"
echo Installing x86 Redistributable...
"%TEMP%\vc_redist.x86.exe" /quiet /norestart
del "%TEMP%\vc_redist.x86.exe"

echo.
echo Visual C++ Redistributables installation complete!
pause
goto :RuntimeMenu
