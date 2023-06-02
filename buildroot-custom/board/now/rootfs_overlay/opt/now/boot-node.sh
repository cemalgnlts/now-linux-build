#!/bin/sh

ITERATION=10
print "[1/$ITERATION] Node initializing..."

for i in `seq $ITERATION`
do
    node /opt/now/hello.js > /dev/null

    print "\r[$i/$ITERATION] Node initializing..."
done

echo