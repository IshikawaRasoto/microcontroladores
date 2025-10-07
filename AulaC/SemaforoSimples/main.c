// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "define.h"

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);
void PortF_Output(uint32_t valor);
void Pisca_leds(void);

volatile SinaleiroEstados estadoAtual;

void verm_verm(){
	PortN_Output(PORTN_VERMELHO);
	PortF_Output(PORTF_VERMELHO);
	SysTick_Wait1ms(TEMPO_VERMELHO_VERMELHO);
	estadoAtual = VERDE_VERMELHO;
	return;
}

void verd_verm(){
	PortN_Output(PORTN_VERDE);
	PortF_Output(PORTF_VERMELHO);
	SysTick_Wait1ms(TEMPO_VERDE_VERMELHO);
	estadoAtual = AMARELO_VERMELHO;
	return;
}

void amar_verm(){
	PortN_Output(PORTN_AMARELO);
	PortF_Output(PORTF_VERMELHO);
	SysTick_Wait1ms(TEMPO_AMARELO_VERMELHO);
	estadoAtual=VERMELHO_VERMELHO1;
	return;
}

void verm_verm1(){
	PortN_Output(PORTN_VERMELHO);
	PortF_Output(PORTF_VERMELHO);
	SysTick_Wait1ms(TEMPO_VERMELHO_VERMELHO);
	estadoAtual = VERMELHO_VERDE;
	return;
}

void verm_verd(){
	PortN_Output(PORTN_VERMELHO);
	PortF_Output(PORTF_VERDE);
	SysTick_Wait1ms(TEMPO_VERDE_VERMELHO);
	estadoAtual = VERMELHO_AMARELO;
	return;
}

void verm_amar(){
	PortN_Output(PORTN_VERMELHO);
	PortF_Output(PORTF_AMARELO);
	SysTick_Wait1ms(TEMPO_AMARELO_VERMELHO);
	estadoAtual = VERMELHO_VERMELHO;
	return;
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	estadoAtual = VERMELHO_VERMELHO;
	while (1)
	{
		switch(estadoAtual){
			case VERMELHO_VERMELHO:
				verm_verm();
				break;
			case VERDE_VERMELHO:
				verd_verm();
				break;
			case AMARELO_VERMELHO:
				amar_verm();
				break;
			case VERMELHO_VERMELHO1:
				verm_verm1();
				break;
			case VERMELHO_VERDE:
				verm_verd();
				break;
			case VERMELHO_AMARELO:
				verm_amar();
				break;
			default:
				break;
		}
		
	}
}

void Pisca_leds(void)
{
	PortN_Output(0x2);
	SysTick_Wait1ms(250);
	PortN_Output(0x1);
	SysTick_Wait1ms(250);
}
