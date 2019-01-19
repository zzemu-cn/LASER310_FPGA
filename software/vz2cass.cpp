#include <cstdint>
#include <cstdio>

/*
struct vz {
	unsigned long vz_magic;
	char vz_name[17];
	unsigned char vz_type;
	unsigned short vz_start;
} __attribute__((__packed__));

struct cas {
	unsigned char preamble[128];
	unsigned char leadin[5];
	unsigned char filetype;
	char name[17];
	unsigned short startaddr;
	unsigned short endaddr;
	unsigned char data[1];
} __attribute__((__packed__));
*/

// return 0  ---  err format
// cass buf len
uint32_t vz2cass(uint8_t* vz_buf, uint32_t vz_len, uint8_t* buf)
{
	uint32_t	n, i, j, fn_len, prg_len, mif_len, cass_len, prg_end;
	//uint16_t	dat_sum	=	0xFF00;
	uint16_t	dat_sum	=	0;

	if(vz_len <= 4+17+1+2)	return 0;

	//printf("VZF_MAGIC %02X %02X %02X %02X\n", vz_buf[0], vz_buf[1], vz_buf[2], vz_buf[3]);

	//VZF_MAGIC 0x20 0x20 0x00 0x00
	//VZF_MAGIC 0x56 0x5a 0x46 0x30 VZF

	if(		!	( 	( vz_buf[0]==0x20 && vz_buf[1]==0x20 && vz_buf[2]==0x00 && vz_buf[3]==0x00 )
				||	( vz_buf[0]==0x56 && vz_buf[1]==0x5a && vz_buf[2]==0x46 && vz_buf[3]==0x30 )
				) )
		return 0;

	i = 4;
	for(n=0;n<17;n++)
		if(vz_buf[i+n]=='\0') break;

	//printf("filename len : %d\n",n);

	fn_len = (n>=17)?17:n+1;
	prg_len = vz_len -4-17-1-2;
	mif_len = 2+1+128+5+1+fn_len+2+2+prg_len+2+20;
	cass_len =    128+5+1+fn_len+2+2+prg_len+2+20;

	//printf("prg len : %d\n",prg_len);
	//printf("mif len : %d\n",mif_len);

	j = 0;
	buf[j] = cass_len&0xff;
	buf[j+1] = (cass_len>>8)&0xff;

	// wait 0.003s
	j = 2;
	buf[j] = (2+1+128+5+1+fn_len)&0xff;

	// cass sync head
	j = 2+1;
	for(n=0;n<128;n=n+1)
		buf[j+n] = 0x80;

	j = 2+1+128;
	for(n=0;n<5;n=n+1)
		buf[j+n] = 0xFE;

	// VZF_TYPE
	i = 4+17;
	j = 2+1+128+5;
	buf[j] = vz_buf[i];

	// VZF_FILENAME
	i = 4;
	j = 2+1+128+5+1;
	for(n=0;n<fn_len;n=n+1)
		buf[j+n] = vz_buf[i+n];

	// VZF_STARTADDR
	i = 4+17+1;
	j = 2+1+128+5+1+fn_len;
	buf[j+0] = vz_buf[i+0];
	buf[j+1] = vz_buf[i+1];

	prg_end = vz_buf[i+0] + vz_buf[i+1]*256 + prg_len;

	//printf("START ADDR %04X  END ADDR %04X\n", vz_buf[i+0] + vz_buf[i+1]*256, prg_end);

	// END ADDR
	buf[j+2] = prg_end&0xff;
	buf[j+3] = (prg_end>>8)&0xff;

	dat_sum += buf[j+0];
	dat_sum += buf[j+1];
	dat_sum += buf[j+2];
	dat_sum += buf[j+3];


	// DATA
	i = 4+17+1+2;
	j = 2+1+128+5+1+fn_len+2+2;

	for(n=0;n<prg_len;n=n+1) {
		buf[j+n] = vz_buf[i+n];
		dat_sum += buf[j+n];
	}

	j = 2+1+128+5+1+fn_len+2+2+prg_len;

	buf[j+0] = dat_sum&0xff;
	buf[j+1] = (dat_sum>>8)&0xff;

	// cass sync tail
	j = 2+1+128+5+1+fn_len+2+2+prg_len+2;
	for(n=0;n<20;n=n+1)
		buf[j+n] = 0;

	//dat_sum=0xFF00;

	return mif_len;
}
