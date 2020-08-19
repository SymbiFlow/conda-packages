#!/bin/bash

set -xe

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

TOP=$PWD

unset VERILATOR_ROOT
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
mkdir -p UHDM/build
cd UHDM/build
cmake \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -D_GLIBCXX_DEBUG=1 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS='-D_GLIBCXX_USE_CXX11_ABI=1 -DWITH_LIBCXX=Off' \
    ../
make install

cd $TOP
cd verilator
autoconf
./configure --prefix=$PREFIX
make -j$CPU_COUNT
make install

sed -i 's/"verilator_bin"/"verilator_bin-uhdm"/g' "$PREFIX/bin/verilator"
sed -i 's/"verilator_bin_dbg"/"verilator_bin_dbg-uhdm"/g' "$PREFIX/bin/verilator"
mv "$PREFIX/bin/verilator" "$PREFIX/bin/verilator-uhdm"
mv "$PREFIX/bin/verilator_bin" "$PREFIX/bin/verilator_bin-uhdm"
mv "$PREFIX/bin/verilator_bin_dbg" "$PREFIX/bin/verilator_bin_dbg-uhdm"
sed -i 's@'$BUILD_PREFIX'@$(CONDA_PREFIX)@g' "$PREFIX/share/verilator/include/verilated.mk"
