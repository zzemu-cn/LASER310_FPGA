// VZ200.FNT 是 LASER310 的 MC6847 芯片内部自带的字库文件
// 8 x 12 点阵 256个字符
// 256*12 = 3072字节

// MinGW
// gcc VZ200_FNT.c -o VZ200_FNT -std=c99

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int readfile(char* filename, char* p, size_t sz )
{
	FILE *fp;

	fp = fopen(filename, "rb");
	if(!fp) {
		printf("Open %s Failure", filename);
		return 1;
	}

	for(int i=0;i<sz;i++)
		p[i] = fgetc(fp);

	fclose(fp);

	return 0;
}


void showbit(uint8_t c)
{
	for(int i=0; i<12; i++, c>>=1 )
		if(c&1)
				printf("#");
			else
				printf(" ");
}

int main(void)
{
	//const int fnt_rom_len = 1024*3;
	const int fnt_rom_len = 256*12;
	uint8_t fnt_rom[fnt_rom_len];


	readfile( "VZ200.FNT", fnt_rom, fnt_rom_len );

	int pos = 0;
	while(pos<fnt_rom_len) {
		for( int i=0; i<12; i++ ) {
			showbit(fnt_rom[pos+i]);
			printf("\n");
		}
		printf("--------\n");
		pos += 12;
	}

	return 0;
}
