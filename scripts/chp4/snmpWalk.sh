#!/bin/bash
# Purpose:
# Scan target network to identify SNMP servers..
# Use snmpwalk and snmpcheck to gather info about the discovered servers.
enumWin="1.3.6.1.4.1.77.1.2.25"
enumWinProcs="1.3.6.1.2.1.25.4.2.1.2"

while read n
	do
		comm="$(onesixtyone -c community $n)"
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
		echo $comm > onesix.txt
	done < UPsrv.txt
}
