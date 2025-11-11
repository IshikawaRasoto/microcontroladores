#include "adc.h"
#include "tm4c1294ncpdt.h"
#include "gpio.h"

void configADC(void){
    SYSCTL_RCGCGPIO_R |= GPIO_PORTE;
    while ((SYSCTL_PRGPIO_R & GPIO_PORTE) != GPIO_PORTE);

    GPIO_PORTE_AHB_AMSEL_R |= 0x10; // Habilita a porta E4 como ADC
    GPIO_PORTE_AHB_DIR_R &= ~0x10; // Configura a porta E4 como Input
    GPIO_PORTE_AHB_AFSEL_R |= 0x10; // Habilita funcoes alternativas em E4
    GPIO_PORTE_AHB_DEN_R &= ~0x10; // Desativa funcoes Digitais em E4

    SYSCTL_RCGCADC_R = 0x1; // Habilita ADC0
    while((SYSCTL_PRADC_R & 0x1) != 0x1);

    ADC0_PC_R = 0x7; // Full conversion rate
                                // Set Sample Sequencers priorities. 0 - Highest priority
    ADC0_SSPRI_R = 0x0123;  // SS3 - 0 | SS2 - 1| SS1 - 2| SS0 - 3
    ADC0_ACTSS_R &= ~0x8; // Disable ASEN3
    ADC0_EMUX_R &= ~0xF000; // Software Pooling
    ADC0_SSMUX3_R |= 0x9; // AIN9 - input config
    ADC0_SSCTL3_R |= 0x6; // Interrupt enabled (necessary) & End of sequence enabled
    ADC0_ACTSS_R |= 0x8; // Enable ASEN3

    return;
}


uint32_t leituraADC(void){
    ADC0_PSSI_R |= 0x8; // Inicia gatilho de SW
    while((ADC0_RIS_R & 0x8) != 0x8); // Wait for conversion complete

    uint32_t conversao = ADC0_SSFIFO3_R; // Le o valor da conversao
    ADC0_ISC_R |= 0x8; // Ack

    return conversao;
}
