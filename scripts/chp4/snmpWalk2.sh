#!/bin/bash
# Purpose:
# Scan target network to identify SNMP servers..
# Use snmpwalk and snmpcheck to gather info about the discovered servers.
enumWin="1.3.6.1.4.1.77.1.2.25"
enumWinProcs="1.3.6.1.2.1.25.4.2.1.2"

function nmapSN
{ 
	#win="Microsoft"
	#nmap -v -sn 192.168.$1.200-254 -oG NMAPsn-subnet$1.txt
	#node=("$(grep Up NMAPsn-subnet$1.txt | cut -d " " -f2)")

for addr in "${node[@]}"
do

	#result="$(nmap -O -v $addr | grep "Running" | cut -d " " -f4)"
	#if [ $win = $result ]
	#then
	#	echo "$addr is running SNMP"
	#	echo $addr > snmpSrvResult.txt
	#else
 	#	echo "$addr in not running SNMP"
 	#	echo "$result"
	#fi
	while read n
	do
		snmpwalk -c public -v1 $n $enumWin
		snmpwalk -c public -v1 $n $enumWinProcs
		echo "####################"
		echo "Done snmpwalk check"
		echo "####################"
		snmpcheck -c public -v1 -t $n $enumWin
		snmpcheck -c public -v1 -t $n $enumWinProcs
		echo "####################"
		echo "Done snmpcheck check"
		echo "####################"
	done < UPsrv.txt
done >> SNMPchecks.txt
}
nmapSN 42 #call functions
nmapSN 43
