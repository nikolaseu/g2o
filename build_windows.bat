REM IMPORTANT: MUST be run from "Developer Command Prompt for VS 2019"!

REM Install dependencies (if not already installed)
set VCPKG_ROOT_DIR=C:\Users\nikol\Projects\vcpkg
set VCPKG_DEFAULT_TRIPLET=x64-windows
call ./script/install-deps-windows.bat

REM set up some env variables
set EIGEN3_INCLUDE_DIR=C:\Users\nikol\Projects\vcpkg\installed\x64-windows\include\eigen3

REM configure
mkdir build
cd build

cmake -G "Visual Studio 16 2019" -A x64 ^
        -DG2O_BUILD_LINKED_APPS=OFF ^
        -DG2O_BUILD_EXAMPLES=OFF ^
        -DBUILD_CSPARSE=ON ^
        -DG2O_USE_OPENGL=OFF ^
        -DG2O_USE_OPENMP=OFF ^
        -DBUILD_SHARED_LIBS=OFF ^
        -DBUILD_LGPL_SHARED_LIBS=OFF ^
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
        -DVCPKG_TARGET_TRIPLET="%VCPKG_DEFAULT_TRIPLET%" ^
        -DCMAKE_TOOLCHAIN_FILE="%VCPKG_ROOT_DIR%\scripts\buildsystems\vcpkg.cmake" ^
        ..

if %errorlevel% neq 0 goto :cmFail

REM build release
MSBuild /m g2o.sln /p:Configuration=Release

if %errorlevel% neq 0 goto :cmFail

REM build debug
MSBuild /m g2o.sln /p:Configuration=Debug

if %errorlevel% neq 0 goto :cmFail

REM everything went fine, just go to end
echo Build succeeded!
goto :cmEnd

REM something failed, notify
:cmFail
echo Build FAILED!

:cmEnd
