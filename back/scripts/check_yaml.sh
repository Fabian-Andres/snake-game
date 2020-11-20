#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

files_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep -E '\.(yml|yaml)$'`

exit_code=0
for file in $files_to_test
do
    echo "Linting YAML $file..."
    if [[ ! -f $file ]]; then
        echo "Warning: file doesn't exist..."
        continue
    fi

    yamllint -d relaxed ./$file
    if [ $? -ne 0 ]; then
        exit_code=1
    fi
done

exit $exit_code
