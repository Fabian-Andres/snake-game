#!/usr/bin/env bash

cd /tmp

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='darwin'
fi

if [[ ! -x $GOPATH/bin/golint ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v golang.org/x/lint/golint
fi

if [[ ! -x $GOPATH/bin/errcheck ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/kisielk/errcheck
fi

if [[ ! -x $GOPATH/bin/gocyclo ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/fzipp/gocyclo/cmd/gocyclo
fi

if [[ ! -x $GOPATH/bin/deadcode ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/tsenart/deadcode
fi

if [[ ! -x $GOPATH/bin/staticcheck ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v honnef.co/go/tools/cmd/staticcheck
fi

if [[ ! -x $GOPATH/bin/gosec ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/securego/gosec/cmd/gosec
fi

if [[ ! -x $GOPATH/bin/ineffassign ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/gordonklaus/ineffassign
fi

if [[ ! -x $GOPATH/bin/nakedret ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/alexkohler/nakedret
fi

if [[ ! -x $GOPATH/bin/goimports ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v golang.org/x/tools/cmd/goimports
fi

if [[ ! -x $GOPATH/bin/nilness ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v golang.org/x/tools/go/analysis/passes/nilness/cmd/nilness
fi

if [[ ! -x $GOPATH/bin/unmarshal ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v golang.org/x/tools/go/analysis/passes/unmarshal/cmd/unmarshal
fi

if [[ ! -x $GOPATH/bin/lostcancel ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v golang.org/x/tools/go/analysis/passes/lostcancel/cmd/lostcancel
fi

if [[ ! -x $GOPATH/bin/gocognit ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/uudashr/gocognit/cmd/gocognit
fi

if [[ ! -x $GOPATH/bin/tflint ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    curl -L "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_${platform}_amd64.zip")" -o tflint.zip && unzip tflint.zip && rm tflint.zip
    mv tflint $GOPATH/bin/tflint
    tflint -v || exit 1
fi

if [[ ! -x $GOPATH/bin/go-errorlint ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/polyfloyd/go-errorlint
fi

if [[ ! -x $GOPATH/bin/cob ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/mauriciocm9/cob
fi

if [[ ! -x $GOPATH/bin/shadow ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow
fi

if [[ ! -x $GOPATH/bin/wsl ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    GO111MODULE=off go get -u -v github.com/bombsimon/wsl/cmd/wsl
fi

if [[ ! -x $GOPATH/bin/closecheck ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/dcu/closecheck
fi

if [[ ! -x $GOPATH/bin/revive ]] || [[ $FORCE_UPDATE == "yes" ]]
then
    go get -u -v github.com/mgechev/revive
fi

cd -
