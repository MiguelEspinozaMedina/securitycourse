#!/bin/bash
# Purpose:
# List SMB servers running Windows.
# Use NSE script to check SMB vulnerabilities on discovered servers.
# Scan with nbtscan and enum4linux for the differences found in windows versions.
function nmapSN
{ 
	win="Microsoft"
	nmap -v -sn 192.168.$1.200-254 -oG NMAPsn-subnet$1.txt
	node=("$(grep Up NMAPsn-subnet$1.txt | cut -d " " -f2)")
	echo "${node[@]}"
}

nmapSN 42 #call functions
nmapSN 43

for addr in "${node[@]}"
do

	result="$(nmap -O -v $addr | grep "Running" | cut -d " " -f4)"
	if [ $win = $result ]
	then
		echo "$addr is a windows SMB machine"
		echo $addr > winSMBsrv.txt
	else
 		echo "$addr in not a window SMB machine"
 		echo "$result"
	fi
	while read n
	do
		nmap -v -p 139,445 --script=smb-check-vulns --script-args=unsafe=1 $n
		echo "####################"
		echo "Done smb-vuln check"
		echo "####################"
		nbtscan -r $n
		echo "####################"
		echo "Done nbtscan check"
		echo "####################"
		enum4linux -a $n
		echo "####################"
		echo "Done enum4linux check"
		echo "####################"
	done < winSMBsrv.txt
done >> SMBresult.txt
