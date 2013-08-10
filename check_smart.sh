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

badSectors=`/opt/local/libexec/nagios/smartctl -a $1 | grep -C 0 'Reallocated_Sector_Ct' | grep -E -o "[0-9]+" | tail -1`
reallocSectors=`/opt/local/libexec/nagios/smartctl -a $1 | grep -C 0 'Reallocated_Event_Count' | grep -E -o "[0-9]+" | tail -1`
powerOnHours=`/opt/local/libexec/nagios/smartctl -a $1 | grep -C 0 'Power_On_Hours' | grep -E -o "[0-9]+" | tail -1`

if [ $reallocSectors -gt 0 -o $badSectors -gt 0 ]; then
	printf "CRITICAL - Drive has bad sectors, but S.M.A.R.T. status is OK | badSectors=$badSectors; reallocSectors=$reallocSectors; powerOnHours=$powerOnHours;\n"
	exit 2
fi

if echo $resultString | grep -q "PASSED"
then
  	printf "OK - All S.M.A.R.T. attributes passed | badSectors=$badSectors; reallocSectors=$reallocSectors; powerOnHours=$powerOnHours;\n"
  	exit 0
else
	failString=`echo $resultString | grep -C 0 'FAILING_NOW'`
	if echo $failString | grep -q "Reallocated_Sector_Ct\|Reallocated_Event_Count"
	then
		printf "CRITICAL - Drive has bad sectors! | badSectors=$badSectors; reallocSectors=$reallocSectors; powerOnHours=$powerOnHours;\n"
		exit 2
	else
		printf "WARNING - Drive has failing S.M.A.R.T. attributes! | badSectors=$badSectors; reallocSectors=$reallocSectors; powerOnHours=$powerOnHours;\n"
		exit 1
	fi
fi