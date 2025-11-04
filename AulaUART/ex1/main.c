// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "define.h"
#include "gpio.h"
#include "systick.h"
#include "tm4c1294ncpdt.h"
#include "uart.h"

void PLL_Init(void);

void controleLEDPlaca(char comando){
    switch(comando){
        case '0':
						print("Desligando LEDs\n");
            PortN_Output(0x0);
            PortF_Output(0x0);
        break;
        case '1':
						print("Ligando led 1\n");
            PortN_Output(0x0);
            PortF_Output(0x1);
        break;
        case '2':
						print("Ligando led 2\n");
            PortN_Output(0x0);
            PortF_Output(0x10);
        break;
        case '3':
						print("Ligando led 3\n");
            PortN_Output(0x1);
            PortF_Output(0x0);
        break;
        case '4':
						print("Ligando led 4\n");
            PortN_Output(0x2);
            PortF_Output(0x0);
        break;
        default:
        break;
    }
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	configUART(57600);
	while (1)
	{
		char comando = lerUART();
		if (comando != 0x0){
		    controleLEDPlaca(comando);
		}
	}
}
