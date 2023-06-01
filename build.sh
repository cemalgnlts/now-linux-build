#!/usr/bin/env bash

NODEJS_VERSION='v16.20.0'
BUILD_ROOT_RELEASE='2023.02'

# Create nodejs library directory if not exists
NODE_LIB_DIR='buildroot-v86/board/rootfs_overlay/usr/local/lib/nodejs'
if [ ! -d $NODE_LIB_DIR ]
then
    echo "[Nodejs] downloading..."
    mkdir -p $NODE_LIB_DIR
    cd $NODE_LIB_DIR

    # Download nodejs
    VERSION="v16.20.0"
    wget -q "https://unofficial-builds.nodejs.org/download/release/v16.20.0/node-$VERSION-linux-x86.tar.xz"

    # Unzip the binary archive
    tar -axf "node-$VERSION-linux-x86.tar.xz"
    mv node-$VERSION-linux-x86/{bin,include,lib,share} .
    rm -rf "node-$VERSION-linux-x86" "node-$VERSION-linux-x86.tar.xz"

    cd -

    echo "[Nodejs] downloaded."
else
    echo "[Nodejs] already exists."
fi

if [ ! -d "./buildroot-$BUILD_ROOT_RELEASE" ]
then
    echo "[Buildroot] downloading..."

    wget -q "http://buildroot.org/downloads/buildroot-$BUILD_ROOT_RELEASE.tar.gz"
    tar -axf "buildroot-$BUILD_ROOT_RELEASE.tar.gz"

    echo "[Buildroot] downloaded"
else
    echo "[Buildroot] already exists."
fi

echo "./buildroot-v86 copying to ./buildroot-$BUILD_ROOT_RELEASE"

cp -fr ./buildroot-v86 ./buildroot-$BUILD_ROOT_RELEASE/
cd buildroot-$BUILD_ROOT_RELEASE

# Build our defconfig.
make BR2_EXTERNAL=buildroot-v86 defconfig && make

echo "See ./dist for built ISO"
