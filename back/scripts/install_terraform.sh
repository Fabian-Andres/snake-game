#!/usr/bin/env bash

VERSION=0.12.8
DESTINATION="${GOPATH}/bin/terraform-$VERSION"

# check if file already exists
if [ -x $DESTINATION ]
then
    echo "terraform $VERSION already installed."
    exit 0
fi

wget "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip" -O /tmp/terraform-${VERSION}.zip
unzip /tmp/terraform-${VERSION}.zip -d /tmp
mv /tmp/terraform $DESTINATION
ln -sf $DESTINATION ${GOPATH}/bin/terraform

