#include "motor.h"
#include "gpio.h"
#include "systick.h"

#include <stdint.h>

static const int sequenciaPassoCompleto[4][4] = {
    {1, 0, 0, 0},
    {0, 1, 0, 0},
    {0, 0, 1, 0},
    {0, 0, 0, 1}
};

static const int sequenciaMeioPasso[8][4] = {
    {1, 0, 0, 0},
    {1, 1, 0, 0},
    {0, 1, 0, 0},
    {0, 1, 1, 0},
    {0, 0, 1, 0},
    {0, 0, 1, 1},
    {0, 0, 0, 1},
    {1, 0, 0, 1}
};


// Velocidade: 1 ou 2
// Sentido: 1 ou -1
void ativarMotor(int graus, int velocidade, int sentido){
	const int passosPorVolta = 512;
	int passosDesejados = passosPorVolta * graus / 360;
	int n_sequencias = velocidade == 1 ? 4 : 8;
	
	for (int i = 0; i < passosDesejados; i++){
		for (int passo = 0; passo < n_sequencias; passo++){ 
			int indexEstado = sentido == 1 ? (n_sequencias - passo) % n_sequencias : passo;
			const int* bobina = velocidade == 1 ? sequenciaPassoCompleto[indexEstado] : sequenciaMeioPasso[indexEstado];
		
			uint8_t saida = (bobina[0] << 0) | (bobina[1] << 1) | (bobina[2] << 2) | (bobina[3] << 3);
			PortH_Output(saida);
			SysTick_Wait1ms(5);
		}		
	}  
}