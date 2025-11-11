#include "led.h"

#include "gpio.h"

void ligarLeds(){
	PortQ_Output(0x0F); 
	PortA_Output(0xF0); 
	PortP_Output(1u<<5);
}

void desligarLeds(){
	PortQ_Output(0x00); 
	PortA_Output(0x00); 
	PortP_Output(0x00);
}
