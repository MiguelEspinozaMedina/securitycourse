#include<stdio.h>


CanNeverExecute()
{
	printf("I can never execute\n");
}


GetInput()
{
	char buffer[8]; // declares buffer size and gives it datatype char

	gets(buffer); // gets user input
	puts(buffer); // puts 
}

main()
{
	GetInput();  // calls GetInput function

	return 0;
}


