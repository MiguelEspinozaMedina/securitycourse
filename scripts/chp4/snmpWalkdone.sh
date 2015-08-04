#!/bin/bash
# Purpose:
# Purpose:
# Scan target network to identify SNMP servers..
# Use snmpwalk and snmpcheck to gather info about the discovered servers.
enumWin="1.3.6.1.4.1.77.1.2.25"
enumWinProcs="1.3.6.1.2.1.25.4.2.1.2"
function nmapSN
{
	win="Microsoft"
        nmap -v -sn 192.168.$1.200-254 -oG NMAPsn-subnet$1.txt
        node=("$(grep Up NMAPsn-subnet$1.txt | cut -d " " -f2 > NMAPsn-subnetOut$1.txt)")
        rest=("$(cat NMAPsn-subnetOut$1.txt)")
	for addr in $rest
        do
                result="$(nmap -O -v $addr | grep "Running" | cut -d " " -f4)"
                if [ $win = $result ]
                then
                        echo "$addr is a windows SMB machine"
                        echo $addr > SNMPsrv.txt
                else
			echo "$addr is not running SNMP"
		fi
	done
	while read ip
	do
		snmpwalk -c public -v1 $ip private
		echo "Done snmpwalk scan"
		snmpcheck -c public -v 1 -t $ip 
		echo "Done snmpcheck scan"
		onesixtyone -c community -i $ip
	done < SNMPsrv.txt
} >> SNMPfinalOut.txt 
nmapSN 42
nmapSN 43
