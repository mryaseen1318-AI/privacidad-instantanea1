@echo off
echo Creating minimal portable package...

REM Create temp directory
if exist "temp_package" rmdir /s /q temp_package
mkdir temp_package

REM Copy only essential files
xcopy /E /I /Y "privacidad-instantanea\src" "temp_package\app\src"
xcopy /E /I /Y "privacidad-instantanea\main.js" "temp_package\app\"
xcopy /E /I /Y "privacidad-instantanea\package.json" "temp_package\app\"

REM Create launcher
echo @echo off > temp_package\StartApp.bat
echo start "" "%~dp0electron.exe" "app" >> temp_package\StartApp.bat

REM Download Electron if not exists
if not exist "electron-v25.4.0-win32-x64.zip" (
    echo Downloading Electron...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/electron/electron/releases/download/v25.4.0/electron-v25.4.0-win32-x64.zip' -OutFile 'electron-v25.4.0-win32-x64.zip'"
    
    echo Extracting Electron...
    powershell -Command "Expand-Archive -Path 'electron-v25.4.0-win32-x64.zip' -DestinationPath 'temp_package' -Force"
) else (
    echo Using existing Electron package...
    powershell -Command "Expand-Archive -Path 'electron-v25.4.0-win32-x64.zip' -DestinationPath 'temp_package' -Force"
)

echo Creating ZIP...
powershell -Command "Compress-Archive -Path 'temp_package\*' -DestinationPath 'PrivacidadInstantanea-Portable.zip' -Force"

REM Cleanup
rmdir /s /q temp_package

echo.
echo =============================================
echo  Portable package created successfully!
echo  File: %CD%\PrivacidadInstantanea-Portable.zip
echo =============================================
pause
