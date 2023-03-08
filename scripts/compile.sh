set -e

script_dir=$(dirname "$0")
cwd=${script_dir}/..

builddir=output/build

# make
USE_ORIGINAL_MAKE=false
if $USE_ORIGINAL_MAKE; then

cd deps/SVPASEG/src/
make clean; rm -rf ../bin/; mkdir -p ../bin/
n=`nproc --ignore=1`
make -j $n
cd $cwd
mkdir -p $builddir/../debian/usr/
cp -r deps/SVPASEG/bin $builddir/../debian/usr/
mkdir -p $builddir/../debian/usr/share/svpaseg/
cp -r deps/SVPASEG/atlasspecs $builddir/../debian/usr/share/svpaseg/

else

mkdir -p $builddir
cd $builddir
cmake ../.. \
-DCMAKE_INSTALL_PREFIX=../debian/usr \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
-DCMAKE_CXX_FLAGS="-Wno-write-strings -Wno-register" \
-DCMAKE_EXE_LINKER_FLAGS="-static"

n=`nproc --ignore=1`
make -j $n install
cd $cwd

fi
