@echo off
echo.
echo === RUNNING SAFE NETWORK RESET ===
echo Flushing DNS Resolver Cache...
ipconfig /flushdns
echo Re-registering DNS...
ipconfig /registerdns
echo Releasing and Renewing DHCP (Static IPs will ignore this)...
ipconfig /release >nul
ipconfig /renew >nul
echo Resetting Winsock Catalog...
netsh winsock reset
echo === NETWORK RESET COMPLETE ===
echo Note: A reboot is required for Winsock reset to fully take effect.
pause
