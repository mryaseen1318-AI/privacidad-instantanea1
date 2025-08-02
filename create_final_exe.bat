@echo off
echo Creating final executable package...

REM Create a temporary directory
if exist "PrivacidadFinal" rmdir /s /q PrivacidadFinal
mkdir PrivacidadFinal

REM Download Electron if not already downloaded
if not exist "electron-v25.4.0-win32-x64.zip" (
    echo Downloading Electron...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/electron/electron/releases/download/v25.4.0/electron-v25.4.0-win32-x64.zip' -OutFile 'electron-v25.4.0-win32-x64.zip'"
)

REM Extract Electron
echo Extracting Electron...
powershell -Command "Expand-Archive -Path 'electron-v25.4.0-win32-x64.zip' -DestinationPath 'PrivacidadFinal' -Force"

REM Create app directory
mkdir PrivacidadFinal\resources\app

REM Copy your app files
echo Copying application files...
xcopy /E /I /Y "privacidad-instantanea\*" "PrivacidadFinal\resources\app\"

REM Create a launcher
echo @echo off > PrivacidadFinal\PrivacidadInstantanea.bat
echo start "" "%~dp0electron.exe" "%~dp0resources\app" >> PrivacidadFinal\PrivacidadInstantanea.bat

REM Create a self-extracting archive
echo Creating self-extracting archive...
powershell -Command "Compress-Archive -Path 'PrivacidadFinal\*' -DestinationPath 'PrivacidadInstantanea-Portable.zip' -Force"

REM Cleanup
rmdir /s /q PrivacidadFinal

echo.
echo =============================================
echo  Package created successfully!
echo  File: %CD%\PrivacidadInstantanea-Portable.zip
echo  
echo  To use:
echo  1. Extract the ZIP file to any folder
echo  2. Run 'PrivacidadInstantanea.bat' to start the app
echo =============================================

pause
