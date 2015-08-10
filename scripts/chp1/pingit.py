#!/usr/bin/python
for ping in range(200,254):
	ip="192.168.43."+str(ping)
	os.system("ping -c 3 %s" % ip)
