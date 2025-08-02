@echo off
setlocal enabledelayedexpansion

echo Searching for files larger than 5MB...
echo.

dir /s /a:-d /o:-s | find "File(s)" | find "bytes"

echo.
echo Large files found:
echo ================

for /f "tokens=*" %%a in ('dir /s /a:-d /o:-s ^| find "File(s)" ^| find "bytes"') do (
    set "line=%%a"
    set "size=!line:~-20,20!
    set "size=!size: =!"
    
    for /f "tokens=1 delims= " %%b in ("!size!") do (
        set "size_mb=%%b"
        set /a size_mb=!size_mb:/1024/1024=! 2>nul
        
        if !size_mb! GTR 5 (
            echo !line!
        )
    )
)

echo.
echo Note: This is a simplified check. For more accurate results,
echo you might want to use a more advanced tool or check manually.

pause
