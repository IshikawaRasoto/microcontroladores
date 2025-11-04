#include "LCD.h"
#include "gpio.h"
#include "systick.h"

void lcd_config(void){
	lcd_enviar_cmd(LCDCMD_2LINES_8BITS);
	lcd_enviar_cmd(LCDCMD_DIR_CURSOR_RIGHT);
	lcd_enviar_cmd(LCDCMD_DISPLAY_CURSOR_ON);
	lcd_enviar_cmd(LCDCMD_CLEAR_HOME);
	SysTick_Wait1us(1600);
	lcd_enviar_cmd(LCDCMD_CURSOR_OFF);
}

void lcd_enviar_cmd(ComandosLCD cmd){
	PortK_Output(cmd);
	PortM_Output(LCDCMD_ENABLE_WRITE_CMD);
	SysTick_Wait1us(500);
	PortM_Output(LCDCMD_DISABLE_WRITE);
	SysTick_Wait1us(500);
}

void lcd_escrever_data(uint8_t data){
	PortK_Output(data);
	PortM_Output(LCDCMD_ENABLE_WRITE_DATA);
	SysTick_Wait1us(500);
	PortM_Output(LCDCMD_DISABLE_WRITE);
	SysTick_Wait1us(500);
}
void lcd_escrever_string(const char *str){
	while(*str){
		lcd_escrever_data(*str++);
	}
}
void lcd_exibir_linha(uint8_t linha, const char *texto){
	static char ultima_linha0[17] = {'\0'};
	static char ultima_linha1[17] = {'\0'};
	
	if(linha == 0){
		if(strcmp(ultima_linha0, texto) == 0) return;
		strncpy(ultima_linha0, texto, 16);
	}else{
		if(strcmp(ultima_linha1, texto) == 0) return;
		strncpy(ultima_linha1, texto, 16);
	}
	
	lcd_enviar_cmd(LCDCMD_DISPLAY_CURSOR_ON);
	lcd_enviar_cmd(LCDCMD_CLEAR_HOME);
	
	if (ultima_linha0[0] != '\0'){
		lcd_enviar_cmd(LCDCMD_LINE1_POSITION0);
		lcd_escrever_string(ultima_linha0);
	}
	if (ultima_linha1[0] != '\0'){
		lcd_enviar_cmd(LCDCMD_LINE2_POSITION0);
		lcd_escrever_string(ultima_linha1);
	}
	
	lcd_enviar_cmd(LCDCMD_CURSOR_OFF);
}