#! /bin/bash

set -e
set -x

export CC=gcc-${USE_SYSTEM_GCC_VERSION}
export CXX=g++-${USE_SYSTEM_GCC_VERSION}


mkdir bazel-install
BAZEL_PREFIX=$PWD/bazel-install

wget https://github.com/bazelbuild/bazel/releases/download/0.29.1/bazel-0.29.1-installer-linux-x86_64.sh
chmod +x bazel-0.29.1-installer-linux-x86_64.sh
./bazel-0.29.1-installer-linux-x86_64.sh --prefix=$BAZEL_PREFIX

export PATH=$BAZEL_PREFIX/bin:$PATH


bazel build --cxxopt='-std=c++17' //...

install -D bazel-bin/verilog/tools/syntax/verilog_syntax $PREFIX/bin/verilog_syntax
