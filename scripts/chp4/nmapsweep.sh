#!/bin/bash
nmap -v -sn 192.168.43.200-254 -oG ping-sweep.txt
grep Up ping-sweep.txt | cut -d " " -f 2 >> Upmachines.txt
while read machine;
do
nmap -O -p 80 $machine
nmap $machine --script smb-os-discovery.nse
done < Upmachine.txt
