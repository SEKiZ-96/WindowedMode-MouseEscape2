@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo === WindowedMode 2.2 MouseEscape source build ===
echo Requires: Git, VS2022 C++ Desktop workload, Windows x86 toolchain.
where git >nul 2>&1
if errorlevel 1 (
 echo ERROR: Git is required to fetch missing submodules.
 exit /b 1
)
if not exist "external\IniReader\IniReader.h" (
 echo Fetching IniReader...
 git clone https://github.com/ThirteenAG/IniReader external\IniReader
 if errorlevel 1 exit /b 1
)
if not exist "external\injector\include\injector\injector.hpp" (
 echo Fetching injector and nested dependencies...
 git clone --recursive https://github.com/ThirteenAG/injector external\injector
 if errorlevel 1 exit /b 1
)
echo Building Visual Studio project files...
premake5.exe vs2022
if errorlevel 1 (
 echo ERROR: Premake failed (possibly incompatible Premake version).
 exit /b 1
)
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
 echo ERROR: VS2022 not found.
 exit /b 1
)
set "MSBUILD="
for /f "usebackq delims=" %%I in (`"%VSWHERE%" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do if not defined MSBUILD set "MSBUILD=%%I"
if not defined MSBUILD (
 echo ERROR: MSBuild not found.
 exit /b 1
)
echo Compiling Release Win32...
"%MSBUILD%" "build\III.VC.SA.WindowedMode.sln" /m /p:Configuration=Release /p:Platform=Win32
if errorlevel 1 (
 echo ERROR: Compilation failed. Check if latest submodules are API-compatible with 2.2.
 exit /b 1
)
echo Build attempted. Look in data\ or build output for III.VC.SA.WindowedMode.asi.
echo Do NOT install alongside another WindowedMode ASI.
pause
