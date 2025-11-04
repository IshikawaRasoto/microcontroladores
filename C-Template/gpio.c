#include "gpio.h"
#include "tm4c1294ncpdt.h"

// Inicializa todos os GPIOs
void GPIO_Init(void) {
    //Ativa o clock de todos GPIOs
    SYSCTL_RCGCGPIO_R = (GPIO_PORTA | GPIO_PORTB | GPIO_PORTD | GPIO_PORTE | GPIO_PORTF | GPIO_PORTH | GPIO_PORTJ | GPIO_PORTK | GPIO_PORTL | GPIO_PORTM | GPIO_PORTN | GPIO_PORTP | GPIO_PORTQ);

    // Verifica se a porta está pronta
    while ((SYSCTL_PRGPIO_R & (GPIO_PORTA | GPIO_PORTB | GPIO_PORTD | GPIO_PORTE | GPIO_PORTF | GPIO_PORTH | GPIO_PORTJ | GPIO_PORTK | GPIO_PORTL | GPIO_PORTM | GPIO_PORTN | GPIO_PORTP | GPIO_PORTQ)) != (GPIO_PORTA | GPIO_PORTB | GPIO_PORTD | GPIO_PORTE | GPIO_PORTF | GPIO_PORTH | GPIO_PORTJ | GPIO_PORTK | GPIO_PORTL | GPIO_PORTM | GPIO_PORTN | GPIO_PORTP | GPIO_PORTQ)) {};

    //Limpa o AMSEL 
    GPIO_PORTA_AHB_AMSEL_R = 0x00; 
    GPIO_PORTB_AHB_AMSEL_R &= ~0xF3; 
    GPIO_PORTD_AHB_AMSEL_R &= ~0xF0; 
    GPIO_PORTE_AHB_AMSEL_R = 0x00; 
    GPIO_PORTF_AHB_AMSEL_R = 0x00;
    GPIO_PORTH_AHB_AMSEL_R = 0x00; 
    GPIO_PORTJ_AHB_AMSEL_R = 0x00; 
    GPIO_PORTK_AMSEL_R = 0x00;
    GPIO_PORTL_AMSEL_R = 0x00; 
    GPIO_PORTM_AMSEL_R = 0x00; 
    GPIO_PORTN_AMSEL_R = 0x00; 
    GPIO_PORTP_AMSEL_R = 0x00; 
    GPIO_PORTQ_AMSEL_R = 0x00; 

    //Limpa o PCTL 
    GPIO_PORTA_AHB_PCTL_R = 0x00; 
    GPIO_PORTB_AHB_PCTL_R &= ~0xF3; 
    GPIO_PORTD_AHB_PCTL_R &= ~0xF0; 
    GPIO_PORTE_AHB_PCTL_R = 0x00; 
    GPIO_PORTF_AHB_PCTL_R = 0x00; 
    GPIO_PORTH_AHB_PCTL_R = 0x00; 
    GPIO_PORTJ_AHB_PCTL_R = 0x00; 
    GPIO_PORTK_PCTL_R = 0x00; 
    GPIO_PORTL_PCTL_R = 0x00; 
    GPIO_PORTM_PCTL_R = 0x00; 
    GPIO_PORTN_PCTL_R = 0x00; 
    GPIO_PORTP_PCTL_R = 0x00; 
    GPIO_PORTQ_PCTL_R = 0x00; 

    //DIR para 0 se for entrada, 1 se for saída
    GPIO_PORTA_AHB_DIR_R = 0xFF; // PA0-7 saída
    GPIO_PORTB_AHB_DIR_R = (GPIO_PORTB_AHB_DIR_R & ~0xF3) | 0xF3; // PB0-1 e PB4-7 saída 
    GPIO_PORTD_AHB_DIR_R = (GPIO_PORTD_AHB_DIR_R & ~0xF0) | 0xF0; // PD4-7 saída 
    GPIO_PORTE_AHB_DIR_R = 0x0F; // PE0-3 saída e PE4-7 entrada
    GPIO_PORTF_AHB_DIR_R = 0xFF; // PF0-7 saída
    GPIO_PORTH_AHB_DIR_R = 0xFF; // PH0-7 saída
    GPIO_PORTJ_AHB_DIR_R = 0x00; // PJ0-7 entrada
    GPIO_PORTK_DIR_R = 0xFF; // PK0-7 saída
    GPIO_PORTL_DIR_R = 0xF0; // PL0-3 entrada e PL4-7 saída
    GPIO_PORTM_DIR_R = 0xFF; // PM0-7 saída
    GPIO_PORTN_DIR_R = 0xFF; // PN0-7 saída
    GPIO_PORTP_DIR_R = 0xFF; // PP0-7 saída
    GPIO_PORTQ_DIR_R = 0xFF; // PQ0-7 saída

    //Limpa os bits AFSEL 
    GPIO_PORTA_AHB_AFSEL_R = 0x00; 
    GPIO_PORTB_AHB_AFSEL_R &= ~0xF3; 
    GPIO_PORTD_AHB_AFSEL_R &= ~0xF0; 
    GPIO_PORTE_AHB_AFSEL_R = 0x00; 
    GPIO_PORTF_AHB_AFSEL_R = 0x00;
    GPIO_PORTH_AHB_AFSEL_R = 0x00; 
    GPIO_PORTJ_AHB_AFSEL_R = 0x00; 
    GPIO_PORTK_AFSEL_R = 0x00; 
    GPIO_PORTL_AFSEL_R = 0x00; 
    GPIO_PORTM_AFSEL_R = 0x00; 
    GPIO_PORTN_AFSEL_R = 0x00; 
    GPIO_PORTP_AFSEL_R = 0x00; 
    GPIO_PORTQ_AFSEL_R = 0x00; 

    //Seta os bits de DEN para habilitar I/O digital.
    GPIO_PORTA_AHB_DEN_R = 0xFF;
    GPIO_PORTB_AHB_DEN_R |= 0xF3;
    GPIO_PORTD_AHB_DEN_R |= 0xF0; 
    GPIO_PORTE_AHB_DEN_R = 0xFF; 
    GPIO_PORTF_AHB_DEN_R = 0xFF;
    GPIO_PORTH_AHB_DEN_R = 0xFF; 
    GPIO_PORTJ_AHB_DEN_R = 0xFF; 
    GPIO_PORTK_DEN_R = 0xFF; 
    GPIO_PORTL_DEN_R = 0xFF; 
    GPIO_PORTM_DEN_R = 0xFF; 
    GPIO_PORTN_DEN_R = 0xFF; 
    GPIO_PORTP_DEN_R = 0xFF;
    GPIO_PORTQ_DEN_R = 0xFF; 

    //Habilita o resistor de pull-up interno
    GPIO_PORTE_AHB_PUR_R = 0xF0;
    GPIO_PORTJ_AHB_PUR_R = 0xFF; 
    GPIO_PORTL_PUR_R = 0x0F; 
}

#define NVIC_EN1_PORTJ_BIT     (1u << 19)

void interrupts_init(void){
	GPIO_PORTJ_AHB_IM_R = 0x0;
	GPIO_PORTJ_AHB_IS_R = 0x0; 	// Borda
	GPIO_PORTJ_AHB_IBE_R = 0x0; // Borda unica
	GPIO_PORTJ_AHB_IEV_R = 0x0; // Bordas de descida
	GPIO_PORTJ_AHB_ICR_R = 0x3; // Garante que a interrupcao sera atendida
	GPIO_PORTJ_AHB_IM_R = 0x3;
	NVIC_PRI12_R = (NVIC_PRI12_R & 0x00FFFFFF) | (5 << 29);
	NVIC_EN1_R |= 1u << 19;
}

// Envia valor para a porta A (PA0-7)
void PortA_Output(uint32_t value) {
    GPIO_PORTA_AHB_DATA_R = value;
}

// Envia valor para a porta B (PB0-1 e PB4-7)
void PortB_Output(uint32_t value) {
    GPIO_PORTB_AHB_DATA_R = (GPIO_PORTB_AHB_DATA_R & 0x0C) | (value & 0xF3);
}

// Envia valor para a porta D (PD4-7)
void PortD_Output(uint32_t value) {
    GPIO_PORTD_AHB_DATA_R = (GPIO_PORTD_AHB_DATA_R & 0x0F) | (value & 0xF0);
}

// Envia valor para a porta E (PE0-3)
void PortE_Output(uint32_t value) {
    GPIO_PORTE_AHB_DATA_R = (GPIO_PORTE_AHB_DATA_R & 0xF0) | (value & 0x0F);
}

// Lê os bits da porta E (PE4-7)
uint32_t PortE_Input(void) {
    return GPIO_PORTE_AHB_DATA_R & 0x0F;
}

// Envia valor para a porta F (PF0-7)
void PortF_Output(uint32_t value) {
    GPIO_PORTF_AHB_DATA_R = value;
}

// Envia valor para a porta H (PH0-7)
void PortH_Output(uint32_t value) {
    GPIO_PORTH_AHB_DATA_R = value;
}

// Lê os bits da porta J (PJ0-7)
uint32_t PortJ_Input(void) {
    return GPIO_PORTJ_AHB_DATA_R;
}

// Envia valor para a porta K (PK0-7)
void PortK_Output(uint32_t value) {
    GPIO_PORTK_DATA_R = value;
}

// Envia valor para a porta L (PL4-7)
void PortL_Output(uint32_t value) {
    GPIO_PORTL_DATA_R = (GPIO_PORTL_DATA_R & 0x0F) | (value & 0xF0);
}

// Lê os bits da porta L (PL0-3)
uint32_t PortL_Input(void) {
    return GPIO_PORTL_DATA_R & 0x0F;
}

// Envia valor para a porta M (PM0-7)
void PortM_Output(uint32_t value) {
    GPIO_PORTM_DATA_R = value;
}

// Envia valor para a porta N (PN0-7)
void PortN_Output(uint32_t value) {
    GPIO_PORTN_DATA_R = value;
}

// Envia valor para a porta P (PP0-7)
void PortP_Output(uint32_t value) {
    GPIO_PORTP_DATA_R = value;
}

// Envia valor para a porta Q (PQ0-7)
void PortQ_Output(uint32_t value) {
    GPIO_PORTQ_DATA_R = value;
}