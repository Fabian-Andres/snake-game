#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

files_changed=`git diff --name-status $diff | grep -E '^(A|M|R)' | awk '{ print $NF }'`

SHARED_WAS_MODIFIED=no
if [[ `echo "$files_changed" | grep -Ec "^shared\/"` -gt 0 ]] || [[ `echo "$files_changed" | grep -Ec "go\.sum"` -gt 0 ]]
then
    SHARED_WAS_MODIFIED=yes
fi

HAS_YAML=no
if [[ `echo "$files_changed" | grep -Ec "\.(yml|yaml)$"` -gt 0 ]]
then
    HAS_YAML=yes
fi

OPENAPI_WAS_MODIFIED=no
if [[ `echo "$files_changed" | grep -Ec "openapi.yaml"` -gt 0 ]]
then
    OPENAPI_WAS_MODIFIED=yes
fi

HAS_GO=no
if [[ `echo "$files_changed" | grep -Ec "\.go$"` -gt 0 ]]
then
    HAS_GO=yes
fi

HAS_CHROMEDP=no
if [[ `echo "$files_changed" | grep -Ec "chromedp"` -gt 0 ]] || [[ `echo "$files_changed" | grep -Ec "^digital-identity\/dashboard\/tests\/e2e\/"` -gt 0 ]]
then
    HAS_CHROMEDP=yes
fi

HAS_PY=no
if [[ `echo "$files_changed" | grep -Ec "\.py$"` -gt 0 ]]
then
    HAS_PY=yes
fi

HAS_JSON=no
if [[ `echo "$files_changed" | grep -Ec "\.json$"` -gt 0 ]]
then
    HAS_JSON=yes
fi

HAS_JS=no
if [[ `echo "$files_changed" | grep -Ec "\.(js|vue)$"` -gt 0 ]]
then
    HAS_JS=yes
fi

HAS_TF=no
if [[ `echo "$files_changed" | grep -Ec "\.(tf)$"` -gt 0 ]]
then
    HAS_TF=yes
fi

echo "shared/ was modified? $SHARED_WAS_MODIFIED"
echo "Has yaml? $HAS_YAML"
echo "openapi.yml was modified? $OPENAPI_WAS_MODIFIED"
echo "Has go? $HAS_GO"
echo "Has chromedp? $HAS_CHROMEDP"
echo "Has python? $HAS_PY"
echo "Has javascript? $HAS_JS"
echo "Has json? $HAS_JSON"
echo "Has terraform? $HAS_TF"

