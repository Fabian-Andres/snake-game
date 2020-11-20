#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

lfs_files=`cat .gitattributes | awk '{ print $1 }'`
files=`git diff --name-status $diff |  grep -E '^(A|M|R)' | awk '{ print $NF }' | sort -u`

exit_code=0

function is_lfs_file() {
    for excluded_file in $lfs_files
    do
        if [[ $1 == $excluded_file ]]
        then
            return 1
        fi
    done

    return 0
}

for file in $files
do
    is_lfs_file $file
    if [[ $? == 1 ]]
    then
        echo "lfs file found: ${file}. Skipping"
        continue
    fi

    if [[ `du $file | cut -f1` -gt 4096 ]]
    then
        echo "${file} is too large. Max size: 2MB"
        exit_code=1
    fi
done

exit $exit_code