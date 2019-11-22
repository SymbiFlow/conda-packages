#!/bin/bash

source $TRAVIS_BUILD_DIR/.travis/common.sh
set -e

if [ ! -z "$USE_SYSTEM_GCC_VERSION" ]; then
	sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
	sudo apt update
	sudo apt install -y gcc-${USE_SYSTEM_GCC_VERSION} g++-${USE_SYSTEM_GCC_VERSION}
fi

# Getting the conda environment
start_section "environment.conda" "Setting up basic ${YELLOW}conda environment${NC}"

mkdir -p $BASE_PATH
./conda-get.sh $CONDA_PATH
hash -r
conda config --set always_yes yes --set changeps1 no
conda install pexpect
conda config --add channels timvideos
for CHANNEL in $(echo $CONDA_CHANNELS | tr ',' ' '); do
	conda config --add channels $CHANNEL
done
conda config --add channels $(echo $TRAVIS_REPO_SLUG | sed -e's@/.*$@@')
#conda clean -s --dry-run
conda build purge
#conda clean -s --dry-run

./conda-meta-extra.sh

end_section "environment.conda"

$SPACER

# Output some useful info
start_section "info.conda.env" "Info on ${YELLOW}conda environment${NC}"
conda info
end_section "info.conda.env"

start_section "info.conda.config" "Info on ${YELLOW}conda config${NC}"
conda config --show
end_section "info.conda.config"

start_section "info.conda.package" "Info on ${YELLOW}conda package${NC}"
conda render --no-source $CONDA_BUILD_ARGS || true
end_section "info.conda.package"

$SPACER

start_section "conda.copy" "${GREEN}Copying package...${NC}"
mkdir -p /tmp/conda/$PACKAGE
cp -vRL $PACKAGE/* /tmp/conda/$PACKAGE/
cd /tmp/conda/
end_section "conda.copy"

$SPACER

start_section "conda.download" "${GREEN}Downloading..${NC}"
travis_wait conda build --source $CONDA_BUILD_ARGS || true
end_section "conda.download"
