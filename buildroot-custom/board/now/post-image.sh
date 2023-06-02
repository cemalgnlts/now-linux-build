#!/bin/sh

# Run after buildroot has built the image.
mkdir ../dist
cp ${BINARIES_DIR}/rootfs.iso9660 ../dist/linux.iso

echo "Created linux.iso."

