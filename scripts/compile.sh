set -e

script_dir=$(dirname "$0")
cwd=${script_dir}/..

builddir=output/build

# make
mkdir -p $builddir
cd $builddir
cmake ../.. \
-DCMAKE_INSTALL_PREFIX=../debian/usr \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
-DCMAKE_EXE_LINKER_FLAGS="-static"

n=`nproc --ignore=1`
make -j $n install
cd $cwd
