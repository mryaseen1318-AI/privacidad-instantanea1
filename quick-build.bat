@echo off
echo Installing required packages...
call npm install electron-packager -g
call npm install

echo Building Windows app...
call npx electron-packager . "Privacidad Instantanea" --platform=win32 --arch=x64 --overwrite --asar --prune=true --out=release-builds --version-string.CompanyName="Privacidad" --version-string.FileDescription="Secure File Protection" --version-string.ProductName="Privacidad Instantanea"

echo Build complete! Check the release-builds folder.
pause
