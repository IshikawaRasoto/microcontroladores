#ifndef __GPIO_H__
#define __GPIO_H__

  
#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTN  (0x1000) //bit 12
#define GPIO_PORTF	(0b100000) // bit 5

void GPIO_Init(void);
void configura_Interrupts();

void configura_interrupt_PortJ();

void GPIOPortJ_Handler();
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t valor);
void PortF_Output(uint32_t valor);

#endif