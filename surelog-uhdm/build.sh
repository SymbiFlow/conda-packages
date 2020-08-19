#!/bin/bash

set -xe

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

TOP=$PWD
export PKG_CONFIG_PATH="$BUILD_PREFIX/lib/pkgconfig/"
export CXXFLAGS="$CXXFLAGS \
    -I$BUILD_PREFIX/include \
    -I$TOP/UHDM/include \
    -I$TOP/UHDM/headers \
    -I$TOP/UHDM \
    -I$TOP/yosys/frontends/uhdm \
    -I$PREFIX/include"
export LDFLAGS="$CXXFLAGS \
   -L$TOP/UHDM/build/lib \
   -L$TOP/UHDM/build/third_party/capnproto/c++/src/capnp \
   -L$TOP/UHDM/build/third_party/capnproto/c++/src/kj \
   -L$PREFIX/lib/uhdm \
   -L$BUILD_PREFIX/lib -L$PREFIX/lib -lrt -ltinfo"

cd $TOP
cd Surelog
make -j$CPU_COUNT PREFIX=$PREFIX
make install

cp "$PREFIX/bin/surelog" "$PREFIX/bin/surelog-uhdm"
