.data
	Bash:
		.asciz "/bin/bash"
	Null:
		.int 0
	AddrToBash:
		.int 0
	Null2:
		.int 0

.text
	.globl _start
_start:
	# Execve routine

	movl $Bash, AddrToBash
	movl $11, %eax
	movl $Bash, %ebx
	movl $AddrToBash, %ecx
	movl $Null2, %edx
	int $0x80

	# Exit Routine

	Exit:
	movl $10, %ebx
	movl $1, %eax
	int $0x80
