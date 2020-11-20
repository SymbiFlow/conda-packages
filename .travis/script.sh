#!/bin/bash

source .travis/common.sh
set -e

$SPACER

start_section "conda.check" "${GREEN}Checking...${NC}"
$TRAVIS_BUILD_DIR/conda-env.sh build --check $CONDA_BUILD_ARGS || true
end_section "conda.check"

$SPACER

start_section "conda.build" "${GREEN}Building..${NC}"
if [[ "${KEEP_ALIVE}" = 'true' ]]; then
	travis_wait $TRAVIS_MAX_TIME $CONDA_PATH/bin/python $TRAVIS_BUILD_DIR/.travis-output.py /tmp/output.log $TRAVIS_BUILD_DIR/conda-env.sh build $CONDA_BUILD_ARGS
else
	$CONDA_PATH/bin/python $TRAVIS_BUILD_DIR/.travis-output.py /tmp/output.log $TRAVIS_BUILD_DIR/conda-env.sh build $CONDA_BUILD_ARGS
fi
end_section "conda.build"

$SPACER

start_section "conda.build" "${GREEN}Installing..${NC}"
for element in "${PACKAGES[@]}"
do
	$TRAVIS_BUILD_DIR/conda-env.sh install $element
done
end_section "conda.build"

$SPACER

start_section "conda.du" "${GREEN}Disk usage..${NC}"

for element in "${PACKAGES[@]}"
do
	du -h $element
done

end_section "conda.du"

$SPACER

start_section "conda.clean" "${GREEN}Cleaning up..${NC}"
#conda clean -s --dry-run
end_section "conda.clean"

$SPACER
