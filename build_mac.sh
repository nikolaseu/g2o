# Install dependencies (if not already installed)
sh ./script/install-deps-osx.sh

# configure
mkdir build
cd build

cmake \
        -DG2O_BUILD_APPS=OFF \
        -DG2O_BUILD_LINKED_APPS=OFF \
        -DG2O_BUILD_EXAMPLES=OFF \
        -DBUILD_CSPARSE=OFF \
        -DG2O_USE_OPENGL=OFF \
        -DG2O_USE_OPENMP=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_LGPL_SHARED_LIBS=OFF \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        ..

# build
make -j6
