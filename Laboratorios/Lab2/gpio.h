#ifndef __GPIO_H__
#define __GPIO_H__

#include <stdint.h>

typedef enum {
    GPIO_PORTA = 0x0001,
    GPIO_PORTB = 0x0002,
    GPIO_PORTC = 0x0004,
    GPIO_PORTD = 0x0008,
    GPIO_PORTE = 0x0010,
    GPIO_PORTF = 0x0020,
    GPIO_PORTG = 0x0040,
    GPIO_PORTH = 0x0080,
    GPIO_PORTJ = 0x0100,
    GPIO_PORTK = 0x0200,
    GPIO_PORTL = 0x0400,
    GPIO_PORTM = 0x0800,
    GPIO_PORTN = 0x1000,
    GPIO_PORTP = 0x2000,
    GPIO_PORTQ = 0x4000
} GPIO_Port;

void GPIO_Init(void);

void PortA_Output(uint32_t value);
void PortB_Output(uint32_t value);
void PortD_Output(uint32_t value);
void PortE_Output(uint32_t value);
void PortF_Output(uint32_t value);
void PortH_Output(uint32_t value);
void PortK_Output(uint32_t value);
void PortL_Output(uint32_t value);
void PortM_Output(uint32_t value);
void PortN_Output(uint32_t value);
void PortP_Output(uint32_t value);
void PortQ_Output(uint32_t value);

uint32_t PortE_Input(void);
uint32_t PortJ_Input(void);
uint32_t PortL_Input(void);


#endif