#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/15/20200608-212841/symbiflow-arch-defs-install-32defbb3.tar.xz | tar -xJ

BIN_DIR=${PREFIX}/bin
SHARE_DIR=${PREFIX}/share/symbiflow

mkdir -p $SHARE_DIR

cp -r install/share/scripts $SHARE_DIR
cp -r install/share/techmaps $SHARE_DIR
cp -r install/bin/* $BIN_DIR/
