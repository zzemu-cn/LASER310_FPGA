// VZ200.FNT 是 LASER310 的 MC6847 芯片内部自带的字库文件
// 8 x 12 点阵 256个字符
// 256*12 = 3072字节

// 为了简化设计(避免乘3操作)，字库的点阵转化为 8*16，即3KB变为4KB

// MinGW
// gcc VZ200_FNT_3K_to_4K.c -o VZ200_FNT_3K_to_4K -std=c99

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

int writefile(char* filename, char* p, size_t sz )
{
	FILE *fp;

	fp = fopen(filename, "wb");
	if(!fp) {
		printf("Open %s Failure", filename);
		return 1;
	}

	for(int i=0;i<sz;i++)
		fputc(p[i], fp);

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

	const int fnt_rom_4K_len = 256*16;
	uint8_t fnt_rom_4K[fnt_rom_4K_len];


	readfile( "VZ200.FNT", fnt_rom, fnt_rom_len );

	int pos = 0;
	int pos_4K = 0;
	while(pos<fnt_rom_len) {
		for( int i=0; i<12; i++ ) {
			fnt_rom_4K[pos_4K+i] = fnt_rom[pos+i];
		}
		for( int i=12; i<16; i++ ) {
			fnt_rom_4K[pos_4K+i] = 0;
		}
		pos += 12;
		pos_4K += 16;
	}

	writefile( "VZ200_4K.FNT", fnt_rom_4K, fnt_rom_4K_len );

	return 0;
}
