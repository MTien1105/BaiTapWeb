@echo off
title Stopping Tomcat 11...
echo Stopping Apache Tomcat 11...
set "CATALINA_HOME=C:\apache-tomcat-11.0.27"
set "CATALINA_BASE=C:\apache-tomcat-11.0.27"
cd /d "C:\apache-tomcat-11.0.27\bin"
call shutdown.bat
cd /d "%~dp0"
echo Done.
pause
