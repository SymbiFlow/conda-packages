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

# Build uhdm, only for yosys build
make uhdm/build -j$CPU_COUNT
cd $TOP
cd yosys
env
make ENABLE_READLINE=0 -j$CPU_COUNT
make install

# Rebuild UHDM, this time with conda PREFIX
cd $TOP
rm -rf UHDM/build
mkdir -p UHDM/build
cd UHDM/build
cmake \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -D_GLIBCXX_DEBUG=1 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS='-D_GLIBCXX_USE_CXX11_ABI=1 -DWITH_LIBCXX=Off' \
    ../
make install

mv "$PREFIX/bin/yosys" "$PREFIX/bin/yosys-uhdm"
