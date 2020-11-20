#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

go_files_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.go$'`

exit_code=0
for file in $go_files_to_test
do
    echo "Checking format for $file..."
    diff=`goimports -d $file`
    if [ `echo -n "$diff" | wc -l` != "0" ]
    then
        echo "File $file is not well formatted"
        echo "$diff"
        exit_code=1
    fi

    wsl -allow-assign-and-call -allow-cuddle-declarations -force-err-cuddling $file
    if [ $? -ne 0 ]; then
        exit_code=1
    fi
done

exit $exit_code
