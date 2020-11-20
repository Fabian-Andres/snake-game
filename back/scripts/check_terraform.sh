#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

function runInRoot() {
    path=$1
    filename=$2
    currentDir=$(basename $path)

    if [[ $path == "/" ]]
    then
        echo "Root folder not found, check that backend.tf file exists in your project, currently checking file: $filename"
        return 1
    fi

    cd $path
    if [[ -f $PWD/backend.tf ]]
    then
        echo "Found root for $filename in $path..."
        tflint $filename
        return $?
    else
        filename="$currentDir/$filename"
        cd ..
        runInRoot $PWD $filename
        return $?
    fi

    return 1
}

tf_files_to_test=`git diff --name-status $diff | grep -E '^(A|M|R)' | awk '{ print $NF }' | grep '\.tf$'`

exit_code=0
for file in $tf_files_to_test
do
    echo "Checking format for $file..."
    terraform fmt -write=false -check -diff $file
    if [ $? -ne 0 ]
    then
        exit_code=1
    fi

    currDir=$(pwd)
    echo "Linting $file..."
    if [[ $file == *terraform/modules* ]]
    then
        tflint --disable-rule=aws_lambda_permission_invalid_function_name $file
        if [ $? -ne 0 ]
        then
            exit_code=1
        fi
    else
        path=`dirname $file`
        filename=`basename $file`
        runInRoot $path $filename
        if [ $? -ne 0 ]
        then
            exit_code=1
        fi
    fi
    cd $currDir
done



exit $exit_code
