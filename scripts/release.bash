#!/bin/bash
release() {
	VERSION="$1"
	if [[ "$VERSION" == "" ]]; then
		echo "[ ERROR ] - version not specified."
		echo "Please use \$ ./script/release.bash version_number"
		return 1
	fi

	reference="origin/master"
	current="origin/feza/staging"
	git fetch origin master:master
	git fetch origin feza/staging:feza/staging
	diff=$(git log --oneline "$reference..$current")
	timestamp=$(date '+%A %T - %B/%d/%Y (%z)')
	newlog="\
# Version $VERSION
## $timestamp
-------------------------------------------------------------------------------
$diff

"
	echo -e "$newlog$(cat CHANGELOG.md)" > CHANGELOG.md
}
release $@
