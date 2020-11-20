#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

git diff --name-status "origin/master...HEAD" |  grep -E '^(A|M|R)'  | awk -F' ' '{ print $NF }' | grep -E '^checks/collectors/'| xargs  --no-run-if-empty truora collector validate
if [ $? -ne 0 ]; then
    exit 1 
fi  

exit 0