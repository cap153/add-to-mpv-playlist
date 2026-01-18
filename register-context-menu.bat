@echo off
:: Force execution in the current directory
cd /d "%~dp0"

:: --- Step 1: Check Administrator Privileges ---
net session >nul 2>&1
if %errorlevel% neq 0 goto :NoAdmin

:: --- Step 2: Prepare Paths ---
set "WORK_DIR=%~dp0"
:: Remove trailing backslash if present
if "%WORK_DIR:~-1%"=="\" set "WORK_DIR=%WORK_DIR:~0,-1%"

:: Replace single backslash with double backslash for Registry format
set "ESCAPED_DIR=%WORK_DIR:\=\\%"

echo ---------------------------------------------------
echo Installing "Add to mpv playlist" context menu...
echo Target Path: %WORK_DIR%
echo ---------------------------------------------------

:: --- Step 3: Generate Registry File ---
set "REG_FILE=%WORK_DIR%\temp_mpv_install.reg"

:: Write Header
echo Windows Registry Editor Version 5.00 > "%REG_FILE%"
echo. >> "%REG_FILE%"

:: Write Menu Entry
echo [HKEY_CLASSES_ROOT\*\shell\mpv_add] >> "%REG_FILE%"
echo @="Add to mpv playlist" >> "%REG_FILE%"
echo "Icon"="%ESCAPED_DIR%\\mpv.exe" >> "%REG_FILE%"
echo. >> "%REG_FILE%"

:: Write Command Entry
echo [HKEY_CLASSES_ROOT\*\shell\mpv_add\command] >> "%REG_FILE%"
echo @="powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File \"%ESCAPED_DIR%\\mpv-add.ps1\" \"%%1\"" >> "%REG_FILE%"

:: --- Step 4: Import Registry ---
regedit /s "%REG_FILE%"

:: Clean up temp file
if exist "%REG_FILE%" del "%REG_FILE%"

goto :Success

:: --- Error Handling / Messages ---
:NoAdmin
echo.
echo [ERROR] Administrator privileges required.
echo Please right-click this file and select "Run as administrator".
echo.
goto :End

:Success
echo.
echo [SUCCESS] Context menu installed successfully!
echo.
goto :End

:End
echo Press any key to exit...
pause >nul