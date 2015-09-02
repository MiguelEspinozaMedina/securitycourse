#!/bin/bash
function pingit
{
for address in $(seq 200 242); do
ping -c 1 192.168.$1.$address | grep "bytes from" | cut -d " " -f4| cut -d " " -f 1 | awk -F ":" '{ print $1 }'&
done
}
#pingit 42 > UPhost.txt
pingit 43 > UPhost.txt
