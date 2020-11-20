#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

pkgs_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.go$' | xargs -n1 dirname | sort -u`

exit_code=0
for pkg in $pkgs_to_test
do
    echo "# Checking ./$pkg"

    echo "Checking cyclomatic complexity..."
    gocyclo -over 9 ./$pkg
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking cognitive complexity..."
    gocognit -over 10 ./$pkg
    if [ $? -ne 0 ]; then
        exit_code=1
    fi
done

exit $exit_code
