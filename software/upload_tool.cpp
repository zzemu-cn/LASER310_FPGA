#include "vz2cass.h"

#include "UART.h"

//9600 19200 38400 57600 115200
#define BAUDRATE 57600

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

size_t readfile(const char* fn, uint8_t* buf)
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


int vz_upload (const char *fn, int uart_com_no)
{
	uint8_t		vz_buf[1024*64];
	uint8_t		buf[1024*64];
	uint32_t	mif_len;
	size_t		vz_len;

	vz_len = readfile(fn,vz_buf);
	if(!vz_len) {
#ifdef	DBG
		printf("file read err %d", vz_len);
#endif
		return 1;
	}

	//printf("vz_len %d\n", vz_len);
	mif_len = vz2cass(vz_buf, vz_len, buf);
	if(!mif_len) {
#ifdef	DBG
		printf("vz2cass err %d", mif_len);
#endif
		return 2;
	}

	//printf("upload len %d\n", mif_len);

	size_t		dataLen;
	uint8_t		data[256];
	uint8_t		data_chk;

	uint8_t		rcvData[2];

	//9600 19200 38400 57600 115200
	if( !UART_Open(uart_com_no, BAUDRATE, NOPARITY, ONESTOPBIT) )
		return 3;

	// sync
	for(int i=0;i<5;i++) {
		data[0] = 0;
		dataLen = 1;
		UART_SetData(data, dataLen);
	}

	for(int i=0;i<3;i++)
		UART_GetData(rcvData, 1);

//
	int err=0;
	uint16_t	Addr = 0x0000;
	uint16_t	pkg_len;
	uint8_t		pkg_chk;

	//for(int i=0;i<mif_len;i++) {

	int	i=0;
	while(i<mif_len) {
		if(mif_len-i>=256)
			pkg_len = 256;
		else
			pkg_len = mif_len-i;

#ifdef	DBG
		printf("send(%04X) len %02X\n", Addr, pkg_len);
#endif

		data[0] = 0x02;
		data[1] = Addr&0xff;
		data[2] = (Addr>>8)&0xff;
		data[3] = (uint8_t)pkg_len&0xff;
		pkg_chk = (uint8_t)0xAA^data[1]^data[2]^data[3];
		data[4] = pkg_chk;

		dataLen = 5;
		//for(int c=0;c<dataLen;c++)	printf("send %i: %02X\n", c, data[c]);
		UART_SetData(data, dataLen);

		rcvData[0] = 0;
		while(!UART_GetData(rcvData, 1));

		if(rcvData[0]!=0) {
#ifdef	DBG
			printf("recv write echo %02X\n", rcvData[0]);
#endif
			err=1;
			break;
		}

		for(int j=0;j<pkg_len;j++) {
			data[j] = buf[i+j];
			pkg_chk ^= buf[i+j];
		}

		dataLen = pkg_len;
		//for(int c=0;c<dataLen;c++)	printf("send %i: %02X\n", c, data[c]);
		UART_SetData(data, dataLen);

		rcvData[0] = 0;
		while(!UART_GetData(rcvData, 1));
		//printf("recv write echo %02X\n", rcvData[0]);

		if(rcvData[0]!=pkg_chk) {
#ifdef	DBG
			printf("send(%0x4X) recv write echo %02X\n", Addr, rcvData[0]);
#endif
			err=1;
			break;
		}

		Addr += pkg_len;

		i += pkg_len;
	}

	UART_Close();

	if(err)
		return 4;

    return 0;
}

int getCOMx(char*s)
{
	if( strlen(s)!=4 ) return 0;
	if( !(s[0]=='C'||s[0]=='c') ) return 0;
	if( !(s[1]=='O'||s[1]=='o') ) return 0;
	if( !(s[2]=='M'||s[2]=='m') ) return 0;
	if( !(s[3]>='1'||s[3]<='9') ) return 0;
	return s[3]-'0';
}


int keyb_upload(const uint8_t* buf, int uart_com_no)
{
	size_t		dataLen;
	uint8_t		data[256];
	uint8_t		data_chk;

	uint8_t		rcvData[2];
	uint8_t		ch;

	int	n, c;

	//9600 19200 38400 57600 115200
	if( !UART_Open(uart_com_no, BAUDRATE, NOPARITY, ONESTOPBIT) )
		return 0;

	// sync
	for(int i=0;i<5;i++) {
		data[0] = 0;
		dataLen = 1;
		UART_SetData(data, dataLen);
	}

	for(int i=0;i<3;i++)
		UART_GetData(rcvData, 1);


	n = strlen((const char*)buf);

	c=0;

	for(int i=0;i<n;i++) {
		ch = buf[i];

		if( !( (ch>=' '&&ch<='^') || (ch>='a'&&ch<='z') || ch==0x03 || ch==0x0D || ch=='_' ) ) continue;

		data[0] = ch;
		dataLen = 1;

		UART_SetData(data, dataLen);

		Sleep(60);	// 0.05s

		// 播放磁带无返回
		if(ch=='_') continue;

		rcvData[0] = 0;
		while(!UART_GetData(rcvData, 1));

		Sleep(1);	// 0.05s

		//printf("recv key echo %02X\n", rcvData[0]);
		if( rcvData[0]!= ch) break;

		c++;
	}

	return c;
}
