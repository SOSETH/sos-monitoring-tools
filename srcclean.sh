#!/bin/bash

if [ -n "$1" ] ; then
	TRG="$1"
else
	TRG="$(find . -maxdepth 1 -type d | grep -v out | grep -v git | grep -v ^.\$)"
	echo "WARNING - This will reset all subrepos to their current branch,"
	echo "removing all changes! Abort with CTRL+C, continue with any other key"
	read
fi

for i in $TRG ; do
	pushd $i
	if [ -d .git ] ; then
		git checkout .
		git clean -fd .
	fi
	popd
done
