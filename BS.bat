@echo off
title Batch Pokemon Card Database
setlocal enabledelayedexpansion

:login
set "inputUsername="
set "inputPassword="
echo Welcome to the Base set pokemon card database
echo ---------------------------------------------
echo Please login (CaPs SeNsItIvE)
set /p "inputUsername=Enter Username: "
set /p "inputPassword=Enter Password: "
set "credentialsFile=credentials.txt"
set "validCredentials="

for /f "tokens=1,2 delims==" %%a in (%credentialsFile%) do (
    if "%inputUsername%"=="%%a" if "%inputPassword%"=="%%b" set "validCredentials=true"
)

if defined validCredentials (
    set "user=%inputUsername%"
    set "userFile=users\%user%.txt"
    color 0a
    cls
    echo Login successful!
    timeout /t 1 /nobreak >nul
    cls
    goto search
) else (
    cls
    color 04
    echo Invalid credentials. Please try again.
    timeout /t 1 /nobreak >nul
    cls
    color 07
    goto login
)

:search
title Welcome, %user%
cls
color 07
echo Welcome, %user%.
echo.
echo To search your inventory for a card, search a ID, then a - then the name of the Pokemon.
echo for example 29-Haunter or 96-Double Colorless Energy
echo.
set /p "search=Search your inventory: "
echo Searching for: "%search%"
pause
if "%search%"=="" (
    echo Invalid search string. Press any key to continue searching...
    pause >nul
    goto search
)

call :checkCard "%search%"
if errorlevel 1 (
    echo Card not found. Press any key to continue searching...
    pause >nul
    goto search
) else (
    echo Card found!
    call :addCard "%search%"
)
pause
goto end

:checkCard
set "cardFile=card_database.txt"
set "userFile=users\%user%.txt"
set "card=%~1"
set "cardName=%card:*-=%"
findstr /i "%cardName%" "%userFile%" >nul
if %errorlevel% equ 0 (
    echo You own the card: %cardName%
) else (
    echo You do not own the card: %cardName%
)
exit /b


:addCard
set "userFile=users\%user%.txt"
echo %1>> "!userFile!"
exit /b

:end
pause

