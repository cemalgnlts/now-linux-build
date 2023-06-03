#!/bin/sh

ITERATION=15
printf "[1/$ITERATION] Node initializing..."

for i in `seq $ITERATION`
do
    node /opt/now/hello.js > /dev/null

    printf "\r[$i/$ITERATION] Node initializing..."
done

echo