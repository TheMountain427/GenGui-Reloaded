@echo off
setlocal

REM Change to the drive where the script is located
cd /d %~dp0

REM Run PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "GenGui-Reloaded-v0.7.ps1"

pause