@echo off
cd %~dp0

reg add HKLM\Software\AdminTest /f > nul 2> nul
if %errorlevel% neq 0 ( goto UACPrompt ) else ( goto gotAdmin )
:UACPrompt
echo Set app = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo app.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
timeout /t 2 /nobreak > nul
"%temp%\getadmin.vbs"
exit /b
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
reg delete HKLM\Software\AdminTest /f > nul 2> nul

activate.exe -ServerList servers.txt
pause > nul
