#!/bin/bash
# Purpose:
# List SMB servers running Windows.
# Use NSE script to check SMB vulnerabilities on discovered servers.
# Scan with nbtscan and enum4linux for the differences found in windows versions.
win="Microsoft"
node="192.168.43.34"
result="$(nmap -O -v $node | grep "Running" | cut -d " " -f4)"
if [ $win = $result ]
then
	echo "$node is a windows SMB machine"
	echo $node > winSMBsrv.txt
else
 	echo "$node in not a window SMB machine"
 	echo "$result"
fi
while read n
do
	nmap -v -p 139,445 --script=smb-check-vulns --script-args=unsafe=1 $n
	echo "Done smb-vuln check"
	nbtscan -r $n
	echo "Done nbtscan check"
	enum4linux -a $n
	echo "Done enum4linux check"
	done < winSMBsrv.txt

