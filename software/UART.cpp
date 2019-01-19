/****************************
 *	Module:	UART			*
 *	Author:	Josh Chen		*
 *	Date:	2014/05/15		*
 ****************************/


#include <stdio.h>
#include <windows.h>
#include "UART.h"


//********** Global Variable **********//

#define RX_TIMEOUT      10
#define TX_TIMEOUT      500
#define BUF_SIZE        512
#define MAX_COM_NUM     256

char            UARTErrBuf[BUF_SIZE] = {0};
int             CurrComPort = 0;
HANDLE          UARTHandle[MAX_COM_NUM] = {NULL};
unsigned char   UARTRxBuf[BUF_SIZE] = {0};
unsigned int    UARTRxBufCnt = 0;


//********** Private Function **********//

static void __UartSetLastErr(const char *err, ...)
{
    char szBuf[BUF_SIZE];
    va_list vl;

    memset(UARTErrBuf, 0, sizeof(UARTErrBuf));
    if (NULL != err)
    {
        memset(szBuf, 0, sizeof(szBuf));
        va_start(vl, err);
        vsprintf(szBuf, err, vl);
        va_end(vl);
        sprintf(UARTErrBuf, "*** UART - %s ***\r\n", szBuf);
    }
}

static void __UartSleep(unsigned long ms)
{
    DWORD   beginTick;
    MSG     msg;

    beginTick = ::GetTickCount();
    do
    {
        if (::PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
        {
            ::TranslateMessage(&msg);
            ::DispatchMessage(&msg);
        }
        ::Sleep(1);
    } while ((::GetTickCount() - beginTick) < ms);
}


//********** Public Function **********//

bool UART_Open(int comPort, int baudRate, int parity, int stopbit)
{
    char            szBuf[BUF_SIZE];
    DCB             dcb;
    COMMTIMEOUTS    comTimeOut;

    if ((comPort > MAX_COM_NUM) || (comPort <= 0))
    {
        __UartSetLastErr("COM%d out of range!", comPort);
        return false;
    }

    if (UARTHandle[comPort-1] != INVALID_HANDLE_VALUE && UARTHandle[comPort-1] != NULL)
    {
        __UartSetLastErr("COM%d has already opened!", comPort);
        return false;
    }

    sprintf(szBuf, "\\\\.\\COM%d", comPort);
    UARTHandle[comPort-1] = ::CreateFileA(
        szBuf,
        GENERIC_READ|GENERIC_WRITE,
        0,
        0,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        0
        );

    if (UARTHandle[comPort-1] == INVALID_HANDLE_VALUE)
    {
        __UartSetLastErr("Open COM%d fail.", comPort);
        return false;
    }

    memset(&dcb, 0, sizeof(dcb));
    dcb.DCBlength = sizeof(dcb);
    dcb.BaudRate  = baudRate;
    dcb.ByteSize  = 8;
    //dcb.Parity	= NOPARITY;
    //dcb.StopBits	= ONESTOPBIT;
    dcb.Parity    = parity;
    dcb.StopBits  = stopbit;
    dcb.fOutX     = 0;
    dcb.fInX      = 0;
    dcb.fDtrControl     = DTR_CONTROL_DISABLE;
    dcb.fRtsControl     = RTS_CONTROL_DISABLE;
    dcb.fOutxCtsFlow    = 0;
    dcb.fOutxDsrFlow    = 0;
    dcb.fDsrSensitivity = 0;

    if (!::SetCommState(UARTHandle[comPort-1], &dcb))
    {
        __UartSetLastErr("SetCommState() fail.");
        ::CloseHandle(UARTHandle[comPort-1]);
    		UARTHandle[comPort-1] = INVALID_HANDLE_VALUE;
        return false;
    }

    if (!::SetupComm(UARTHandle[comPort-1], BUF_SIZE, BUF_SIZE))
    {
        __UartSetLastErr("SetupComm() fail.");
        ::CloseHandle(UARTHandle[comPort-1]);
    		UARTHandle[comPort-1] = INVALID_HANDLE_VALUE;
        return false;
    }

    /*comTimeOut.ReadIntervalTimeout         = MAXDWORD;
    comTimeOut.ReadTotalTimeoutMultiplier  = 0;
    comTimeOut.ReadTotalTimeoutConstant    = 0;
    comTimeOut.WriteTotalTimeoutMultiplier = 0;
    comTimeOut.WriteTotalTimeoutConstant   = TX_TIMEOUT;*/
    comTimeOut.ReadIntervalTimeout         = 1;
    comTimeOut.ReadTotalTimeoutMultiplier  = 1;
    comTimeOut.ReadTotalTimeoutConstant    = 1;
    comTimeOut.WriteTotalTimeoutMultiplier = 1;
    comTimeOut.WriteTotalTimeoutConstant   = 1;

    if (!::SetCommTimeouts(UARTHandle[comPort-1], &comTimeOut))
    {
        __UartSetLastErr("SetCommTimeouts() fail.");
        ::CloseHandle(UARTHandle[comPort-1]);
    		UARTHandle[comPort-1] = INVALID_HANDLE_VALUE;
        return false;
    }

    ::PurgeComm(UARTHandle[comPort-1], PURGE_TXABORT|PURGE_RXABORT|PURGE_TXCLEAR|PURGE_RXCLEAR);

    __UartSleep(100);

    CurrComPort = comPort;

    return true;
}


bool UART_Close(int comPort)
{
    unsigned int i = 0;

  	if (comPort == CURRENT_PORT)
        comPort = CurrComPort;

    if (comPort > MAX_COM_NUM || comPort <= 0)
    {
        __UartSetLastErr("COM%d out of range!", comPort);
        return false;
    }

    if (UARTHandle[comPort-1] == INVALID_HANDLE_VALUE || UARTHandle[comPort-1] == NULL)
    {
        __UartSetLastErr("COM%d not opened.", comPort);
        return false;
    }

    CurrComPort = 0;
    for (i = 1; i <= MAX_COM_NUM; i++)
    {
        if (i != comPort && UARTHandle[i-1] != INVALID_HANDLE_VALUE)
        {
            CurrComPort = i;
            break;
        }
    }

    ::PurgeComm(UARTHandle[comPort-1], PURGE_TXABORT|PURGE_RXABORT|PURGE_TXCLEAR|PURGE_RXCLEAR);
    ::CloseHandle(UARTHandle[comPort-1]);
    UARTHandle[comPort-1] = INVALID_HANDLE_VALUE;

    return true;
}


bool UART_ChangePort(int comPort)
{
  	if ((comPort > MAX_COM_NUM) || (comPort <= 0))
    {
        __UartSetLastErr("COM%d out of range!", comPort);
        return false;
    }

  	if (UARTHandle[comPort-1] == INVALID_HANDLE_VALUE || UARTHandle[comPort-1] == NULL)
    {
        __UartSetLastErr("COM%d not opened.", comPort);
        return false;
    }

  	CurrComPort = comPort;

  	return true;
}


bool UART_ClearBuf(void)
{
    if (CurrComPort <= 0)
    {
        __UartSetLastErr("COM port not opened.", CurrComPort);
        return false;
    }

    if (!::PurgeComm(UARTHandle[CurrComPort-1], PURGE_TXABORT|PURGE_RXABORT|PURGE_TXCLEAR|PURGE_RXCLEAR))
    {
        __UartSetLastErr("PurgeComm COM%d error code (%d).", CurrComPort, ::GetLastError());
        return false;
    }

    return true;
}


bool UART_GetStr(char *str)
{
    bool            result = false;
    char            readBuf[BUF_SIZE] = {0};
    unsigned long   readCnt = 0;
  	unsigned long   i = 0;

    if (CurrComPort <= 0)
    {
        __UartSetLastErr("COM port not opened.");
        return false;
    }

    //::ReadFile(UARTHandle[CurrComPort-1], (LPVOID) readBuf, BUF_SIZE, &readCnt, NULL);
  	::ReadFile(UARTHandle[CurrComPort-1], (LPVOID) readBuf, 1, &readCnt, NULL);

    for (i = 0; i < readCnt; i++)
    {
        if (readBuf[i] == '\r' || readBuf[i] == '\n' || UARTRxBufCnt >= BUF_SIZE-1)
        {
            if (UARTRxBufCnt)
            {
                strcpy(str, (const char*) UARTRxBuf);
                memset(UARTRxBuf, 0, sizeof(UARTRxBuf));
                UARTRxBufCnt = 0;
                result = true;
                break;
            }
        }
        else if (readBuf[i] == '\b')
        {
            if (UARTRxBufCnt)
            {
                UARTRxBufCnt--;
                UARTRxBuf[UARTRxBufCnt] = 0;
            }
        }
        else if (readBuf[i])
        {
            UARTRxBuf[UARTRxBufCnt] = readBuf[i];
            UARTRxBufCnt++;
        }
    }

    return result;
}


bool UART_GetData(unsigned char *data, unsigned long num)
{
    bool            result = false;
    unsigned char   readBuf[BUF_SIZE] = {0};
    unsigned long   readCnt = 0;
    unsigned long   remainCnt = num;
    unsigned long   reqCnd = 0;

    if (CurrComPort <= 0)
    {
        __UartSetLastErr("COM port not opened.");
        return false;
    }

    while (remainCnt > 0)
    {
        reqCnd = (remainCnt > BUF_SIZE) ? BUF_SIZE : remainCnt;
        ::ReadFile(UARTHandle[CurrComPort-1], (LPVOID) readBuf, reqCnd, &readCnt, NULL);
        if (readCnt <= 0)
        {
            __UartSetLastErr("Fail to get data.");
            return false;
        }
        else
        {
            memcpy(data, readBuf, readCnt);
            remainCnt -= readCnt;
        }
    }

    return true;
}


bool UART_SetStr(const char *str)
{
    unsigned long writeCnt = 0;

    if (CurrComPort <= 0)
    {
        __UartSetLastErr("COM port not opened.");
        return false;
    }

    if (strlen(str) <= 0)
    {
        __UartSetLastErr("length of string is zero.");
        return false;
    }

    ::PurgeComm(UARTHandle[CurrComPort-1], PURGE_TXCLEAR);

    if (!::WriteFile(UARTHandle[CurrComPort-1], (LPCVOID) str, strlen(str), &writeCnt, NULL))
    {
        __UartSetLastErr("Send string fail - \"%s\"", str);
        return false;
    }

    return true;
}


bool UART_SetData(const unsigned char *data, unsigned long num)
{
    unsigned long writeCnt = 0;

    if (CurrComPort <= 0)
    {
        __UartSetLastErr("COM port not opened.");
        return false;
    }

    if (data == NULL || num <= 0)
    {
        __UartSetLastErr("length of data is zero.");
        return false;
    }

    ::PurgeComm(UARTHandle[CurrComPort-1], PURGE_TXCLEAR);

    if (!::WriteFile(UARTHandle[CurrComPort-1], (LPCVOID) data, num, &writeCnt, NULL))
    {
        __UartSetLastErr("Send data fail - length(%d)", num);
        return false;
    }

    return true;
}


const char *UART_GetLastErrMsg(void)
{
    return UARTErrBuf;
}
