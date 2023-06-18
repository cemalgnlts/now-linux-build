#!/bin/sh

umount proc
umount sys
umount run

rm -rf /media /etc /proc /mnt /sys /run
rm -r /lib32 /init

ITERATION=30
echo "Node initializing..."

for i in `seq $ITERATION`
do
    time -f "[$i/$ITERATION] - %es" node /opt/now/hello.js > /dev/null
done

rm -rf /dev