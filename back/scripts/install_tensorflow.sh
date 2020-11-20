#!/usr/bin/env bash

VERSION=1.14.0
DESTINATION="${GOPATH}/pkg/libtensorflow-$VERSION"

export LIBRARY_PATH=$LIBRARY_PATH:$DESTINATION/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DESTINATION/lib
export CPATH=$CPATH:$DESTINATION/include

# check if file already exists
if [ -x $DESTINATION ]
then
    echo "libtensorflow $VERSION already installed."
    return 0 # this script is sourced
fi

wget "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-${VERSION}.tar.gz" -O /tmp/libtensorflow-${VERSION}.tar.gz
mkdir -p $DESTINATION
tar -C $DESTINATION -xzf /tmp/libtensorflow-${VERSION}.tar.gz
ln -sf $DESTINATION ${GOPATH}/pkg/libtensorflow


