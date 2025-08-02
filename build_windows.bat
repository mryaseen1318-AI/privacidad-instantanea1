@echo off
echo Creating standalone Windows executable...

REM Install electron-packager globally if not installed
where electron-packager >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing electron-packager...
    npm install -g electron-packager
)

REM Build the app
echo Building Windows executable...
electron-packager . "PrivacidadInstantanea" --platform=win32 --arch=x64 --overwrite --asar --prune=true --out=release-builds --version-string.CompanyName="Privacidad" --version-string.FileDescription="Secure File Protection" --version-string.ProductName="Privacidad Instantanea"

if exist "release-builds\PrivacidadInstantanea-win32-x64" (
    echo.
    echo =============================================
    echo  Build successful!
    echo  Executable is in: %CD%\release-builds\PrivacidadInstantanea-win32-x64
    echo  Run 'PrivacidadInstantanea.exe' to start the application.
    echo =============================================
) else (
    echo.
    echo =============================================
    echo  Build failed. Please check the error messages above.
    echo =============================================
)

pause
