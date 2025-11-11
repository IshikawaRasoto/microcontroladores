#include "motor.h"
#include "gpio.h"
#include "systick.h"

#include <stdint.h>

const int sequenciaPassoCompletoBit[4] = {
	~0x08,
	~0x04,
	~0x02,
	~0x01
};

static const int sequenciaMeioPassoBit[8] = {
	~0x08,
	~0x0C,
	~0x04,
	~0x06,
	~0x02,
	~0x03,
	~0x01,
	~0x09
};



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
			const int bobina = velocidade == 1 ? sequenciaPassoCompletoBit[indexEstado] : sequenciaMeioPassoBit[indexEstado];
		
			uint8_t saida = bobina;
			PortH_Output(saida);
			SysTick_Wait1ms(2);
		}		
	}  
}