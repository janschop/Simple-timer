@echo off
:start
cls
echo  +---------+
echo  ^|  TIMER  ^|
echo  +---------+
echo Enter the timer duration in minutes followed by seconds
set /p count_m="Minutes: "
set /a count_m*=60
set /p count_s="Seconds: "
set /a count=count_m+count_s
set /a start_count=count
cls
goto :loop

:restart
echo:
echo  Press 'r' to restart the timer
echo  Press 'n' to start a new timer
choice /c nr /n > $null

if %errorlevel% equ 1 goto start
powershell -ExecutionPolicy Bypass -File mute.ps1 > $null
set /a count=count_m+count_s


:loop
set /a start_minutes=%start_count%/60
set start_minutes=00%start_minutes%
set start_minutes=%start_minutes:~-2%

set /a start_seconds=%start_count% %% 60
set start_seconds=00%start_seconds%
set start_seconds=%start_seconds:~-2%

set /a minutes=%count%/60
set minutes=00%minutes%
set minutes=%minutes:~-2%

set /a seconds=%count% %% 60
set seconds=00%seconds%
set seconds=%seconds:~-2%

if %count% lss 1 (

    powershell -ExecutionPolicy Bypass -File mute.ps1 > $null
    cls
    echo    _______
    echo   / %start_minutes%:%start_seconds% \
    echo  +---------+
    echo  ^|         ^|
    echo  ^|Time Over^|
    echo  ^|         ^|
    echo  +---------+    
    goto :restart
)

cls
    echo    _______
    echo   / %start_minutes%:%start_seconds% \
echo  +---------+
echo  ^|         ^|
echo  ^|  %minutes%:%seconds%  ^|
echo  ^|         ^|
echo  +---------+
rem echo  ^|.........^|

choice /t 1 /c aqs /n /d a >nul

if %errorlevel% equ 2 goto start
if %errorlevel% equ 3 goto paused

set /a count-=1
goto :loop

:paused
cls
echo    _______
echo   / %start_minutes%:%start_seconds% \
echo  +---------+
echo  ^|         ^|
echo  ^|  %minutes%:%seconds%  ^| ^|^|
echo  ^|         ^|
echo  +---------+
pause >nul
goto loop


