#include "timer.h"
#include "tm4c1294ncpdt.h"
#include <stdint.h>

void configTimer(){
    SYSCTL_RCGCTIMER_R |= 0x4; // Ativa Timer 2
    while(!(SYSCTL_PRTIMER_R & 0x4)); // Espera Timer 2

    TIMER2_CTL_R &= ~0x1; // Desabilita Timer 2
    TIMER2_CFG_R &= ~0x7; // Timer 2 no modo 32 bits

    TIMER2_TAMR_R |= 0x2; // Modo continuo
    TIMER2_TAILR_R = 1999999; // 0.25s Para o motor parado ficar piscando os dois leds.
    TIMER2_TAPMR_R = 0x0; // Sem Pre-scale

    TIMER2_ICR_R |= 0x1; // Setar interrupt
    TIMER2_IMR_R |= 0x1;

    NVIC_PRI5_R |= 4 << 29;
    NVIC_EN0_R |= 1 << 23;

    TIMER2_CTL_R |= 0x1;
}
