#!/bin/bash

set -x
set -e

CONDA_PATH=${1:-~/conda}

echo "Downloading Conda installer."
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh

if [ ! -d $CONDA_PATH -o ! -z "$CI"  ]; then
	echo "Installing conda"
        ./Miniconda3-latest-Linux-x86_64.sh -p $CONDA_PATH -b -f
fi
export PATH=$CONDA_PATH/bin:$PATH

# Updating conda
conda update -y conda setuptools
conda install -y conda-build anaconda-client jinja2 conda-verify ripgrep
