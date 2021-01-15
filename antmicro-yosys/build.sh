#!/bin/bash

set -e
set -x

CPU_COUNT=$(nproc)

#unset CFLAGS
#unset CXXFLAGS
#unset CPPFLAGS
#unset DEBUG_CXXFLAGS
#unset DEBUG_CPPFLAGS
#unset LDFLAGS

which pkg-config

cd yosys

make V=1 -j$CPU_COUNT
make install V=1 -j$CPU_COUNT
cp yosys "$PREFIX/bin/antmicro-yosys"
cp yosys-config "$PREFIX/bin/yosys-config"

$PREFIX/bin/antmicro-yosys -V
