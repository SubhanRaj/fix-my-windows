@echo off
echo.
echo === AUDIO DRIVER RESET ===
echo.
echo This will restart audio-related services and drivers.
echo Useful for fixing "no sound" or audio-related issues.
echo.
choice /c YN /m "Reset audio drivers and services? (Y=Yes, N=Cancel): "
if errorlevel 2 goto :EOF
if errorlevel 1 (
    echo.
    echo [1/3] Stopping audio services...
    net stop audiosrv /y >nul 2>&1
    net stop mmcss /y >nul 2>&1
    
    echo [2/3] Clearing audio cache...
    del /q /f /s "%APPDATA%\Microsoft\Windows\Recent\automrulist.xml" >nul 2>&1
    
    echo [3/3] Restarting audio services...
    net start audiosrv >nul 2>&1
    net start mmcss >nul 2>&1
    
    echo.
    echo === AUDIO RESET COMPLETE ===
    echo Audio services have been restarted.
    echo.
    echo If audio is still not working:
    echo   1. Check if speakers/headphones are properly connected
    echo   2. Run Device Manager and look for audio device errors
    echo   3. Update audio drivers from manufacturer website
    echo   4. Uninstall and reinstall audio drivers
)
pause
