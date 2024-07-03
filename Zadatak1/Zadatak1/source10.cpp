// automati i formalni jezici
// zadatak 1

#define _CRT_SECURE_NO_WARNINGS
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <bitset>

extern "C"
{
	void asmMain(void);
	int asmScanf(char* dest, int maxLen);
	// Funkcija za konvertovanje decimalnog u binarni broj
	void convertToBinary(char* buffer, int num, int bufferSize);
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

// NAPOMENA: funkcija je preuzeta s interneta i modifikovana prema potrebama zadatka

void convertToBinary(char* buffer, int num, int bufferSize) {
	std::string binary = std::bitset<16>(num).to_string(); // Pretvora broj u binarni niz od 16 bita
	strncpy(buffer, binary.c_str(), bufferSize); // Kopira binarni niz u buffer
}

int main(void)
{
	printf("Poziv asemblerske funkcije\n");
	asmMain();
	printf("Povratak iz asemblerske funkcije\n");
}