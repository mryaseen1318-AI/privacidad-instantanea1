@echo off
echo Creating single executable with nexe...

REM Install nexe globally if not installed
npm list -g nexe || npm install -g nexe

REM Create a simple launcher script
echo const { spawn } = require('child_process');
echo const path = require('path');
echo 
echo const appPath = path.join(__dirname, 'app');
echo const electronPath = path.join(process.execPath, '..', 'electron.exe');
echo 
echo console.log('Starting Privacidad Instantánea...');
echo 
echo const electron = spawn(electronPath, [appPath]);
echo 
echo electron.stdout.on('data', (data) => {
  console.log(`stdout: ${data}`);
});
echo 
echo electron.stderr.on('data', (data) => {
  console.error(`stderr: ${data}`);
});
echo 
echo electron.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
}); > launcher.js

REM Create a temporary directory for the build
if exist "PrivacidadApp" rmdir /s /q PrivacidadApp
mkdir PrivacidadApp

REM Copy app files
xcopy /E /I /Y "privacidad-instantanea" "PrivacidadApp\app"
copy "launcher.js" "PrivacidadApp\"

REM Build the executable
cd PrivacidadApp
echo Building executable...
nexe launcher.js -t windows-x64-14.15.3 -o "PrivacidadInstantanea.exe"

REM Copy the executable to the parent directory
if exist "PrivacidadInstantanea.exe" (
    copy "PrivacidadInstantanea.exe" "..\"
    cd..
    
    echo.
    echo =============================================
    echo  Build successful!
    echo  Executable: %CD%\PrivacidadInstantanea.exe
    echo =============================================
) else (
    echo.
    echo =============================================
    echo  Build failed. Please check the error messages above.
    echo =============================================
)

del launcher.js

pause
