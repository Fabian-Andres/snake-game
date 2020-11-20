#!/usr/bin/env bash

export AWS_XRAY_SDK_DISABLED=TRUE

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

pkgs_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.go$' | xargs -n1 dirname | sort -u`
test_files=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '_test\.go$' | sort -u`

exit_code=0

for file in $test_files
do
    if [[ $file != */main_test.go  ]] && [[ `grep -c "func Benchmark" $file` == 0 ]]
    then
        echo "${file} needs at least 1 benchmark. Read: https://dave.cheney.net/2013/06/30/how-to-write-benchmarks-in-go"
        exit_code=1
    fi
done

WAS_STASHED=false
if [[ $(git diff --stat) != '' ]]
then
    echo "> Stashing local changes..."
    git stash
    WAS_STASHED=true
fi

if [[ $SHARED_WAS_MODIFIED == "yes" ]]
then
    echo "Running all benchmarks since shared was modified..."
    pkgs_to_test=`grep -Rl --include='*_test.go' "func Benchmark" "{}" . | xargs -n1 dirname | sort -u`
fi

for pkg in $pkgs_to_test
do
    echo "# Checking benchmarks for ./$pkg"
    bms_in_base=`git grep -c --no-recursive "func Benchmark" origin/master -- ./$pkg | wc -l | xargs`
    if [[ $bms_in_base -eq 0 ]]
    then
        echo "Skipping because the benchmarks are new"
        continue
    fi

    cob --base=origin/master -compare "B/op" -bench-args "test -run '^$' -bench . -benchmem ./$pkg"
    if [ $? -ne 0 ]; then
        exit_code=1
    fi
done

if [[ $WAS_STASHED == "true" ]]
then
    echo "> Recovering changes from the stash..."
    git stash pop
fi

exit $exit_code
