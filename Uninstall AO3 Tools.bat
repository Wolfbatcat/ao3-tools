@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -STA -File "%SCRIPT_DIR%_scripts\uninstall-ao3-tools.ps1"
if errorlevel 1 pause
