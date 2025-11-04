// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "define.h"
#include "gpio.h"
#include "LCD.h"
#include "systick.h"
#include "teclado.h"
#include "motor.h"
#include "led.h"
#include "tm4c1294ncpdt.h"

#define SENTIDO_HORARIO 1
#define SENTIDO_ANTIHORARIO -1

#define VELOCIDADE_MEIOPASSO 2
#define VELOCIDADE_PASSOCOMPLETO 1

void PLL_Init(void);

typedef enum{
	ABERTO,
	ABERTO_PARA_FECHADO,
	FECHADO,
	FECHADO_PARA_ABERTO,
	FECHADO_PARA_TRAVADO,
	TRAVADO
} Estado_Cofre;

Estado_Cofre estado = ABERTO;

char senha[5] = {'-','-','-','-', '\0'};
uint8_t senha_index = 0;
char input[5] = {'-','-','-','-', '\0'};
uint8_t input_index = 0;

uint8_t conta_erros = 0;

uint16_t count_display = 0;

volatile uint8_t senhaMestraAtivada = 0;
char senha_mestra[5] = {'1', '2', '3', '4', '\0'};


void GPIOPortJ_Handler(){
	GPIO_PORTJ_AHB_ICR_R = 0x1;
	senhaMestraAtivada = 1;
}

void registraSenha(){
	uint8_t tecla = teclado_ler();
	if(tecla == 0x10) return;
	if(senha_index <= 3){
		senha[senha_index++] = (char)tecla;
		SysTick_Wait1ms(250);
	}
	else if(senha_index == 4 && tecla == '#'){
		senha_index = 0;
		count_display = 0;
		estado = ABERTO_PARA_FECHADO;
	}
}

uint8_t verifica_senha(){
	lcd_exibir_linha(0, "Verificando");
	lcd_exibir_linha(1, "...");
	SysTick_Wait1ms(2000);
	for(int i = 0; i < 4; i++){
		if(senha[i] != input[i]){
			return 0;
		}
	}
	return 1;
}

void leitura_senha(){
	uint8_t tecla = teclado_ler();
	if(tecla == 0x10) return;
	if(input_index<= 3){
		input[input_index++] = (char)tecla;
		SysTick_Wait1ms(250);
	}
	if(input_index == 4){
		input_index = 0;
		if(verifica_senha()){
			lcd_exibir_linha(0, "Senha Correta");
			lcd_exibir_linha(1, ":D");
			SysTick_Wait1ms(2000);
			for(int ind = 0; ind < 4; ind ++){
				input[ind] = '-';
			}
			conta_erros = 0;
			count_display = 0;
			estado = FECHADO_PARA_ABERTO;
		}else{
			lcd_exibir_linha(0, "Senha errada");
			lcd_exibir_linha(1, "!!!");
			SysTick_Wait1ms(2000);
			for(int ind = 0; ind < 4; ind ++){
				input[ind] = '-';
			}
			conta_erros++;
			if(conta_erros == 3){
				conta_erros = 0;
				count_display = 0;
				estado = FECHADO_PARA_TRAVADO;
			}
		}
	}
}

void aberto(){
	registraSenha();
	SysTick_Wait1ms(100);
	if(count_display < 20){
		lcd_exibir_linha(0, "Cofre aberto,");
	}else if(count_display < 40){
		lcd_exibir_linha(0, "digite nova");
	}else if(count_display < 60){
		lcd_exibir_linha(0, "senha");
	}else{
		count_display = 0;
	}
	count_display++;
	
	lcd_exibir_linha(1, senha);
}

void aberto_para_fechado(){
	lcd_exibir_linha(0, "Cofre fechando");
	lcd_exibir_linha(1, "");
	SysTick_Wait1ms(1000);
	ativarMotor(720, VELOCIDADE_MEIOPASSO, SENTIDO_ANTIHORARIO);
	estado = FECHADO;
}

void fechado(){
	leitura_senha();
	SysTick_Wait1ms(100);
	if(count_display < 20){
		lcd_exibir_linha(0, "Cofre fechado,");
	}else if(count_display < 40){
		lcd_exibir_linha(0, "digite a");
	}else if(count_display < 60){
		lcd_exibir_linha(0, "senha");
	}else{
		count_display = 0;
	}
	count_display++;
	
	lcd_exibir_linha(1, input);
	if(input_index == 4)
		SysTick_Wait1ms(500);
}

void fechado_para_aberto(){
	lcd_exibir_linha(0, "Cofre abrindo");
	lcd_exibir_linha(1, "");
	SysTick_Wait1ms(1000);
	ativarMotor(720, VELOCIDADE_PASSOCOMPLETO, SENTIDO_HORARIO);
	estado = ABERTO;
	for(int i = 0; i < 4; i++){
		senha[i] = '-';
	}
}

int verifica_senha_mestra(){
	lcd_exibir_linha(0, "Verificando");
	lcd_exibir_linha(1, "...");
	SysTick_Wait1ms(2000);
	for(int i = 0; i < 4; i++){
		if(senha_mestra[i] != input[i]){
			for(int ind = 0; ind < 4; ind ++){
				input[ind] = '-';
			}
			return 0;
		}
	}
	for(int ind = 0; ind < 4; ind ++){
		input[ind] = '-';
	}
	lcd_exibir_linha(0, "Senha Correta");
	lcd_exibir_linha(1, ":D");
	SysTick_Wait1ms(2000);
	count_display = 0;
	return 1;
}

void leitura_senha_mestra(){
	uint8_t tecla = teclado_ler();
	if(tecla == 0x10) return;
	if(input_index<= 3){
		input[input_index++] = (char)tecla;
		SysTick_Wait1ms(250);
	}
	if(input_index == 4){
		input_index = 0;
		if(verifica_senha_mestra()){
			estado = FECHADO_PARA_ABERTO;
			for(int ind = 0; ind < 4; ind ++){
				input[ind] = '-';
			}
			desligarLeds();
			senhaMestraAtivada = 0;
		}
	}
}	

void fechado_para_travado(){
	lcd_exibir_linha(0, "Cofre travado");
	lcd_exibir_linha(1, "");
	SysTick_Wait1ms(100);
	estado = TRAVADO;
}


void travado(){
	
	SysTick_Wait1ms(100);
	if(count_display < 20){
		ligarLeds();
		count_display++;
	}else if(count_display < 40){
		desligarLeds();
		count_display++;
	}else{
		count_display = 0;
	}
	
	if(senhaMestraAtivada){
		lcd_exibir_linha(0, "Cofre travado");
		lcd_exibir_linha(1, "Digite senha");
		leitura_senha_mestra();
	}else{
		lcd_exibir_linha(0, "Cofre travado");
		lcd_exibir_linha(1, "");
	}
		
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	lcd_config();
	interrupts_init();
	lcd_exibir_linha(0, "Cofre aberto, digite nova senha");
	PortB_Output(0x0);
	while (1)
	{
		switch(estado){
			case ABERTO:
				aberto();
				break;
			case ABERTO_PARA_FECHADO:
				aberto_para_fechado();
				break;
			case FECHADO:
				fechado();
				break;
			case FECHADO_PARA_ABERTO:
				fechado_para_aberto();
				break;
			case FECHADO_PARA_TRAVADO:
				fechado_para_travado();
				break;
			case TRAVADO:
				travado();
				break;
			default:
				break;
		}
	}
}