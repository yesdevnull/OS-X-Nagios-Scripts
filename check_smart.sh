#!/bin/bash

#	Check SMART
#	by Dan Barrett
#	http://yesdevnull.net

#	v1.0 - 9 Aug 2013
#	Initial release.

#	

# enable SMART on the drive if it is not already
smartoncmd=`/opt/local/libexec/nagios/smartctl --smart=on --saveauto=on $1`

resultString=`/opt/local/libexec/nagios/smartctl -H $1`

if echo $resultString | grep -q "PASSED"
then
  	printf "OK - SMART Passed\n"
  	exit 0
else
	failString=`echo $resultString | grep -C 0 'FAILING_NOW'` 
	if echo $failString | grep -q "Reallocated_Sector_Ct"
	then
		printf "CRITICAL - Drive has bad sectors\n"
		exit 2
	else
		printf "WARNING - Drive is failing SMART\n"
		exit 1
	fi
fi