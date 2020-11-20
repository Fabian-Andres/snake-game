#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

pkgs_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\.go$' | xargs -n1 dirname | sort -u`
gopkg_files=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep go.mod`
extra_shared_pkgs=""

full_static_check=1
exit_code=0
if [[ $gopkg_files != "" ]]
then
    full_static_check=1
fi

for pkg in $pkgs_to_test
do
    if [[ $pkg == shared/* ]] || [[ $pkg == logger/* ]] || [[ $pkg == helpers/* ]] || [[ $pkg == constants/* ]]
    then
        full_static_check=1
    fi

    if [[ $full_static_check == 0 ]] && [[ $pkg == */shared/* ]]
    then
        extra_shared_pkgs+="`echo $pkg | sed "s/\/shared\// /" | cut -d" " -f1`\n"
    fi

    parent=$(dirname $(dirname $pkg))
    grandparent=$(dirname $parent)
    grandgrandparent=$(dirname $grandparent)
    parent_level=$(echo $parent | tr -cd "/" | wc -c)

    if [[ $grandparent == "functions" ]]
    then
        pkg=$grandgrandparent
    elif [[ $parent_level -gt 2 ]] # 2 is the max level to go up in the dir structure
    then
        pkg=$parent
    fi

    if [[ $full_static_check != 1 ]] && [[ $SHARED_WAS_MODIFIED != "yes" ]]
    then
        echo "Static check $pkg/..."
        staticcheck ./$pkg/...
        if [ $? -ne 0 ]; then
            exit_code=1
        fi
    fi

    echo "Linting code..."
    revive -config ./.revive.toml ./$pkg/...
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for ineffectual assignments..."
    ineffassign ./$pkg
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for nil dereferences..."
    nilness ./$pkg/...
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for shadowed variables..."
    shadow ./$pkg/...
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for invalid unmarshals..."
    unmarshal ./$pkg/...
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for invalid lost context cancels..."
    lostcancel ./$pkg/...
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for not closed io.Closer..."
    closecheck ./$pkg/...
    if [ $? -ne 0 ]; then
        exit_code=1
    fi

    echo "Checking for naked returns..."
    output=$(nakedret ./$pkg/... 2>&1)
    if [[ $output != "" ]]
    then
        echo "$output"
        exit_code=1
    fi

    echo "Checking for helper packages..."
    if [[ $pkg == *helper* ]] || [[ $pkg == *util* ]] || [[ $pkg == *misc* ]] || [[ $pkg == *base* ]] || [[ $pkg == *common* ]]
    then
        echo "!!! Helper packages are not allowed: $pkg"
        exit_code=1
    fi
done

if [[ $full_static_check -eq 1 ]] && [[ $exit_code -eq 0 ]]
then
    echo "Running full static check since shared was modified..."
    find . -name "*.go" -not -path "./functional-tests/*" -not -path "./vendor/*" | xargs -n1 dirname | sort -u | shuf | xargs -n70 staticcheck
    if [ $? -ne 0  ]; then
        exit_code=1
    fi
fi

extra_shared_pkgs=`echo -e "$extra_shared_pkgs" | sort -u`
for extra_pkg in $extra_shared_pkgs
do
    echo "Running full static check on shared package: $extra_pkg/..."
    find ./$extra_pkg -name "*.go" -not -path "./functional-tests/*" -not -path "./vendor/*" | xargs -n1 dirname | sort -u | shuf | xargs -n70 staticcheck
    if [ $? -ne 0  ]; then
        exit_code=1
    fi
done

exit $exit_code
