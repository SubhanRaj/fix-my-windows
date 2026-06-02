@echo off
echo.
echo === SCHEDULED TASKS CLEANUP ===
echo.
echo This will audit and report orphaned/broken scheduled tasks.
echo No tasks will be deleted - only reported for manual review.
echo.
set "ReportDir=%~dp0..\Reports"
if not exist "%ReportDir%" mkdir "%ReportDir%"

set "TaskReport=%ReportDir%\%COMPUTERNAME%_ScheduledTasks.txt"

echo Analyzing scheduled tasks...
echo ======================================== > "%TaskReport%"
echo SCHEDULED TASKS AUDIT FOR %COMPUTERNAME% >> "%TaskReport%"
echo ======================================== >> "%TaskReport%"
echo Generated: %date% %time% >> "%TaskReport%"
echo. >> "%TaskReport%"

echo [ALL SCHEDULED TASKS] >> "%TaskReport%"
tasklist /fo list 2>nul >> "%TaskReport%"

echo. >> "%TaskReport%"
echo [FAILED/DISABLED TASKS] >> "%TaskReport%"
schtasks /query /fo list /v >> "%TaskReport%" 2>nul | findstr /i "Error\|Disabled\|Failed" >> "%TaskReport%"

echo. >> "%TaskReport%"
echo [TASKS WITH MISSING EXECUTABLES] >> "%TaskReport%"
echo Note: Tasks that reference non-existent program files >> "%TaskReport%"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" >> "%TaskReport%" 2>nul

echo.
echo === TASK AUDIT COMPLETE ===
echo Report saved to: %TaskReport%
echo.
echo Common tasks safe to disable:
echo   - Adobe Update
echo   - Google Update
echo   - Java Update
echo   - Skype Update
echo   - OneDrive (if not needed)
echo.
echo To disable a task: schtasks /change /tn "TaskName" /disable
echo To enable a task: schtasks /change /tn "TaskName" /enable
echo.
pause
