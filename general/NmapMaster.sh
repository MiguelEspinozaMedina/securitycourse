#!/bin/bash
location='Lab_Vlan'
subnet='192.168.31.200-254'
ipList='results/ipList.txt'

# Creates the output and the results directory if they need to be created
if [ ! -d "output" ]; then
    mkdir output
    mkdir results
fi

# Run a host discovery scan to see which devices are available in the subnet
ScanType='nmap-sP'
echo "The Host discovery $ScanType scan started" >> elapsedTime.txt
date >> elapsedTime.txt
nmap -sP $subnet -oN output/$location-$ScanType.nmap
echo "The Hosted discovery $ScanType scan ended" >> elapsedTime.txt
date >> elapsedTime.txt

# From the host discovery put together a list of IP Addresses that can be used in future scans
if [ -f "output/$location-$ScanType.nmap" ]; then
    cat output/$location-$ScanType.nmap | grep "Nmap scan report for" | awk '{print $5}' > $ipList
else
    echo "Unable to find the nmap host discovery list."
    exit
fi


################### Create a loop of the various nmap scans to perform ##############################
declare -a nmapSwitches=(
	    '-sV -p 80,443,8080 --open'
	    '-sV -p 20,21 --open'
	    '-sV -p 22 --open'
	    '-sV -p 23 --open'
	    '-p 69 -sU --open'
            '-sV -p 5800,5801,5802,5803,5900,5901,5902,5903 --open'
            '-sV -p 3389 --open'
	    '-p T:53,U:53 --open'
            '-p 161 -sU --open'
	    '-sV -p 139,445 --open'
	    '-sV -p 25,110,465,587 --open'
	    '-sV -p 156,1433,1434,2382,2383,4022 --open'
	    '-sV -p 3306 --open'    
	    '-sV -p 1521 --open'        
	    '-sV -p 8222,8333 --open'
	    '-sV -p 194 --open' 
			);

declare -a typeOfScan=(
	     'nmap-sV-WEB'
	     'nmap-sV-FTP'
	     'nmap-sV-SSH'
	     'nmap-sV-TELNET'
	     'nmap-sV-TFTP'
            'nmap-sV-VNC'
	    'nmap-sV-RDP'
            'nmap-DNS'
            'nmap-sU-SNMP'
            'nmap-sV-SMB'
            'nmap-sV-MAIL'
       	    'nmap-sV-MSSQL'
	    'nmap-sV-MYSQL'
	    'nmap-sV-ORACLE'
	    'nmap-sv-VMWARE'
            'nmap-sv-IRC'
			);
	
echo "The nmap sV scan started" >> elapsedTime.txt
date >> elapsedTime.txt

for ((i=0; i<${#nmapSwitches[@]}; i++)); do
    typeOfScanVar=${typeOfScan[$i]}
    nmapSwitchesVar=${nmapSwitches[$i]}
    nmap $nmapSwitchesVar -iL $ipList -oN output/$location-$typeOfScanVar.nmap
done

echo "The nmap sV scan ended" >> elapsedTime.txt
date >> elapsedTime.txt
