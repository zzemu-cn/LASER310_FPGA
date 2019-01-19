// g++ -std=c++17 -o vz2mif vz2mif.cpp vz2cass.cpp -mconsole -DMINGW_HAS_SECURE_API -D_FILE_OFFSET_BITS=64 -IC:/MinGW/include
#include <cstdint>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "UART.h"

#include "vz2cass.h"

size_t filelen(FILE *fp)
{
	size_t	curpos, pos;

	if( (curpos = ftello(fp))==-1LL )
		return -1LL;

	if( fseeko( fp, 0LL, SEEK_END ) )
		return -1LL;

	if( (pos = ftello(fp))==-1LL )
		return -1LL;

	if( fseeko( fp, curpos, SEEK_SET ) )
		return -1LL;

	return pos;
}

/* 每次读取 1G */
#define FREAD_LEN 0x40000000LL

size_t readfile(char* fn, uint8_t* buf)
{
	FILE	*fp;
	size_t	sz;

	//printf("fopen\n");
	if( ( fp = fopen(fn, "rb") ) == NULL ) return 0;

	//printf("filelen\n");
	sz = filelen(fp);
	if( sz<=0 ) { fclose(fp); return 0; }

	/* 实测，win64 mingw环境下，fread 一次读取不能超过 2G (包括2G) */

	/* 每次读取 1G */
	size_t	read_c=0LL;
	size_t	read_sz;

	while(read_c<sz) {
		read_sz = (read_c+FREAD_LEN<=sz) ? FREAD_LEN : sz-read_c;
		//printf("fread %d %d %d\n", sz, read_c, read_sz);
		if( fread( (char*)buf+read_c, read_sz, 1, fp ) != 1LL ) { fclose(fp); return 0; }
		read_c+=read_sz;
	}

	fclose(fp);

	return read_c;
}

size_t writefile(char* fn, uint8_t* buf, size_t sz)
{
	FILE	*fp;
	size_t	n;

	if( ( fp = fopen(fn, "wb") ) == NULL ) return 0;

	n = fwrite(buf, 1, sz, fp);

	fclose(fp);

	return n;
}

int main (int argc, char *argv []) {

    //char *port = malloc (sizeof (char) * 12); // Just for "straight to test purposes", in production, use the port detection functions instead
    //strcpy(port, "\\\\.\\COM3");

//------------------------------------ Stand-alone function to do their straight work the most synchronous way ------------------------------------

//    AVAILABLE_PORTS *ports;                         // Initializing the struct values
//    ports = malloc(sizeof(AVAILABLE_PORTS));
//    updateAvailablePortsInfo(ports);                // Setup/load time, the function will update the living struct


	uint8_t		vz_buf[1024*64];
	uint8_t		buf[1024*64];
	uint32_t	mif_len;
	size_t		vz_len;

    if(argc<2) {
		fprintf(stderr, "usage: vz2mif name.vz output.cas\n");
		return 1;
	}

	vz_len = readfile(argv[1],vz_buf);
	if(!vz_len) { printf("file read err %d", vz_len); return 0; }

	//printf("vz_len %d", vz_len);

	mif_len = vz2cass(vz_buf, vz_len, buf);
	if(!mif_len) { printf("vz2cass err %d", mif_len); return 0; }

	char		mif_buf[1024*256];
	char*		s;

	s = mif_buf;

	s += sprintf(s, "DEPTH = %d;\n", mif_len);
	s += sprintf(s, "WIDTH = 8;\n");
	s += sprintf(s, "ADDRESS_RADIX = HEX;\n");
	s += sprintf(s, "DATA_RADIX = HEX;\n");
	s += sprintf(s, "CONTENT\n");

	s += sprintf(s, "BEGIN\n");
	for(int i=0;i<mif_len;i++) {
		s += sprintf(s, "%04X:%02X;\n",  i, buf[i]);
	}

	s += sprintf(s, "END;\n");

	writefile(argv[2], (uint8_t*)mif_buf, strlen(mif_buf)+1);

    return 0;
}
