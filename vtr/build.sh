#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

mkdir build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} ..
make -j$CPU_COUNT VERBOSE=1
make test
make install

mkdir -p ${PREFIX}/lib
mv ${PREFIX}/bin/*.a ${PREFIX}/lib/
