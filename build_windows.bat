REM IMPORTANT: MUST be run from "Developer Command Prompt for VS 2019"!

REM set BUILD_TYPE=Release
set BUILD_TYPE=RelWithDebInfo
REM set BUILD_TYPE=Debug

set STARTING_DIR=%cd%
set SRC_DIR=%cd%
set BUILD_DIR=%STARTING_DIR%\build\%BUILD_TYPE%
set INSTALL_DIR=%STARTING_DIR%\install\%BUILD_TYPE%

REM Install dependencies (if not already installed)
set VCPKG_ROOT_DIR=C:\Users\nikol\Projects\vcpkg
set VCPKG_DEFAULT_TRIPLET=x64-windows
call ./script/install-deps-windows.bat

REM set up some env variables
set Qt5_DIR=C:\Qt\5.14.0\msvc2017_64
set EIGEN3_INCLUDE_DIR=C:\Users\nikol\Projects\vcpkg\installed\x64-windows\include\eigen3
set QGLVIEWER_DIR=C:\Users\nikol\Projects\libQGLViewer\QGLViewer
set QGLVIEWER_INCLUDE_DIR=%QGLVIEWER_DIR%
set QGLVIEWER_LIBRARY=%QGLVIEWER_DIR%\QGLViewer2.lib

REM configure
md %BUILD_DIR%
cd %BUILD_DIR%

cmake -GNinja %SRC_DIR% ^
        -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
        -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
        -DG2O_BUILD_LINKED_APPS=ON ^
        -DG2O_BUILD_EXAMPLES=OFF ^
        -DBUILD_CSPARSE=ON ^
        -DG2O_USE_OPENGL=ON ^
        -DG2O_USE_OPENMP=OFF ^
        -DBUILD_SHARED_LIBS=ON ^
        -DBUILD_LGPL_SHARED_LIBS=ON ^
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
        -DVCPKG_TARGET_TRIPLET="%VCPKG_DEFAULT_TRIPLET%" ^
        -DCMAKE_TOOLCHAIN_FILE="%VCPKG_ROOT_DIR%\scripts\buildsystems\vcpkg.cmake" ^
        -DQGLVIEWER_INCLUDE_DIR=%QGLVIEWER_INCLUDE_DIR% ^
        -DQGLVIEWER_LIBRARY=%QGLVIEWER_LIBRARY%

if %errorlevel% neq 0 goto :cmFail

REM build and install
cmake --build . --target install --config %BUILD_TYPE%
if %errorlevel% neq 0 goto :cmFail

REM deploy Qt libs for viewer
%Qt5_DIR%/bin/windeployqt -xml %INSTALL_DIR%/bin/g2o_viewer_rd.exe
if %errorlevel% neq 0 goto :cmFail

REM copy QGLViewer dll
copy "%QGLVIEWER_DIR%\QGLViewer2.dll" "%INSTALL_DIR%\bin"
if %errorlevel% neq 0 goto :cmFail

REM everything went fine, just go to end
echo Build succeeded!
goto :cmEnd

REM something failed, notify
:cmFail
echo Build FAILED!

:cmEnd
cd %STARTING_DIR%
