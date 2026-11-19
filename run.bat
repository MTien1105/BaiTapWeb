@echo off
title ShoppingServletServiceMVC - One-Click Runner
echo ========================================================
echo   Dang khoi dong du an Shopping Servlet Service MVC...
echo ========================================================

echo [1/3] Dong goi du an bang Maven...
call mvn package -DskipTests
if errorlevel 1 (
    echo [Loi] Build Maven that bai!
    pause
    exit /b 1
)

echo [2/3] Don dep va Sao chep file WAR vao Apache Tomcat 11...
rd /s /q "C:\apache-tomcat-11.0.27\webapps\ROOT" 2>nul
rd /s /q "C:\apache-tomcat-11.0.27\webapps\ShoppingServletServiceMVC" 2>nul

copy /Y "%~dp0target\ShoppingServletServiceMVC.war" "C:\apache-tomcat-11.0.27\webapps\ShoppingServletServiceMVC.war"
copy /Y "%~dp0target\ShoppingServletServiceMVC.war" "C:\apache-tomcat-11.0.27\webapps\ROOT.war"
if errorlevel 1 (
    echo [Loi] Khong the copy vao C:\apache-tomcat-11.0.27\webapps\
    echo Vui long chuot phai vao file run.bat va chon "Run as administrator"!
    pause
    exit /b 1
)

echo [3/3] Khoi dong Apache Tomcat 11...
set "CATALINA_HOME=C:\apache-tomcat-11.0.27"
set "CATALINA_BASE=C:\apache-tomcat-11.0.27"
cd /d "C:\apache-tomcat-11.0.27\bin"
call startup.bat
cd /d "%~dp0"

echo.
echo ========================================================
echo   Tomcat da khoi dong thanh cong!
echo   Dang tu dong mo trinh duyet...
echo ========================================================

timeout /t 5 /nobreak > nul
start http://localhost:8080/home

exit
