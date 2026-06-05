@echo off
color 0B
echo.
echo ========================================================
echo             WinPE OFFLINE OS RECOVERY TOOL
echo ========================================================
echo.
echo Scanning for offline Windows installation...

:: Loop through the alphabet to find where WinPE hid the actual OS drive
set "OS_DRIVE="
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\Windows\System32\config\SOFTWARE" (
        set "OS_DRIVE=%%D:"
        goto :FoundOS
    )
)

:NotFound
echo [ERROR] Could not locate an offline Windows installation.
echo The drive may be BitLocker encrypted or physically failing.
pause
exit /b

:FoundOS
echo [SUCCESS] Offline Windows located at %OS_DRIVE%
echo.
echo [1/3] Repairing Boot Configuration Data (BCD)...
:: Export and back up the corrupted BCD
bcdedit /export %OS_DRIVE%\bcdbackup >nul 2>&1
attrib %OS_DRIVE%\boot\bcd -h -r -s >nul 2>&1
ren %OS_DRIVE%\boot\bcd bcd.old >nul 2>&1

:: Rebuild the Bootloader targeting the found OS drive
bootrec /rebuildbcd
bcdboot %OS_DRIVE%\Windows /l en-us

echo.
echo [2/3] Running Offline SFC Scan...
:: The critical offline syntax that forces SFC to scan the SSD, not the RAM disk
sfc /scannow /offbootdir=%OS_DRIVE%\ /offwindir=%OS_DRIVE%\Windows

echo.
echo [3/3] Running Offline DISM Component Cleanup...
:: Uses the WinPE RAM disk scratch directory to repair the offline image
md %OS_DRIVE%\Scratch >nul 2>&1
DISM /Image:%OS_DRIVE%\ /Cleanup-Image /RestoreHealth /ScratchDir:%OS_DRIVE%\Scratch

echo.
echo Cleaning up...
rd %OS_DRIVE%\Scratch /s /q >nul 2>&1

echo.
echo ========================================================
echo RECOVERY COMPLETE. 
echo Close this window and click "Continue to Windows".
echo ========================================================
pause