@echo off
echo Creating final ZIP package...

REM Create temp directory
if exist "PrivacidadApp" rmdir /s /q PrivacidadApp
mkdir PrivacidadApp

REM Copy essential files
xcopy /E /I /Y "privacidad-instantanea\src" "PrivacidadApp\src"
xcopy /E /I /Y "privacidad-instantanea\main.js" "PrivacidadApp\"
xcopy /E /I /Y "privacidad-instantanea\package.json" "PrivacidadApp\"

REM Create launcher
echo @echo off > PrivacidadApp\StartApp.bat
echo start "" "%~dp0node_modules\.bin\electron" "%~dp0" >> PrivacidadApp\StartApp.bat

echo Installing dependencies...
cd PrivacidadApp
call npm install electron@25.4.0 --save-dev
cd..

echo Creating final ZIP...
powershell -Command "Compress-Archive -Path 'PrivacidadApp\*' -DestinationPath 'PrivacidadInstantanea-Final.zip' -Force"

REM Cleanup
rmdir /s /q PrivacidadApp

echo.
echo =============================================
echo  Final ZIP created successfully!
echo  File: %CD%\PrivacidadInstantanea-Final.zip
echo =============================================
pause
