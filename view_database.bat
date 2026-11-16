@echo off
title View Users Database
echo ========================================================
echo   Dang doc du lieu tu database bang users...
echo ========================================================

powershell -NoProfile -ExecutionPolicy Bypass -Command "$jars = (Get-ChildItem 'C:\Users\bo\.m2\repository' -Recurse -Filter '*.jar' | Select-Object -ExpandProperty FullName) -join ';'; & 'C:\Program Files\Amazon Corretto\jdk21.0.13_0\bin\java.exe' -cp ('%~dp0target\classes;%~dp0target\test-classes;' + $jars) vn.iotstar.test.ViewDatabase"

echo.
pause
