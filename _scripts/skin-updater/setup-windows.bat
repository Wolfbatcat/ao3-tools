@echo off
setlocal enabledelayedexpansion

REM Determine project root
if exist ".git" (
    set "root=."
) else if exist "..\.git" (
    set "root=.."
) else (
    echo Error: .git folder not found
    pause
    exit /b 1
)

echo Installing AO3 Skin Updater...

REM Use Node.js to write hook with guaranteed LF line endings (avoids CRLF issues)
node -e "var fs=require('fs');fs.mkdirSync('!root!\.git\hooks',{recursive:true});fs.writeFileSync('!root!\.git\hooks\pre-commit','#!/bin/sh\nnode _scripts/skin-updater/skin-updater.js\n',{encoding:'utf8'});" >nul 2>&1

REM Add .gitattributes entry to prevent git autocrlf from corrupting the hook source
node -e "var fs=require('fs'),p='!root!\.gitattributes',rule='\n_scripts/skin-updater/pre-commit text eol=lf\n',c='';try{c=fs.readFileSync(p,'utf8')}catch(e){}if(!c.includes('_scripts/skin-updater/pre-commit')){fs.writeFileSync(p,c+rule,'utf8');}" >nul 2>&1

if exist "!root!\.git\hooks\pre-commit" (
    echo ✓ Installed
    echo.
    echo Add to your CSS metadata:
    echo   - Updated:      2026-04-18 14:32 UTC
) else (
    echo ✗ Installation failed
    pause
    exit /b 1
)

pause