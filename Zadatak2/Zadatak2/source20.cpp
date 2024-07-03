// automati i formalni jezici
// zadatak 2

#define _CRT_SECURE_NO_WARNINGS
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern "C"			
{
	int asmScanf(char* dest, int maxLen);
	void asmMain(void); 
};

int asmScanf(char* dest, int maxLen)
{
	char* result = fgets(dest, maxLen, stdin);
	if (result != NULL)
	{
		int len = strlen(result);
		if (len > 0)
		{
			dest[len - 1] = 0;
		}
		return len;
	}
	return NULL;
}

int main(void)
{
	scanf("");
	printf("Poziv asemblerske funkcije\n");
	asmMain();
	printf("Povratak iz asemblerske funkcije\n");
}