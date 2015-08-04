#!/usr/bin/python

import os

for x in range(200, 254):
	p = os.popen('ping -c 1 192.168.43.x | grep "bytes from" | cut -d "" -f 4| cut -d ":" -f 1')
	s = p.readline()
	p.close()
	print s

