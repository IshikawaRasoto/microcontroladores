// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron


#include <stdint.h>
#include "gpio.h"
#include "tm4c1294ncpdt.h"

volatile extern uint8_t flag_pedestre;

// -------------------------------------------------------------------------------
// Função GPIO_Init
// Inicializa os ports J e N
// Parâmetro de entrada: Não tem
// Parâmetro de saída: Não tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R = (GPIO_PORTJ | GPIO_PORTN | GPIO_PORTF);
	//1b.   após isso verificar no PRGPIO se a porta está pronta para uso.
  while((SYSCTL_PRGPIO_R & (GPIO_PORTJ | GPIO_PORTN | GPIO_PORTF) ) != (GPIO_PORTJ | GPIO_PORTN | GPIO_PORTF) ){};
	
	// 2. Limpar o AMSEL para desabilitar a analógica
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	GPIO_PORTN_AMSEL_R = 0x00;
	GPIO_PORTF_AHB_AMSEL_R = 0x00;
		
	// 3. Limpar PCTL para selecionar o GPIO
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	GPIO_PORTN_PCTL_R = 0x00;
	GPIO_PORTF_AHB_PCTL_R = 0x00;

	// 4. DIR para 0 se for entrada, 1 se for saída
	GPIO_PORTJ_AHB_DIR_R = 0x00;
	GPIO_PORTN_DIR_R = 0x03; //BIT0 | BIT1
	GPIO_PORTF_AHB_DIR_R = 0b10001; // bit4 | bit0
		
	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa	
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	GPIO_PORTN_AFSEL_R = 0x00; 
	GPIO_PORTF_AHB_AFSEL_R = 0x00;
		
	// 6. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTJ_AHB_DEN_R = 0x03;   //Bit0 e bit1
	GPIO_PORTN_DEN_R = 0x03; 		   //Bit0 e bit1
	GPIO_PORTF_AHB_DEN_R = 0b10001;
	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
	GPIO_PORTJ_AHB_PUR_R = 0x03;   //Bit0 e bit1	

}	

void configura_Interrupts(){
	configura_interrupt_PortJ();
	
	NVIC_EN1_R = 0x1 << 19;
	NVIC_PRI12_R = 5 << 29;
}

void configura_interrupt_PortJ(){
	GPIO_PORTJ_AHB_IM_R = 0x0; // Desabilita GPIOIM
	GPIO_PORTJ_AHB_IS_R = 0x0; // Configura interrupt como borda
	GPIO_PORTJ_AHB_IBE_R = 0x0; // Configura interrupt como borda unica
	GPIO_PORTJ_AHB_IEV_R = 0x0; // Configura borda de descida para J0 (SW1)
	GPIO_PORTJ_AHB_ICR_R = 0x1; // Garante que a interrupcao sera atendida limpando o GPIORIS e GPIOMIS e Realiza o ACK no registrador
	GPIO_PORTJ_AHB_IM_R = 0x1; // Habilita GPIOIM
	
	return;
}

void interrupt_J0(){
	
}

void interrupt_J1(){
	
}

void GPIOPortJ_Handler(){
	uint32_t handler = GPIO_PORTJ_AHB_RIS_R & 0b1;
	if(handler != 0b1)
		return;
	GPIO_PORTJ_AHB_ICR_R = 0x1;
	
	flag_pedestre = 1;
	
	return;
}

// -------------------------------------------------------------------------------
// Função PortJ_Input
// Lê os valores de entrada do port J
// Parâmetro de entrada: Não tem
// Parâmetro de saída: o valor da leitura do port
uint32_t PortJ_Input(void)
{
	return GPIO_PORTJ_AHB_DATA_R;
}

// -------------------------------------------------------------------------------
// Função PortN_Output
// Escreve os valores no port N
// Parâmetro de entrada: Valor a ser escrito
// Parâmetro de saída: não tem
void PortN_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTN_DATA_R & 0xFC;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTN_DATA_R = temp; 
}

void PortF_Output(uint32_t valor)
{
		uint32_t temp;
	
		temp = GPIO_PORTF_AHB_DATA_R & 0b01110;
		temp = temp | valor;
		GPIO_PORTF_AHB_DATA_R = temp;
}




