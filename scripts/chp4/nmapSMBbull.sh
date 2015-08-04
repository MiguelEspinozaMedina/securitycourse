!/bin/bash
# Purpose:
# List SMB servers running Windows.
# Use NSE script to check SMB vulnerabilities on discovered servers.
# Scan with nbtscan and enum4linux for the differences found in windows versions.
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
                        echo $addr >> winSMBsrv.txt
                fi
		done
} 
nmapSN 42
nmapSN 43
