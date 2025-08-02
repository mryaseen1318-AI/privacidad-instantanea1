@echo off
echo Creating Portable ZIP package for Privacidad Instantánea...

REM Create directories
if exist "PrivacidadPortable" rmdir /s /q PrivacidadPortable
mkdir PrivacidadPortable
cd PrivacidadPortable

REM Download Electron if not exists
if not exist "electron-v25.4.0-win32-x64.zip" (
    echo Downloading Electron...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/electron/electron/releases/download/v25.4.0/electron-v25.4.0-win32-x64.zip' -OutFile 'electron-v25.4.0-win32-x64.zip'"
    
    echo Extracting Electron...
    powershell -Command "Expand-Archive -Path 'electron-v25.4.0-win32-x64.zip' -DestinationPath '.' -Force"
)

REM Create app directory
if not exist "app" mkdir app

REM Copy app files from the main project directory
xcopy /E /I /Y "..\privacidad-instantanea\*" "app\"

REM Create launcher
echo @echo off > StartApp.bat
echo start "" "electron.exe" "app" >> StartApp.bat

REM Create README file
echo # Privacidad Instantánea - Portable > README.txt
echo. >> README.txt
echo ## How to Use: >> README.txt
echo 1. Extract this ZIP file to any folder >> README.txt
echo 2. Run 'StartApp.bat' to launch the application >> README.txt
echo 3. For best experience, run as Administrator >> README.txt
echo. >> README.txt
echo ## Features: >> README.txt
echo - Secure File Encryption >> README.txt
echo - Face Recognition >> README.txt
echo - Secure File Deletion >> README.txt
echo - Activity Logging >> README.txt

REM Create ZIP file
echo Creating ZIP archive...
cd..
powershell -Command "Compress-Archive -Path 'PrivacidadPortable\*' -DestinationPath 'PrivacidadInstantanea-Portable.zip' -Force"

echo.
echo =============================================
echo  Portable ZIP created successfully!
echo  File: %CD%\PrivacidadInstantanea-Portable.zip
echo =============================================
pause
