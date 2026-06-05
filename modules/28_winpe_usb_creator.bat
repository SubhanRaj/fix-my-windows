@echo off
echo.
echo === WinPE RESCUE USB CREATOR ===
echo.
echo [SAFE MODE] This tool will ONLY copy a single batch script.
echo It will NOT format your drive or delete any existing data.
echo Fully compatible with FAT32, exFAT, and NTFS flash drives.
echo.
echo Scanning for connected USB Removable Drives...
echo.

:: Use WMIC to find Removable Drives (DriveType=2) and show File System
wmic logicaldisk where drivetype=2 get deviceid, volumename, filesystem

echo.
set /p "usbDrive=Enter the drive letter of your Pen Drive (e.g., E): "

:: Strip colons in case you type "E:" instead of "E"
set "usbDrive=%usbDrive::=%"

if not exist "%usbDrive%:\" (
    echo.
    echo [ERROR] Drive %usbDrive%:\ not found or not accessible.
    pause
    goto :EOF
)

echo.
echo Verifying target drive safety...
:: Fetch and display the exact file system of the chosen drive
for /f "skip=1" %%F in ('wmic logicaldisk where "deviceid='%usbDrive%:'" get filesystem 2^>nul') do (
    if not "%%F"=="" echo Confirmed File System: %%F
)

echo.
echo Copying WinPE_Rescue.bat to %usbDrive%:\ ...
:: /Y silently overwrites an older version of WinPE_Rescue.bat if it already exists, 
:: but absolutely nothing else on the drive is touched.
copy /Y "%~dp0WinPE_Rescue.bat" "%usbDrive%:\WinPE_Rescue.bat" >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Failed to copy the file. Check permissions or drive space.
) else (
    echo [SUCCESS] WinPE Rescue tool is safely deployed!
    echo Your existing files were completely untouched.
    echo.
    echo To use it, boot a broken PC into Recovery mode, open Command Prompt,
    echo find drive %usbDrive%:, and type: WinPE_Rescue.bat
)
echo.
pause