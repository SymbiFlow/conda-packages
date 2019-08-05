#!/bin/bash

set -x
set -e

CONDA_PATH=${1:-~/conda}

CONDA_FILE=Miniconda3-4.5.12-Linux-x86_64.sh
wget -c https://repo.continuum.io/miniconda/$CONDA_FILE
chmod a+x $CONDA_FILE
if [ ! -d $CONDA_PATH -o ! -z "$CI"  ]; then
        ./$CONDA_FILE -p $CONDA_PATH -b -f
fi
export PATH=$CONDA_PATH/bin:$PATH
if [ ! -z "$CONDA_BUILD_VERSION" ]; then
	conda install -y conda-build==$CONDA_BUILD_VERSION
	echo "conda-build==$CONDA_BUILD_VERSION" > $CONDA_PATH/conda-meta/pinned
else
	conda install -y conda-build
fi
conda install -y anaconda-client
conda install -y jinja2
