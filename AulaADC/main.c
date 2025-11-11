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
#include "adc.h"

void PLL_Init(void);

uint32_t leitura;

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	configUART(57600);
	configADC();
	println("Iniciando sistema");
	while (1)
	{
		leitura = leituraADC();
		printNumero(leitura);
		SysTick_Wait1ms(100);
	}
}
