#!/bin/bash
function pingit
{
for address in $(seq 200 242); do
ping -c 1 192.168.$1.$address | grep "bytes from" | cut -d " " -f4| cut -d " " -f 1&
done
}
pingit 42
#pingit 43
