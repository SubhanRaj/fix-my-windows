@echo off
echo.
echo === SYSTEM PERFORMANCE MONITOR ===
echo.
echo [1] Download ^& Run Temporarily (Portable)
echo [2] Download ^& Install Permanently (C:\Program Files)
echo [0] Return to Menu
echo.
choice /c 120 /n /m "Select option (1-2, 0): "

if errorlevel 3 goto :EOF
if errorlevel 2 goto :FetchInstall
if errorlevel 1 goto :FetchTemp

:FetchTemp
echo.
echo [1/3] Querying GitHub API...
set "TEMP_DIR=%TEMP%\fmw_lhm"
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%" >nul 2>&1
mkdir "%TEMP_DIR%"

powershell -NoProfile -Command "$ErrorActionPreference = 'Stop'; try { $rel = Invoke-RestMethod -Uri 'https://api.github.com/repos/LibreHardwareMonitor/LibreHardwareMonitor/releases/latest'; $asset = $rel.assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1; Write-Host '[2/3] Downloading...'; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '%TEMP_DIR%\LHM.zip'; Write-Host '[3/3] Extracting...'; Expand-Archive -Path '%TEMP_DIR%\LHM.zip' -DestinationPath '%TEMP_DIR%\Extracted' -Force } catch { Write-Host 'Error:' $_.Exception.Message -ForegroundColor Red; exit 1 }"

if errorlevel 1 (
    echo.
    echo [ERROR] Fetch failed.
    pause
    goto :EOF
)

echo.
echo Launching Hardware Monitor...
start "" "%TEMP_DIR%\Extracted\LibreHardwareMonitor.exe"
goto :EOF

:FetchInstall
echo.
echo [1/3] Querying GitHub API...
set "INSTALL_DIR=C:\Program Files\LibreHardwareMonitor"
set "TEMP_DIR=%TEMP%\fmw_lhm"
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%" >nul 2>&1
mkdir "%TEMP_DIR%"

powershell -NoProfile -Command "$ErrorActionPreference = 'Stop'; try { $rel = Invoke-RestMethod -Uri 'https://api.github.com/repos/LibreHardwareMonitor/LibreHardwareMonitor/releases/latest'; $asset = $rel.assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1; Write-Host '[2/3] Downloading...'; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '%TEMP_DIR%\LHM.zip'; Write-Host '[3/3] Extracting...'; Expand-Archive -Path '%TEMP_DIR%\LHM.zip' -DestinationPath '%TEMP_DIR%\Extracted' -Force } catch { Write-Host 'Error:' $_.Exception.Message -ForegroundColor Red; exit 1 }"

if errorlevel 1 (
    echo.
    echo [ERROR] Fetch failed.
    pause
    goto :EOF
)

echo.
echo Installing to %INSTALL_DIR%...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
xcopy /E /Y /I "%TEMP_DIR%\Extracted\*" "%INSTALL_DIR%" >nul 2>&1

echo Creating Start Menu shortcut...
powershell -NoProfile -Command "$wshell = New-Object -ComObject WScript.Shell; $shortcut = $wshell.CreateShortcut([Environment]::GetFolderPath('CommonStartMenu') + '\Programs\Hardware Monitor.lnk'); $shortcut.TargetPath = '%INSTALL_DIR%\LibreHardwareMonitor.exe'; $shortcut.WorkingDirectory = '%INSTALL_DIR%'; $shortcut.Save()" >nul 2>&1

echo Cleaning up Temp...
rmdir /s /q "%TEMP_DIR%" >nul 2>&1

echo.
echo [SUCCESS] Installed.
start "" "%INSTALL_DIR%\LibreHardwareMonitor.exe"
goto :EOF