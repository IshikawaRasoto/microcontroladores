#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>

void configUART(unsigned int baudRate);
char lerUART(void);
int escreverUART(char dado);
void print(const char* str);
void println(const char* str);
void printNumero(uint16_t numero);

#endif
