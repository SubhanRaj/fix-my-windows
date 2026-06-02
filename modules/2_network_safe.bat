@echo off
echo.
echo === RUNNING SAFE NETWORK RESET ===
echo.
echo IMPORTANT: Static IP addresses will NOT be affected by this operation.
echo DNS and Winsock will be reset, but your static IP configuration remains.
echo.
echo SECURITY NOTE: This script does NOT modify Group Policy settings.
echo If your IP is configured via domain policy, it will not be changed.
echo.
choice /c YN /m "Continue with network reset? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo [1/4] Flushing DNS Resolver Cache...
    ipconfig /flushdns
    
    echo [2/4] Re-registering DNS...
    ipconfig /registerdns
    
    echo [3/4] Releasing and Renewing DHCP...
    echo Note: Static IP addresses will remain unchanged.
    ipconfig /release >nul 2>&1
    ipconfig /renew >nul 2>&1
    
    echo [4/4] Resetting Winsock Catalog...
    netsh winsock reset
    
    echo.
    echo === NETWORK RESET COMPLETE ===
    echo IMPORTANT: A reboot is required for Winsock reset to fully take effect.
    echo Your static IP configuration has been preserved.
)
pause

