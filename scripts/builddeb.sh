#!/bin/bash
# postbuild script for debian package build. Must be called from the
# git base directory (not the subfolder).

BUILD_NUMBER=$1

set -ex

debdir=output/debian
rm -rf $debdir

script_dir=$(dirname "$0")
cwd=${script_dir}/..
cd $cwd
sh ${script_dir}/compile.sh

version="2.1"

package="svpaseg"
maintainer="jussitohka/SVPASEG <https://github.com/jussitohka/SVPASEG/issues>"
arch="amd64"
echo "package=$package"


echo "Compute md5 checksum."
cd $debdir
mkdir -p DEBIAN
find . -type f ! -regex '.*?debian-binary.*' ! -regex '.*?DEBIAN.*' -printf '%P ' | xargs md5sum > DEBIAN/md5sums
cd $cwd

#date=`date -u +%Y%m%d`
#echo "date=$date"

#gitrev=`git rev-parse HEAD | cut -b 1-8`
gitrevfull=`git rev-parse HEAD`
gitrevnum=`git log --oneline | wc -l | tr -d ' '`
#echo "gitrev=$gitrev"

buildtimestamp=`date -u +%Y%m%d-%H%M%S`
hostname=`hostname`
echo "build machine=${hostname}"
echo "build time=${buildtimestamp}"
echo "gitrevfull=$gitrevfull"
echo "gitrevnum=$gitrevnum"

debian_revision="${gitrevnum}"
upstream_version="${version}"
echo "upstream_version=$upstream_version"
echo "debian_revision=$debian_revision"

packageversion="${upstream_version}-github${debian_revision}"
packagename="${package}_${packageversion}_${arch}"
echo "packagename=$packagename"
packagefile="${packagename}.deb"
echo "packagefile=$packagefile"

description="build machine=${hostname}, build time=${buildtimestamp}, git revision=${gitrevfull}"
if [ ! -z ${BUILD_NUMBER} ]; then
    echo "build number=${BUILD_NUMBER}"
    description="$description, build number=${BUILD_NUMBER}"
fi

installedsize=`du -s $debdir/ | awk '{print $1}'`

#for format see: https://www.debian.org/doc/debian-policy/ch-controlfields.html
cat > $debdir/DEBIAN/control << EOF |
Section: science
Priority: extra
Maintainer: $maintainer
Version: $packageversion
Package: $package
Architecture: $arch
Installed-Size: $installedsize
Description: $description
EOF

echo "Creating .deb file: $packagefile"
rm -f ${package}_*.deb
fakeroot dpkg-deb --build $debdir $packagefile

echo "Package info"
dpkg -I $packagefile
