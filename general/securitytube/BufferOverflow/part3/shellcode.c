#include<stdio.h>

char shellcode[] = ""
		   ""
		   "";

int main() {

	int *ret;
	ret = (int *) &ret +2;
	(*ret) = (int)shellcode;

}


