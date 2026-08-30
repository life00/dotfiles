#!/usr/bin/env bash

#STORAGE=/snsh/static/home/*/
STORAGE=/snsh/automatic/home/1d/*/snapshot/

if [[ -e "$1" ]]; then
	
	for d in $STORAGE; do
		if [[ -e "$d$1" ]]; then
			#btrfs pr set "$d" ro false
			#rm -v "$d$1"
			#btrfs pr set "$d" ro true
			file "$d$1"
		fi
	done
else
	printf "Usage:\n"
	printf "# cd /where/is/snapshot/\n"
	printf "# btrfs-file-delete path/to/target\n"
	
fi
