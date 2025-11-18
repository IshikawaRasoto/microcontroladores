#include "uart.h"

#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include "define.h"
#include "systick.h"

#define WLEN_8 0x60
#define FIFO_EN 0x10
#define BRD_PART (CLOCK_SISTEMA/16)
#define STP2_EN 0x8
#define PARITY_EN 0x2
#define EVEN_EN 0x4

void configUART(unsigned int baudRate){
    SYSCTL_RCGCUART_R |= 0x1;               // Ativa clock na UART0
    while ((SYSCTL_PRUART_R & 0x1) != 0x1); // Aguarda UART0 estar pronta
    UART0_CTL_R &= ~0x1;                    // Garantir que a UART esta desabilitada
    UART0_CTL_R &= ~0x20;                   // ClockDiv = 16

    // BaudRate calculo
    float brd = BRD_PART / (float)baudRate;
    uint32_t ibrd = (uint32_t)brd;
    uint32_t fbrd = (uint32_t)((brd - (float)ibrd) * 64.0f + 0.5f); // arredonda
    UART0_IBRD_R = ibrd;
    UART0_FBRD_R = fbrd;

    UART0_LCRH_R = WLEN_8 | FIFO_EN | STP2_EN | PARITY_EN; // Word: 8bits - FIFO - paridade impar e 2 stop bits
    UART0_CC_R = 0x0;                // Clock do sistema

    UART0_CTL_R |= 0x100;   // Enable TXE
    UART0_CTL_R |= 0x200;   // Enable RXE
    UART0_CTL_R |= 0x1;     // Enable UART EN

    // Enable clock in port A
    SYSCTL_RCGCGPIO_R |= 0x1;
    while((SYSCTL_PRGPIO_R & 0x1) != 0x1);

    GPIO_PORTA_AHB_AMSEL_R &= ~0x3; // Desabilita Funcoes analogicas
    GPIO_PORTA_AHB_PCTL_R |= 0x11;  // Funcao alternativa A0 e A1 como UART
    GPIO_PORTA_AHB_AFSEL_R |= 0x3;  // Habilita bits de funcao alternativa em A0 e A1
    GPIO_PORTA_AHB_DEN_R |= 0x3;    // Habilita pinos A0 e A1 como digitais

}

char lerUART(void){
    if(UART0_FR_R & 0x10) return 0;

    return (char)(UART0_DR_R & 0xFF);
}

int escreverUART(char dado){
    if(UART0_FR_R & 0x20) return 0;
    UART0_DR_R = (uint8_t) dado;
    return 1;
}

void print(const char* str){
    while(*str){
        while(!escreverUART(*str));
        str++;
    }
}

void println(const char* str){
		while(*str){
        while(!escreverUART(*str));
        str++;
    }
		while(!escreverUART('\n'));
		//while(!escreverUART('\r'));
		SysTick_Wait1ms(10);
}

void printNumero(uint16_t numero){
		char numeros[5];
		for(int i = 0; i < 5; i++){
				numeros[i] = '0';
		}
		int index = 0;
		while(numero){
				int digito = numero%10;
				numeros[index++] = digito + '0'; //Const ascii to transform a number into its printable value
				numero /= 10;
		}
		char buffer[6];
		int i = 5;
		int j = 0;
		while(i>0){
				buffer[j++] = numeros[--i];
		}
		buffer[j] = '\0';
		print(buffer);
}
