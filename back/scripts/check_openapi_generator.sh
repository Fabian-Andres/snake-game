#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

files_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep -E 'openapi.yaml$'`

exit_code=0
for file in $files_to_test
do
    echo "Generating clients for file: $file..."
    if [[ ! -f $file ]]; then
        echo "Warning: file doesn't exist..."
        continue
    fi

    npx openapi-generator generate -i ./$file -g ruby -o ruby_generated/
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    npx openapi-generator generate -i ./$file -g java -o java_generated/
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    rm -rf ruby_generated/
    rm -rf java_generated/
done

exit $exit_code
