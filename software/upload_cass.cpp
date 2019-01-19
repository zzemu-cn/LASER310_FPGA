// g++ -std=c++17 -o upload_cass upload_cass.cpp vz2cass.cpp UART.cpp -mconsole -DMINGW_HAS_SECURE_API -D_FILE_OFFSET_BITS=64 -IC:/MinGW/include
#include <cstdint>

#include <cstdio>
#include <cstdlib>
#include <cstring>

#define DBG
#include "upload_tool.cpp"

int main (int argc, char *argv []) {

    //char *port = malloc (sizeof (char) * 12); // Just for "straight to test purposes", in production, use the port detection functions instead
    //strcpy(port, "\\\\.\\COM3");

//------------------------------------ Stand-alone function to do their straight work the most synchronous way ------------------------------------

//    AVAILABLE_PORTS *ports;                         // Initializing the struct values
//    ports = malloc(sizeof(AVAILABLE_PORTS));
//    updateAvailablePortsInfo(ports);                // Setup/load time, the function will update the living struct

	int	uart_com_no = 0;

	uint8_t		vz_buf[1024*64];
	uint8_t		buf[1024*64];
	uint32_t	mif_len;
	size_t		vz_len;

    if(argc<2) {
		fprintf(stderr, "usage: upload_cass COMx name.vz\n");
		return 1;
	}

	uart_com_no = getCOMx(argv[1]);
	if(uart_com_no==0) { printf("COMx err %d", uart_com_no); return 1; }

	int err = vz_upload (argv[2], uart_com_no);

	if(!err)
		printf("uploaded completed");

    return err?1:0;
}
