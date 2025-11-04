#ifndef __UART_H__
#define __UART_H__

void configUART(unsigned int baudRate);
char lerUART(void);
int escreverUART(char dado);
void print(const char* str);

#endif
