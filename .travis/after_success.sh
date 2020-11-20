#!/bin/bash

source .travis/common.sh
set -e

# Close the after_success fold travis has created already.
travis_fold end after_success

start_section "package.contents" "${GREEN}Package contents...${NC}"
for element in "${PACKAGES[@]}"
do
	tar -jtf $element | sort
done
end_section "package.contents"

if [ x$TRAVIS_BRANCH = x"master" -a x$TRAVIS_EVENT_TYPE != x"cron" -a x$TRAVIS_PULL_REQUEST == xfalse ]; then
	$SPACER

	for element in "${PACKAGES[@]}"
	do
		start_section "package.upload" "${GREEN}Package uploading...${NC}"
		anaconda -t $ANACONDA_TOKEN upload --user $ANACONDA_USER --label main $element
		end_section "package.upload"
	done

fi

$SPACER

start_section "success.tail" "${GREEN}Success output...${NC}"
echo "Log is $(wc -l /tmp/output.log) lines long."
echo "Displaying last 1000 lines"
echo
tail -n 1000 /tmp/output.log
end_section "success.tail"
