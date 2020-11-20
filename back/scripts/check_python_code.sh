#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

pkgs_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.py$' | xargs -n1 dirname | sort -u`
files_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.py$'`

full_static_check=0
exit_code=0

for file in $files_to_test
do
    echo "=> Linting code..."
    pylint ./$file
    if [ $? -ne 0 ]; then
        echo "===> Linting failed for $file"
        exit_code=1
    fi

    echo "=> Checking dead code..."
    vulture ./$file --min-confidence 100 --exclude *_test.py
    if [ $? -ne 0 ]; then
        echo "===> $file contains dead code"
        exit_code=1
    fi

    echo "=> Security test..."
    bandit ./$file
    if [ $? -ne 0 ]; then
        echo "===> $file didn't pass the security test"
        exit_code=1
    fi

    echo "=> Checking complexity..."
    radon cc ./$file
    if [ $? -ne 0 ]; then
        echo "===> $file didn't pass the complexity test"
        exit_code=1
    fi

    echo "=> Checking maintainability index..."
    radon mi ./$file
    if [ $? -ne 0 ]; then
        echo "===> $file didn't pass the maintainability test"
        exit_code=1
    fi
done

for pkg in $pkgs_to_test
do
    echo "=> Static type check $pkg"
    pytype ./$pkg
    if [ $? -ne 0 ]; then
        echo "===> $pkg didn't pass the static check"
        exit_code=1
    fi

    echo "=> Checking coverage..."
    cd $pkg
    coverage run -m unittest discover -p "*_test.py"
    coverage report -m --fail-under=80 *.py
    if [[ $? -eq 2 ]]
    then
        echo "===> Coverage is not enough for $pkg, failing..."
        exit_code=1
    fi
    cd -

    echo "=> Checking for helper packages..."
    if [[ $pkg == *helper* ]] || [[ $pkg == *util* ]] || [[ $pkg == *misc* ]] || [[ $pkg == *base* ]] || [[ $pkg == *common* ]]
    then
        echo "===> Helper packages are not allowed: $pkg"
        exit_code=1
    fi
done

exit $exit_code
