// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "define.h"
#include "gpio.h"
#include "LCD.h"
#include "systick.h"
#include "teclado.h"

void PLL_Init(void);

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	lcd_config();
	lcd_exibir_linha(0, "Teste Display");
	lcd_exibir_linha(1, "Hello World!");
	while (1)
	{
		SysTick_Wait1ms(2000);
		lcd_exibir_linha(1, "Hello World!");
		SysTick_Wait1ms(2000);
		lcd_exibir_linha(1, "Ola Mundo!");
	}
}