#!/bin/bash

#	Check Folder Size
#	by Dan Barrett
#	http://yesdevnull.net

#	v1.0 - 9 Aug 2013
#	Initial release.

#	Checks to see how large the folder is, in MB, and warns or crits if over a specified size.

#	Example:
#	./check_folder_size.sh -f /Library/Application\ Support/ -w 2048 -c 4096

folderPath=""
warnThresh=""
critThresh=""

while getopts "f:w:c:" optionName; do
case "$optionName" in
f) folderPath=( $OPTARG );;
w) warnThresh=( $OPTARG );;
c) critThresh=( $OPTARG );;
esac
done

if [ "$folderPath" == "" ]; then
	printf "ERROR - You must provide a file path with -f!\n"
	exit 2
fi

if [ "$warnThresh" == "" ]; then
	printf "ERROR - You must provide a warning threshold with -w!\n"
	exit 2
fi

if [ "$critThresh" == "" ]; then
	printf "ERROR - You must provide a critical threshold with -c!\n"
	exit 2
fi

folderSize=`du -s $folderPath | grep -E -o "[0-9]+"`

if [ "$folderSize" -ge "$critThresh" ]; then
	printf "CRITICAL - folder is $folderSize MB in size | folderSize=$folderSize;\n"
	exit 2
elif [ "$folderSize" -ge "$warnThresh" ]; then
	printf "WARNING - folder is $folderSize MB in size | folderSize=$folderSize;\n"
	exit 1
fi

printf "OK - folder is $folderSize MB in size | folderSize=$folderSize;\n"
exit 0