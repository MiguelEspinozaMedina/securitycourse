#!/bin/bash
nmap -v -sn 192.168.43.200-254 -oG ping-sweep.txt
grep Up ping-sweep.txt | cut -d " " -f 2 >> Upmachines.txt
while read machine;
do
#nmap -O -p 80 $machine
nmap $machine --script smb-os-discovery.nse > SMBservers.txt
done < Upmachine.txt

while read machineSMB;
do
nmap $machineSMB --script smb-check-vulns.nse > SMBvuln.txt
done < SMBservers.txt

while read machineChk;
do
echo "Starting nbtscan and enum4linux"
#nbtscan >> CHK.txt
#enum4linux >> CHK.txt
done < SMBservers.txt
