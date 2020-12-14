#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "need to include the version number!"
    exit -1
fi

PREV=`expr $1 - 1`
FILEPATH=com.level3tjg.bfdecrypt_1.3.2-$1_appletvos-arm64
OLD=com.level3tjg.bfdecrypt_1.3.2-${PREV}_appletvos-arm64
OLDV=1.3.2-${PREV}
NEWV=1.3.2-$1
CONTROL=$FILEPATH/DEBIAN/control

if [ ! -d $FILEPATH ]; then
    echo "path doesnt exist yet!, makin copies!"
    cp -r $OLD $FILEPATH
    sed -i -- "s|$OLDV|$NEWV|" $CONTROL
    rm $CONTROL--
fi

make 2>error.log
jtool --sign --ent ent.plist bfdecrypt.dylib --inplace
cp bfdecrypt.dylib $FILEPATH/Library/MobileSubstrate/DynamicLibraries/
find . -name ".DS_Store" | xargs rm -rf
fakeroot dpkg-deb -b $FILEPATH
dpkg-deb -I "$FILEPATH".deb
dpkg-deb -c "$FILEPATH".deb
