.data
	HelloWorldString:
		.asciz "Hello World of Assembly!"
	H3110:
		.asciz "H3110"
.bss

	.lcomm Destination, 100
	.lcomm DestinationUsingRep, 100
	.lcomm DestinationUsingStos, 100

.text

	.global _start
	
	_start:
		nop
		# 1. Simple copying using movsb, movsw, movsl

		movl $HellowWorldString, %esi
		movl $Destination, %edi

		movsb
		movsw
		movsl

		# 2. Setting /Clearing the DF flag

		std # set the DF flag
		cld # clear the DF flag

		# 3. Using Rep
	
		movl $HelloWorldString %esi
		movl $DestinationUsingRep, %edi
		movl $25 %ecx #333 set the string leng in ECX
		cld # clear the DF
		rep movsb
		std
	
		# 4. Loading string from memory into EAX register

		cld
		leal HelloWorldString, %esi
		lodsb 
		movb $0, %al

		dec %esi
		lodsw
		movw $0, %ax

		subl $1, %esi #33 Make ESI point back to the original string
		lodsl

		# 5. Storing strings from EAX to memory

		leal DestinationUsingStos, %edi
		stosb
		stosw
		stosl

		# 6. Comparing Strings

		cld
		leal HelloWorldString, %esi
		leal H3110, %edi
		cmpsb

		dec %esi
		dec %edi
		cmpsw

		# The exit() routine

		movl $1, %eax
		movl $10, %ebx
		int $0x80


		
