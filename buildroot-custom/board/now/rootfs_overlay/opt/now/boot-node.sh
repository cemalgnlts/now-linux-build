#!/bin/sh

ITERATION=15
echo "Node initializing..."

for i in `seq $ITERATION`
do
    time -f "[$i/$ITERATION] - %es" node /opt/now/hello.js > /dev/null
done