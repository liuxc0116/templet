#!/bin/bash

#
name=Your-Program-Name
version=Your-Program-Version
release=R
platform="`lsb_release -i | cut -f2``lsb_release -r | cut -f2`-kernal`uname -r`-`uname -i`"
#tmp path
DEB_BUILD_ROOT="/tmp/${name}"
DEB_PATH="$DEB_BUILD_ROOT/DEBIAN"
DEB_CONTROL_FILE_PATH="$DEB_PATH/control"

DEB_PREINST_FILE_PATH="$DEB_PATH/preinst"
DEB_POSTINST_FILE_PATH="$DEB_PATH/postinst"

DEB_PRERM_FILE_PATH="$DEB_PATH/prerm"
DEB_POSTRM_FILE_PATH="$DEB_PATH/postrm"

#bulid
./configure
if [[ $? -ne 0 ]]; then exit 1;fi
sleep 2

#echo "Make now"
make
if [[ $? -ne 0 ]]; then exit 1;fi
sleep 2
#echo "Make install now"
test -d $DEB_BUILD_ROOT && rm -rf $DEB_BUILD_ROOT
mkdir -p $DEB_PATH
DESTDIR=$DEB_BUILD_ROOT make install
if [[ $? -ne 0 ]]; then exit 1;fi

#mv all conf to conf.default
cp -f DEBIAN/* $DEB_PATH

#control
cat > $DEB_CONTROL_FILE_PATH << EOF
Package: ${name}
Version: ${version}
Architecture: amd64
Maintainer: Your-Program-Maintainer
Installed-Size: 
Depends: Your-Program-Depends
Suggests: ca-certificates
Section: utils
Priority: optional
Description: Your-Program-Description
EOF

#change mod
chmod +x $DEB_PREINST_FILE_PATH $DEB_POSTINST_FILE_PATH  $DEB_PRERM_FILE_PATH $DEB_POSTRM_FILE_PATH

#for binfile in `find /tmp/fc/  -type f |xargs file|grep ELF|awk -F : '{print $1}'|xargs`; do ./strip.sh $binfile; done
#bulid deb
(cd /tmp && dpkg-deb -b $DEB_BUILD_ROOT "${name}-${version}-${release}-${platform}.deb")
cp /tmp/${name}-${version}-${release}-${platform}.deb ./


