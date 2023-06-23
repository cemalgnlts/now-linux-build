#!/usr/bin/env bash

set -e

BUILD_ROOT_RELEASE='2023.02'
NODEJS_VERSION='v16.20.0'

# Create nodejs library directory if not exists
NODE_LIB_DIR='buildroot-custom/board/now/rootfs_overlay/usr/local/lib/nodejs'
if [ ! -d $NODE_LIB_DIR ]
then
    echo '[Nodejs] downloading...'
    mkdir -p "$NODE_LIB_DIR"
    cd "$NODE_LIB_DIR"

    # Download nodejs
    wget -q "https://unofficial-builds.nodejs.org/download/release/$NODEJS_VERSION/node-$NODEJS_VERSION-linux-x86.tar.xz"

    # Unzip the binary archive
    tar -axf "node-$NODEJS_VERSION-linux-x86.tar.xz"
    mv node-$NODEJS_VERSION-linux-x86/{bin,include,lib} .
    rm -rf "node-$NODEJS_VERSION-linux-x86" "node-$NODEJS_VERSION-linux-x86.tar.xz"

    echo "Purge npm, npx, corepack"
    rm bin/{npm,npx,corepack}
    rm -rf lib/node_modules/{npm,corepack}

    cd -

    echo '[Nodejs] downloaded.'
else
    echo '[Nodejs] already exists.'
fi

### Experimental ###
JAVA_LIB_DIR='buildroot-custom/board/now/rootfs_overlay/usr/local/lib/java'

echo '[Java] downloading...'
mkdir -p "$JAVA_LIB_DIR"
cd "$JAVA_LIB_DIR"

wget -q 'https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248231_ce59cff5c23f4e2eaf4e778a117d4c5b' -O 'jre-8u371-linux-i586.tar.gz'
tar axf 'jre-8u371-linux-i586.tar.gz'
rm -f 'jre-8u371-linux-i586.tar.gz'

cd -
### Experimental ###

# Install buildroot.
if [ ! -d "./buildroot-$BUILD_ROOT_RELEASE" ]
then
    echo '[Buildroot] downloading...'

    wget -q "http://buildroot.org/downloads/buildroot-$BUILD_ROOT_RELEASE.tar.gz"
    tar -axf "buildroot-$BUILD_ROOT_RELEASE.tar.gz"

    echo '[Buildroot] downloaded.'
else
    echo '[Buildroot] already exists.'
fi

echo "./buildroot-custom copying to ./buildroot-$BUILD_ROOT_RELEASE"

cp -fr ./buildroot-custom ./buildroot-$BUILD_ROOT_RELEASE/
cd buildroot-$BUILD_ROOT_RELEASE

# Buildroot cache
export BR2_CCACHE_DIR=${HOME}/br-cache/ccache
export BR2_DL_DIR=${HOME}/br-cache/dl

# Build our defconfig.
make BR2_EXTERNAL=buildroot-custom now_defconfig
make
