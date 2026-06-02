@echo off
echo.
echo === EVENT VIEWER ERROR EXPORT ===
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "EventReport=%ReportDir%\%COMPUTERNAME%_Events.txt"

echo Exporting recent system errors and warnings from Event Viewer...
echo ======================================== > "%EventReport%"
echo EVENT VIEWER EXPORT FOR %COMPUTERNAME% >> "%EventReport%"
echo ======================================== >> "%EventReport%"
echo Generated: %date% %time% >> "%EventReport%"
echo. >> "%EventReport%"

echo [CRITICAL AND ERROR EVENTS - LAST 24 HOURS] >> "%EventReport%"
wevtutil qe System /q:"Event[System[(Level=1 or Level=2) and TimeCreated[timediff(@SystemTime) <= 86400000]]]" /f:text >> "%EventReport%" 2>nul

echo. >> "%EventReport%"
echo [APPLICATION ERRORS - LAST 24 HOURS] >> "%EventReport%"
wevtutil qe Application /q:"Event[System[(Level=2) and TimeCreated[timediff(@SystemTime) <= 86400000]]]" /f:text >> "%EventReport%" 2>nul

echo. >> "%EventReport%"
echo [SYSTEM ERRORS - LAST 24 HOURS] >> "%EventReport%"
wevtutil qe System /q:"Event[System[(Level=2) and TimeCreated[timediff(@SystemTime) <= 86400000]]]" /f:text >> "%EventReport%" 2>nul

echo.
echo === EVENT EXPORT COMPLETE ===
echo Report saved to: %EventReport%
echo.
echo Summary of recent errors and warnings extracted from Event Viewer.
echo Open the report file to review detailed error information.
echo.
pause
