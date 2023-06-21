#!/bin/sh

ITERATION=10
echo "Node initializing..."

udhcpc

for i in `seq $ITERATION`
do
    time -f "[$i/$ITERATION] - %es" node -e 'console.log("Hello World")' > /dev/null
done