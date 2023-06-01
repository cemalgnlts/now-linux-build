#!/bin/sh

# Run after buildroot has built the image.
echo "=== TEST ==="
echo $PWD

cd /home/circleci/project/

mkdir -p dist/
mv ${BINARIES_DIR}/rootfs.iso9660 dist/linux.iso

echo "Created linux.iso."
