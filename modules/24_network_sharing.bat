@echo off
:MenuStart
cls
echo.
echo === NETWORK ^& FILE SHARING SETUP ===
echo.
echo [1] Enable Network Discovery ^& File Sharing Services
echo [2] Create a new Local Network Share
echo [3] Disable Sharing (Revert to Secure Defaults)
echo [0] Return to Main Menu
echo.
choice /c 1230 /n /m "Select an option (1-3, 0): "

if errorlevel 4 goto :EOF
if errorlevel 3 goto :DisableSharing
if errorlevel 2 goto :CreateShare
if errorlevel 1 goto :EnableSharing

:EnableSharing
echo.
echo [1/2] Starting required networking services...
:: Function Discovery Provider Host
sc config fdPHost start= auto >nul 2>&1
net start fdPHost >nul 2>&1
:: Function Discovery Resource Publication (Crucial for showing up in Network tab)
sc config FDResPub start= auto >nul 2>&1
net start FDResPub >nul 2>&1
:: Server Service (SMB)
sc config lanmanserver start= auto >nul 2>&1
net start lanmanserver >nul 2>&1

echo [2/2] Configuring Windows Firewall...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul 2>&1
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes >nul 2>&1

echo.
echo === DISCOVERY ENABLED ===
echo This PC is now visible on the local network.
pause
goto :MenuStart

:CreateShare
echo.
echo === CREATE NETWORK SHARE ===
set /p "sharePath=Enter the full path to share (e.g., C:\PublicFiles): "
if not exist "%sharePath%" (
    echo Path does not exist. Creating it now...
    mkdir "%sharePath%"
)

set /p "shareName=Enter the Network Share Name (e.g., LabShare): "

echo.
echo [1/2] Configuring NTFS Folder Permissions...
:: Grants 'Everyone' full Read/Write access at the file system level
icacls "%sharePath%" /grant Everyone:(OI)(CI)F /T /C /Q >nul 2>&1

echo [2/2] Creating SMB Network Share...
:: Creates the actual share and sets network-level permissions
net share "%shareName%"="%sharePath%" /GRANT:Everyone,FULL >nul 2>&1

echo.
echo === SHARE CREATED ===
echo Success! Folder is now accessible at \\localhost\%shareName%
pause
goto :MenuStart

:DisableSharing
echo.
echo [1/2] Disabling Firewall rules...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=No >nul 2>&1
netsh advfirewall firewall set rule group="Network Discovery" new enable=No >nul 2>&1

echo [2/2] Stopping discovery services...
net stop fdPHost /y >nul 2>&1
net stop FDResPub /y >nul 2>&1

echo.
echo === SHARING LOCKED DOWN ===
echo Discovery is disabled. Existing shares remain active but the PC is hidden.
pause
goto :MenuStart