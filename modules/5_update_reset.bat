@echo off
echo.
echo === WINDOWS UPDATE CACHE RESET ===
echo.
echo WARNING: This will stop the Windows Update service and clear cached updates.
echo A reboot is highly recommended after this operation.
echo.
choice /c YN /m "Do you want to proceed? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo [1/4] Stopping Windows Update service...
    net stop wuauserv /y >nul 2>&1
    net stop bits /y >nul 2>&1
    
    echo [2/4] Clearing SoftwareDistribution folder...
    rmdir /s /q "%systemroot%\SoftwareDistribution\Download" >nul 2>&1
    
    echo [3/4] Clearing Catroot2 cache...
    rmdir /s /q "%systemroot%\System32\Catroot2\Temp" >nul 2>&1
    
    echo [4/4] Restarting Windows Update service...
    net start wuauserv
    net start bits
    
    echo.
    echo === UPDATE CACHE RESET COMPLETE ===
    echo Next steps: Check for updates via Settings ^> Update ^& Security ^> Check for updates
    echo.
)
pause
