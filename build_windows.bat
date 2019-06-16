REM IMPORTANT: MUST be run from x64 Native Tools Command Prompt for VS 2017!

REM Install dependencies (if not already installed)
set VCPKG_ROOT_DIR=C:\Users\nikol\Projects\vcpkg
set VCPKG_DEFAULT_TRIPLET=x64-windows
call ./script/install-deps-windows.bat

REM set up some env variables
set CMAKE_EXE=C:\Users\nikol\Projects\vcpkg\downloads\tools\cmake-3.12.4-windows\cmake-3.12.4-win32-x86\bin\cmake.exe
set EIGEN3_INCLUDE_DIR=C:\Users\nikol\Projects\vcpkg\installed\x64-windows\include\eigen3

REM configure
mkdir build
cd build

%CMAKE_EXE% -G "Visual Studio 15 2017 Win64" ^
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

REM build release
MSBuild /m g2o.sln /p:Configuration=Release

REM build debug
MSBuild /m g2o.sln /p:Configuration=Debug

