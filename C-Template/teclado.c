#include "teclado.h"
#include "systick.h"
#include "gpio.h"

uint8_t teclado_ler(void){
	const uint8_t mascara_colunas[4] = {0x10, 0x20, 0x40, 0x80};
	
	const char mapa_teclas[4][4] = {
		{'D', 'C', 'B', 'A'},
		{'#', '9', '6', '3'},
		{'0', '8', '5', '2'},
		{'*', '7', '4', '1'}
	};
	
	for(int col = 0; col < 4; col++){
		// Coluna atual em Low (ativa) e demais em HIGH
		PortM_Output(~mascara_colunas[col] & 0xF0);
		
		SysTick_Wait1us(500);
		
		uint8_t linhas = PortL_Input() & 0x0F;
		
		for (int lin = 0; lin < 4; lin ++){
			if (!(linhas & (1 << lin)))
					return mapa_teclas[lin][col];
		}
	}	
	return 0x10;
}