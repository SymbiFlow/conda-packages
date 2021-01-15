#!/bin/bash

set -e
set -x

CPU_COUNT=$(nproc)

which pkg-config

echo "PREFIX := $PREFIX" >> Makefile.conf

cd yosys-symbiflow-plugins
make install -j$CPU_COUNT
