#!/usr/bin/env bash

export AWS_XRAY_SDK_DISABLED=TRUE

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

pkgs_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.go$' | xargs -n1 dirname | sort -u`
if [ -d $1 ]
then
    pkgs_to_test="$1/..."
fi

exit_code=0
for pkg in $pkgs_to_test
do
    echo "# Checking ./$pkg"

    coverage_dir=.coverage/$pkg
    coverage_file=$coverage_dir/coverage.out
    mkdir -p $coverage_dir
    timeout=120s

    echo "Running tests..."
    if [ "$(dirname "$pkg")" == "functional-tests" ];
    then
        timeout=240s
    fi

    if [ "$pkg" == "shared/fakeimage" ];
    then
        # FIXME: optimize this package
        timeout=420s
    fi

    go test -race -cover -coverprofile=$coverage_file -timeout=$timeout -short ./$pkg
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    coverage_code=0
    output=`go tool cover -func=$coverage_file`
    while read line; do
        if [[ `echo "$line" | grep -c -E '\b([0-5][0-9]|[0-9])\.[0-9]+%'` -gt 0 ]] && [[ `echo "$line" | grep -cE '\s(init|main|\(statements\))\s'` -eq 0 ]] && [[ `echo "$line" | grep -cE '\s\S+SC\s'` -eq 0 ]]
        then
            echo -e "\e[0;31m$line\e[0;0m"
            coverage_code=1
        else
            echo -e "\e[0;32m$line\e[0;0m"
        fi
    done <<<"$output"

    if [[ $pkg == *functions/start* ]] || [[ $pkg == *functions/query* ]] || [[ $pkg == *functional-tests* ]] || [[ $pkg == *start* ]]; then
        echo "Skip $pkg..."
        coverage_code=0
    fi

    if [[ $coverage_code == 1 ]]; then
        exit_code=1
    fi
done

exit $exit_code
