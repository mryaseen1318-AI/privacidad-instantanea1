@echo off
echo Installing electron-builder...
npm install electron-builder --save-dev

echo Building Windows executable...
npx electron-builder build --win --x64

if exist "dist\Privacidad Instantanea Setup.exe" (
    echo.
    echo =============================================
    echo  Build successful!
    echo  Installer is in: %CD%\dist
    echo  Run 'Privacidad Instantanea Setup.exe' to install the application.
    echo =============================================
) else (
    echo.
    echo =============================================
    echo  Build failed. Please check the error messages above.
    echo =============================================
)

pause
