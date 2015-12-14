# Demo program to show how to use Data types and MOVx instructions

.data 
	HelloWorld:
	ByteLocation:
		.byte 10
	int32:
		.int 2
	int16:
		.short 3
	IntegerArray:
		.int 10,20,30,40,50

.bss
	.comm LargeBuffer, 10000

.text
	
	.global _start
	_start:
		nop
		# Exit syscall to ex the program

		movl $1, %eax
		movl $0, %ebx
		int $0x80

