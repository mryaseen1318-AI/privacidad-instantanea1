@echo off
echo Creating single .exe file...

REM Install pkg if not installed
npm list -g pkg || npm install -g pkg

REM Create a temporary package.json for the build
if exist temp_install rmdir /s /q temp_install
mkdir temp_install
cd temp_install

REM Create package.json
echo {
  "name": "privacidad-app",
  "version": "1.0.0",
  "description": "Privacidad Instantánea",
  "main": "app.js",
  "bin": "app.js",
  "pkg": {
    "assets": ["src/**/*"],
    "targets": ["node16-win-x64"],
    "outputPath": "dist"
  },
  "dependencies": {}
} > package.json

REM Create a simple launcher
echo const { spawn } = require('child_process');
echo const path = require('path');
echo const fs = require('fs');
echo 
echo // Path to the actual app
const appPath = path.join(__dirname, 'app');
echo 
// Check if app directory exists
if (!fs.existsSync(appPath)) {
  console.error('Error: App directory not found!');
  process.exit(1);
}

// Start the actual Electron app
const electron = spawn('electron', [appPath]);

electron.stdout.on('data', (data) => {
  console.log(`stdout: ${data}`);
});

electron.stderr.on('data', (data) => {
  console.error(`stderr: ${data}`);
});

electron.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
}); > app.js

REM Copy app files
xcopy /E /I /Y "..\privacidad-instantanea" "app"

REM Install dependencies
npm install electron@25.4.0

REM Build the executable
echo Building executable...
npx pkg . --targets node16-win-x64 --output "PrivacidadInstantanea.exe"

REM Move the executable to the parent directory
if exist "PrivacidadInstantanea.exe" (
    move /Y "PrivacidadInstantanea.exe" "..\"
    cd..
    rmdir /s /q temp_install
    
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

pause
