@echo off
setlocal
cd /d "%~dp0"

:: 1. Kiem tra va tu dong yeu cau quyen Administrator neu can
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [Thong bao] Dang yeu cau quyen Administrator de cap nhat Tomcat...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title ShoppingServletServiceMVC - One-Click Runner
echo ========================================================
echo   Dang khoi dong du an Shopping Servlet Service MVC...
echo ========================================================

:: 2. Thiet lap moi truong Java va Maven
set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk21.0.13_0"
set "JRE_HOME=C:\Program Files\Amazon Corretto\jdk21.0.13_0"
set "CATALINA_HOME=C:\apache-tomcat-11.0.27"
set "CATALINA_BASE=C:\apache-tomcat-11.0.27"
set "PATH=%JAVA_HOME%\bin;C:\maven\apache-maven-3.9.16\bin;%PATH%"

echo [1/4] Dung Tomcat cu va giai phong cong 8080, 8005...
call "%CATALINA_HOME%\bin\shutdown.bat" 2>nul
timeout /t 2 /nobreak > nul

:: Giai phong hoan toan cong 8080 va 8005 neu con tien trinh chiem giu
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080 ^| findstr LISTENING 2^>nul') do (
    echo   Giai phong PID %%a tren cong 8080...
    taskkill /f /pid %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8005 ^| findstr LISTENING 2^>nul') do (
    echo   Giai phong PID %%a tren cong 8005...
    taskkill /f /pid %%a >nul 2>&1
)
timeout /t 1 /nobreak > nul

echo [2/4] Dong goi du an bang Maven (Build WAR moi nhat)...
call mvn clean package "-Dmaven.test.skip=true"
if errorlevel 1 (
    echo.
    echo [Loi] Build Maven that bai! Vui long kiem tra loi code o tren.
    pause
    exit /b 1
)

echo.
echo [3/4] Don dep thu muc webapps, cache work va Trien khai file WAR vao Tomcat 11...
rd /s /q "%CATALINA_HOME%\webapps\ROOT" 2>nul
rd /s /q "%CATALINA_HOME%\webapps\ShoppingServletServiceMVC" 2>nul
del /f /q "%CATALINA_HOME%\webapps\ROOT.war" 2>nul
del /f /q "%CATALINA_HOME%\webapps\ShoppingServletServiceMVC.war" 2>nul
rd /s /q "%CATALINA_HOME%\work\Catalina\localhost\ROOT" 2>nul
rd /s /q "%CATALINA_HOME%\work\Catalina\localhost\ShoppingServletServiceMVC" 2>nul

copy /Y "%~dp0target\ShoppingServletServiceMVC.war" "%CATALINA_HOME%\webapps\ROOT.war"
copy /Y "%~dp0target\ShoppingServletServiceMVC.war" "%CATALINA_HOME%\webapps\ShoppingServletServiceMVC.war"

if errorlevel 1 (
    echo.
    echo [Loi] Khong the copy file WAR vao %CATALINA_HOME%\webapps\
    echo Vui long tat Tomcat cu hoac chuot phai vao file run.bat va chon "Run as administrator"!
    pause
    exit /b 1
)

echo [4/4] Khoi dong Apache Tomcat 11...
cd /d "%CATALINA_HOME%\bin"
call startup.bat
cd /d "%~dp0"

echo.
echo ========================================================
echo   Tomcat da khoi dong thanh cong!
echo   Dang tu dong mo trinh duyet den: http://localhost:8080/home
echo ========================================================

timeout /t 6 /nobreak > nul
start http://localhost:8080/home

exit
