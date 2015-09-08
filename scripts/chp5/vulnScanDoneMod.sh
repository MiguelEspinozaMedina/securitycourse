#!/bin/bash
# Purpose:
# A master script that uses recon tools permitted on the exam.
# Todo chapter 3 Email Harvesting, whois, Google Hacks.
# Todo chapter 4 dnsrecon, host -t,SNMPwalk,SNMPcheck,onesixtyone.
# List SMB servers running Windows.
# Use NSE script to check SMB vulnerabilities on discovered servers.
# Scan with nbtscan and enum4linux for the differences found in windows versions.

function nmapSN
{
	win="Microsoft"
        nmap -v -sS 192.168.$1.200-254 -oG NMAPsn-subnet$1.txt
        node=("$(grep Up NMAPsn-subnet$1.txt | cut -d " " -f2 > NMAPsn-subnetOut$1.txt)")
        rest=("$(cat NMAPsn-subnetOut$1.txt)")
	for addr in $rest
        do
                result="$(nmap -O -v $addr | grep "Running" | cut -d " " -f4)"
                if [ $win = $result ];
                then
                        echo "$addr is a windows SMB machine"
                        echo $addr >> srv.txt
                else
			echo "$addr may be Linux OS"
			echo $addr >> srv.txt
		fi
	done
	while read ip
	do
                nmap -v -p 21 --script=ftp-anon.nse $ip
                echo "Done ftp-anon.nse check"
		nmap -v -p 139,445 --script=smb-check-vulns.nse --script-args=unsafe=1 $ip
		echo "Done smb-check-vulns.nse"
		nmap --script=smtp-enum-users.nse $ip
		echo "Done smtp-enum-users.nse"
		nbtscan -r $ip
		echo "Done nbtscan check"
		enum4linux -a $ip
		echo "Done enum4linux check"
	done < srv.txt
} >> FinalOutWinFTP.txt 
#nmapSN 2
nmapSN 43
