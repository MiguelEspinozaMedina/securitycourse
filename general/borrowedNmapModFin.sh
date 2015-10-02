#!/bin/bash
location='Lab_Vlan'
subnet='192.168.43.200-254'
ipList='results/ipList.txt'

# Creates the output and the results directory if they need to be created
if [ ! -d "output" ]; then
    mkdir output
    mkdir results
fi

# Run a host discovery scan to see which devices are available in the subnet
typeOfScan='nmap-sP'
echo "The nmap-sP scans started" >> elapsedTime.txt
date >> elapsedTime.txt
nmap -sP $subnet -oA output/$location-$typeOfScan
echo "The nmap-sP scan ended" >> elapsedTime.txt
date >> elapsedTime.txt

# From the host discovery put together a list of IP Addresses that can be used in future scans
if [ -f "output/$location-$typeOfScan.nmap" ]; then
    cat output/$location-$typeOfScan.nmap | grep "Nmap scan report for" | awk '{print $5}' > $ipList
else
    echo "Unable to find the nmap host discovery list."
    exit
fi


################### Create a loop of the various nmap scans to perform ##############################
declare -a nmapSwitches=('-sV -p 20,21,22 --open --script ftp-anon.nse'
	    '-T5 -PN -p 445 -sS -n --min-hostgroup 8192 --min-rtt-timeout 1000 --min-parallelism 4096 --script nbstat.nse'
            '-sV -p 5800,5801,5802,5803,5900,5901,5902,5903 --open --script vnc-info.nse'
            '-sV -p 5800,5801,5802,5803,5900,5901,5902,5903 --open --script realvnc-auth-bypass.nse'
            '-p 69 -sU --open --script tftp-enum.nse'
            '-p T:53,U:53 --open'
            '-p 161 -sU --script snmp-brute'
            '--script smb-os-discovery.nse -p 139,445'
            '--script smb-check-vulns -p 139,445 --script-args unsafe=1'
            '--script smb-enum-shares.nse --script-args smbdomain=domain,smbuser=user,smbpass=password -p 445'
            '--script smtp-enum-users.nse -p 25,465,587'
            '--script smtp-vuln-cve2011-1764.nse -p 25,465,587'
	    '--script smb-security-mode.nse -p 139,445'
	    '--script ftp-vuln-cve2010-4221.nse -p 21'
	    '--script mysql-vuln-cve2012-2122.nse -p 3306'
	    '--script rmi-vuln-classloader.nse -p 1099'
	    '--script nmap-Rdp-vuln-ms12-020.nse -p 3389'
	    '--script afp-path-vuln.nse'
	    '--script http-vuln-cve2012-1823.nse'
	    '--script http-vuln-cve2013-0156.nse'
            '--script http-iis-webdav-vuln.nse'
	    '--script http-vmware-path-vuln.nse -p 80,443,8222,8333'
	    '--script http-vuln-zimbra-lfi.nse');
declare -a typeOfScan=('nmap-sV-FTP'
	    'nmap-Nbstat'
            'nmap-sV-VNC'
            'nmap-sV-VNC-auth-bypass'
            'nmap-sU-TFTP'
            'nmap-DNS'
            'nmap-SNMP'
            'nmap-Samba-445'
            'nmap-Samba-check-vulns'
            'nmap-Samba-enum-shares'
            'nmap-Smtp-enum-users'
            'nmap-Smtp-vuln-cve2011-1764'
	    'nmap-Smb-security-mode'
	    'nmap-Ftp-vuln-cve2010-4221'
	    'nmap-Mysql-vuln-cve2012-2122'
	    'nmap-Rmi-vuln-classloader'
	    'nmap-Rdp-vuln-ms12-020'
	    'nmap-Afp-path-vuln'
	    'nmap-Http-vuln-cve2012-1823'
	    'nmap-Http-vuln-cve2013-0156'
	    'nmap-Http-iis-webdav-vuln'
	    'nmap-Http-vmware-path-vuln'
	    'nmap-Http-vuln-zimbra-lfi');

echo "The nmap scripts scans started" >> elapsedTime.txt
date >> elapsedTime.txt

for ((i=0; i<${#nmapSwitches[@]}; i++)); do
    typeOfScanVar=${typeOfScan[$i]}
    nmapSwitchesVar=${nmapSwitches[$i]}
    nmap $nmapSwitchesVar -iL $ipList -oA output/$location-$typeOfScanVar
done

echo "The nmap scripts scans ended" >> elapsedTime.txt
date >> elapsedTime.txt
