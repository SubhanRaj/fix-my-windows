@echo off
:DnsMenu
cls
echo.
echo === DNS ^& HOSTS MANAGER ===
echo.
echo [1] Set Active Adapter DNS to Cloudflare (1.1.1.1 / 1.0.0.1)
echo [2] Set Active Adapter DNS to Google (8.8.8.8 / 8.8.4.4)
echo [3] Revert Active Adapter to Automatic (DHCP)
echo [4] Deep Flush DNS ^& Winsock Reset
echo [5] View Current 'hosts' File Content
echo [0] Return to Main Menu
echo.
choice /c 123450 /n /m "Select option (1-5, 0): "

if errorlevel 6 goto :EOF
if errorlevel 5 goto :ViewHosts
if errorlevel 4 goto :FlushDNS
if errorlevel 3 goto :SetDHCP
if errorlevel 2 goto :SetGoogle
if errorlevel 1 goto :SetCloudflare

:SetCloudflare
echo.
echo Configuring active adapters to Cloudflare DNS...
powershell -NoProfile -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Set-DnsClientServerAddress -ServerAddresses ('1.1.1.1', '1.0.0.1')"
echo DNS updated successfully.
timeout /t 2 >nul
goto :DnsMenu

:SetGoogle
echo.
echo Configuring active adapters to Google DNS...
powershell -NoProfile -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Set-DnsClientServerAddress -ServerAddresses ('8.8.8.8', '8.8.4.4')"
echo DNS updated successfully.
timeout /t 2 >nul
goto :DnsMenu

:SetDHCP
echo.
echo Reverting active adapters to Automatic (DHCP) DNS...
powershell -NoProfile -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Set-DnsClientServerAddress -ResetServerAddresses"
echo DNS reverted to ISP default successfully.
timeout /t 2 >nul
goto :DnsMenu

:FlushDNS
echo.
echo Flushing DNS Cache...
ipconfig /flushdns >nul 2>&1
echo Resetting Winsock Catalog...
netsh winsock reset >nul 2>&1
echo.
echo Network caches cleared. (A system reboot is recommended).
pause
goto :DnsMenu

:ViewHosts
echo.
echo === CURRENT HOSTS FILE CONTENT ===
echo Location: C:\Windows\System32\drivers\etc\hosts
echo --------------------------------------------------
type C:\Windows\System32\drivers\etc\hosts | findstr /V "^#"
echo --------------------------------------------------
echo (Note: Commented lines starting with '#' are hidden for readability)
echo.
pause
goto :DnsMenu