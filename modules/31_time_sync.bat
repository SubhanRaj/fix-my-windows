@echo off
:TimeMenu
cls
echo.
echo === ADVANCED TIME SYNC ^& SSL FIX ===
echo.
echo [1] India NPL / NIC Servers (samay1.nic.in / samay2.nic.in)
echo [2] Cloudflare Global (time.cloudflare.com)
echo [3] Google Global (time.google.com)
echo [4] Microsoft Default (time.windows.com)
echo [0] Return to Main Menu
echo.
choice /c 12340 /n /m "Select an NTP Provider (1-4, 0): "

if errorlevel 5 goto :EOF
if errorlevel 4 set "NTP_SERVER=time.windows.com,0x9" & goto :SyncTime
if errorlevel 3 set "NTP_SERVER=time.google.com,0x9" & goto :SyncTime
if errorlevel 2 set "NTP_SERVER=time.cloudflare.com,0x9" & goto :SyncTime
if errorlevel 1 set "NTP_SERVER=samay1.nic.in,0x9 samay2.nic.in,0x9 time.nplindia.org,0x9" & goto :SyncTime

:SyncTime
echo.
echo [1/3] Stopping Windows Time Service...
net stop w32time >nul 2>&1

echo [2/3] Registering new NTP Servers...
w32tm /unregister >nul 2>&1
w32tm /register >nul 2>&1
net start w32time >nul 2>&1

echo [3/3] Forcing Hardware Clock Sync with %NTP_SERVER%...
w32tm /config /manualpeerlist:"%NTP_SERVER%" /syncfromflags:manual /reliable:yes /update >nul 2>&1
w32tm /resync /force

echo.
echo [SUCCESS] Time sync command issued. If it fails, the network firewall
echo is completely blocking Port 123 (NTP). Connect to a mobile hotspot and retry.
echo.
pause
goto :TimeMenu