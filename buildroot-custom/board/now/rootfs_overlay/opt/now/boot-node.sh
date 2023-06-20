#!/bin/sh

umount /proc
umount /sys
umount /run

rm -rf /media /etc /proc /mnt /sys /run /var
rm -r /lib32 /init

ITERATION=10
echo "Node initializing..."

for i in `seq $ITERATION`
do
    time -f "[$i/$ITERATION] - %es" node -e 'console.log("Hello World")' > /dev/null
done

rm -rf /dev
