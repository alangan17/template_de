@echo off
setlocal EnableDelayedExpansion

:: to clear all build caches, use `docker system prune -a`

:: Get current date and time in YYYY-MM-DD HH:MM:SS format
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set datetime=%%a
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%

:: Correctly handle leading zeros in time calculation
:: Get start time in hundredths of a second, ensuring no leading zeros cause issues
for /f "tokens=1-4 delims=:.," %%a in ("%time: =0%") do (
    set /a "start=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610000"
)

echo Start building image...
:: Create the conda environment and automatically approve prompts
call docker compose build

:: Check the status and report
if %ERRORLEVEL% equ 0 (
    echo.
    echo Status: SUCCESS
) else (
    echo.
    echo Status: FAILED
)

:: Get end time in hundredths of a second, ensuring no leading zeros cause issues
for /f "tokens=1-4 delims=:.," %%a in ("%time: =0%") do (
    set /a "end=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610000"
)

:: Calculate the duration
set /a "duration=(end-start)/100"

echo Start time: %start%0
echo End time: %end%0
echo Total time taken: %duration% seconds

:: Format the current date and time
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set curDate=%%c-%%a-%%b
)
for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set "curTime=%%a:%%b:%%c"
    if %%a LSS 10 (set "curTime=0%%a:%%b:%%c")
)
echo Execution Datetime: %curDate% %curTime%

endlocal