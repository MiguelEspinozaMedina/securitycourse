#!/usr/bin/python
import socket
import sys
if len(sys.argv) != 2:
	print "Usage: vrfy.py <username>"
	sys.exit(0)

# Create socket and connect to the Server
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
connect=s.connect(('192.168.43.34',25))
# Receive the banner
banner=s.recv(1024)
print banner
# VRFY a user
s.send('VRFY ' + sys.argv[1] + '\r\n')
result=s.recv(1024)
print result
# close the socket
s.close()
