#!/bin/bash

result=`ps aux -o tty | grep _dayliteserver`
if echo $result | grep -q postgres; then
	printf "OK - Daylite has spawned at least one Postgres instance.\n"
	exit 0
else
	printf "CRITICAL - Daylite has no Postgres instances running!.\n"
	exit 2
fi