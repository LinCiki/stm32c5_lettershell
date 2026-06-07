@echo off
setlocal

set "PRESET=debug_GCC_STM32C562RET6"
set "ROOT_DIR=%~dp0"
set "BUILD_DIR=%ROOT_DIR%build\%PRESET%"
set "CMAKE_DIR=C:\Program Files\CMake\bin"
set "NINJA_DIR=C:\Program Files (x86)\ninja-win"
set "ARM_GCC_DIR=C:\Program Files\Arm\GNU Toolchain mingw-w64-x86_64-arm-none-eabi\bin"

where cmake >nul 2>nul
if errorlevel 1 if exist "%CMAKE_DIR%\cmake.exe" set "PATH=%CMAKE_DIR%;%PATH%"

where ninja >nul 2>nul
if errorlevel 1 if exist "%NINJA_DIR%\ninja.exe" set "PATH=%NINJA_DIR%;%PATH%"

where arm-none-eabi-gcc >nul 2>nul
if errorlevel 1 if exist "%ARM_GCC_DIR%\arm-none-eabi-gcc.exe" set "PATH=%ARM_GCC_DIR%;%PATH%"

if /I "%~1"=="clean" (
    echo Cleaning "%BUILD_DIR%"...
    if exist "%BUILD_DIR%" rmdir /S /Q "%BUILD_DIR%"
    shift
)

if not "%~1"=="" set "PRESET=%~1"
set "BUILD_DIR=%ROOT_DIR%build\%PRESET%"

where cmake >nul 2>nul
if errorlevel 1 (
    echo Error: cmake was not found in PATH.
    echo Please install CMake and add it to PATH.
    exit /B 1
)

where ninja >nul 2>nul
if errorlevel 1 (
    echo Error: ninja was not found in PATH.
    echo Please install Ninja and add it to PATH.
    exit /B 1
)

where arm-none-eabi-gcc >nul 2>nul
if errorlevel 1 (
    echo Error: arm-none-eabi-gcc was not found in PATH.
    echo Please install Arm GNU Toolchain and add it to PATH.
    exit /B 1
)

pushd "%ROOT_DIR%" || exit /B 1

echo Configuring preset "%PRESET%"...
cmake --preset "%PRESET%"
if errorlevel 1 (
    popd
    exit /B 1
)

echo Building preset "%PRESET%"...
cmake --build --preset "%PRESET%"
if errorlevel 1 (
    popd
    exit /B 1
)

echo.
echo Build completed successfully.
echo Output directory: "%BUILD_DIR%"

popd
endlocal
