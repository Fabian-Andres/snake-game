#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

files_to_test=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '^certificates/dashboard/.*\.\(js\|vue\)$'`
package_json=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '\(package.json|package-lock.json\)$'`

exit_code=0
if [ "$files_to_test$package_json" == "" ]
then
    exit 0
fi

cd certificates/dashboard
make version
npm install
npm audit
if [ $? -ne 0 ]; then
    # Disable for now
    #exit_code=1
    echo "Security issues found, skipping check"
fi

for file in $files_to_test
do
    echo "Checking $file..."
    npm run lint -- --color --no-fix ../../$file
    if [ $? -ne 0 ]; then
        exit_code=1
    fi
done

npm run test:unit
if [ $? -ne 0 ]; then
    exit_code=1
fi

cd -

exit $exit_code

