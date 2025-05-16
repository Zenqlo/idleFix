@ECHO off
REM Author: Zenqlo
REM Version: v0.0.3
REM Date: 2025-05-16
REM Description: This script installs the task scheduler for idle fix.

REM Configuration - Change this name to customize the installation
set "APP_NAME=iCloudFix"
set "ProcessToFix=iCloudHome"
set "INSTALL_DIR=%APPDATA%\%APP_NAME%"
set "DESCRIPTION=Automatically fixes high CPU usage of %ProcessToFix% when display is off"

REM Create task scheduler folder
echo.

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
    echo Created task scheduler folder: "%INSTALL_DIR%"
) else (
    echo Task scheduler folder already exists
)
echo.

REM Copy and modify PS1 script file
if exist "%INSTALL_DIR%\Fix.ps1" (
    echo Found existing PS1 script, replacing it with new version...
    del "%INSTALL_DIR%\Fix.ps1"
)

REM First copy the file
copy "%~dp0TaskScheduler\Fix.ps1" "%INSTALL_DIR%\Fix.ps1" /Y

REM Then modify the variables using PowerShell (single line command)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$content = Get-Content -Path '%INSTALL_DIR%\Fix.ps1' -Raw; $content = $content -replace '\$AppName = \".*?\"', '$AppName = \"%APP_NAME%\"' -replace '\$ProcessToFix = \".*?\"', '$ProcessToFix = \"%ProcessToFix%\"'; [System.IO.File]::WriteAllText('%INSTALL_DIR%\Fix.ps1', $content)"

echo Installed PS1 script to: "%INSTALL_DIR%\Fix.ps1"

REM Copy launch file
if exist "%INSTALL_DIR%\Launch.vbs" (
    echo Found existing VBS launch file, replacing it with new version...
    del "%INSTALL_DIR%\Launch.vbs"
)
copy "%~dp0TaskScheduler\Launch.vbs" "%INSTALL_DIR%\Launch.vbs" /Y
echo Installed VBS launcher to: "%INSTALL_DIR%\Launch.vbs"

REM Create temporary XML with replaced values
powershell -NoProfile -ExecutionPolicy Bypass -Command "$content = Get-Content -Path '%~dp0TaskScheduler\TaskScheduler_Settings.xml' -Raw; $content = $content -replace '##APP_NAME##', '%APP_NAME%' -replace '##DESCRIPTION##', '%DESCRIPTION%' -replace '##VBS_PATH##', '%INSTALL_DIR%\Launch.vbs'; [System.IO.File]::WriteAllText('%INSTALL_DIR%\Task.xml', $content)"

REM Create task scheduler task
echo.
schtasks /create /tn "%APP_NAME%" /xml "%INSTALL_DIR%\Task.xml" /F
echo.

REM Clean up temporary XML
del "%INSTALL_DIR%\Task.xml"

if %ERRORLEVEL%==0 (    
    echo Task Name: %APP_NAME%
    echo Description: %DESCRIPTION%
    echo.
    echo Task file and log file Location: %INSTALL_DIR%
    echo.
    echo Task scheduler setup complete.
) else (
    echo ERROR: Task creation failed with code %ERRORLEVEL%.
    if %ERRORLEVEL%==1 (
        echo DESCRIPTION: Access denied or invalid arguments. Run as Administrator and verify XML syntax.
    ) else if %ERRORLEVEL%==2 (
        echo DESCRIPTION: The system cannot find the file specified. Check if TaskScheduler.xml exists in the script directory.
    ) else if %ERRORLEVEL%==5 (
        echo DESCRIPTION: Access denied. Run the script as Administrator.
    ) else if %ERRORLEVEL%==87 (
        echo DESCRIPTION: Invalid parameter or XML format. Check TaskScheduler.xml for errors.
    ) else if %ERRORLEVEL%==1355 (
        echo DESCRIPTION: Invalid user or group in XML. Verify the Principal section.
    ) else (
        echo DESCRIPTION: Unknown error. Verify the XML file and Task Scheduler permissions.
    )
)
echo.

pause







