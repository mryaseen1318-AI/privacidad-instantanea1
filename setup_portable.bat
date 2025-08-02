@echo off
echo Setting up Privacidad Instantánea Portable...

REM Create directories
if not exist "PrivacidadPortable" mkdir PrivacidadPortable
cd PrivacidadPortable

REM Download Electron
if not exist "electron-v25.4.0-win32-x64.zip" (
    echo Downloading Electron...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/electron/electron/releases/download/v25.4.0/electron-v25.4.0-win32-x64.zip' -OutFile 'electron-v25.4.0-win32-x64.zip'"
    
    echo Extracting...
    powershell -Command "Expand-Archive -Path 'electron-v25.4.0-win32-x64.zip' -DestinationPath '.' -Force"
)

REM Create launcher
echo Creating launcher...
echo @echo off > StartApp.bat
echo start "" "electron.exe" "%~dp0app" >> StartApp.bat

REM Create app directory
if not exist "app" mkdir app

REM Copy your app files
xcopy /E /I /Y "..\privacidad-instantanea\*" "app\"

echo Setup complete! Run StartApp.bat to launch the application.
pause
