#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

e2e_files=`git diff --name-status $diff |  grep -E '^(A|M|R)'  | awk '{ print $NF }' | grep '^checks/dashboard/tests/e2e/.*$'`

exit_code=0
if [ "$e2e_files" == "" ] && [ "$diff" != "" ]
then
    exit 0
fi

cd checks/dashboard
make version
npm install
cypress install

npm run test:e2e -- --headless
if [ $? -ne 0 ]; then
    exit_code=1
fi

cd -

exit $exit_code
