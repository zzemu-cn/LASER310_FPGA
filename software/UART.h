#ifndef UARTH
#define UARTH

#include <windows.h>

#define CURRENT_PORT 0

bool UART_Open(int comPort, int baudRate, int parity, int stopbit);
bool UART_Close(int comPort = CURRENT_PORT);
bool UART_ChangePort(int comPort);
bool UART_ClearBuf(void);
bool UART_GetStr(char *str);
bool UART_GetData(unsigned char *data, unsigned long num);
bool UART_SetStr(const char *str);
bool UART_SetData(const unsigned char *data, unsigned long num);
const char *UART_GetLastErrMsg(void);

#endif