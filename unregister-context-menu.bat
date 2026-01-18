@echo off
cd /d "%~dp0"

:: --- Check Administrator Privileges ---
net session >nul 2>&1
if %errorlevel% neq 0 goto :NoAdmin

:: --- Execute Removal ---
echo ---------------------------------------------------
echo Removing MPV context menu...
echo ---------------------------------------------------

reg delete "HKEY_CLASSES_ROOT\*\shell\mpv_add" /f >nul 2>&1

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Context menu removed.
) else (
    echo.
    echo [INFO] Menu not found or already removed.
)
goto :End

:NoAdmin
echo.
echo [ERROR] Administrator privileges required.
echo Please right-click this file and select "Run as administrator".
echo.
goto :End

:End
echo Press any key to exit...
pause >nul