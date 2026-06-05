@echo off
:BrowserMenu
cls
echo.
echo === BROWSER CACHE RESCUE ===
echo.
echo WARNING: This will forcefully close Chrome, Edge, and Firefox.
echo Saved Passwords, Bookmarks, and History are ALWAYS safe.
echo.
echo [1] SOFT RESET: Clear Cache only (Keeps users logged into websites)
echo [2] HARD RESET: Clear Cache AND Cookies (Logs users out of websites)
echo [0] Return to Main Menu
echo.
choice /c 120 /n /m "Select an option (1-2, 0): "

if errorlevel 3 goto :EOF
if errorlevel 2 set "WIPE_COOKIES=YES" & goto :WipeBrowsers
if errorlevel 1 set "WIPE_COOKIES=NO" & goto :WipeBrowsers

:WipeBrowsers
echo.
echo Terminating browser processes...
taskkill /F /IM chrome.exe /T >nul 2>&1
taskkill /F /IM msedge.exe /T >nul 2>&1
taskkill /F /IM firefox.exe /T >nul 2>&1

echo Purging Cache directories...
:: Chrome & Edge Cache
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" del /q /s /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" del /q /s /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
:: Firefox Cache
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" rmdir /q /s "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*\cache2" >nul 2>&1

if "%WIPE_COOKIES%"=="YES" (
    echo Purging Cookie databases...
    if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network\Cookies" del /q /f "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network\Cookies" >nul 2>&1
    if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Network\Cookies" del /q /f "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Network\Cookies" >nul 2>&1
    if exist "%APPDATA%\Mozilla\Firefox\Profiles" del /q /s /f "%APPDATA%\Mozilla\Firefox\Profiles\*\cookies.sqlite" >nul 2>&1
)

echo.
echo [SUCCESS] Browser rescue complete. 
echo.
pause
goto :BrowserMenu