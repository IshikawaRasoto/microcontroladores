#ifndef __LCD_H__ 
#define __LCD_H__

#include <stdint.h>
#include <string.h>
#include <stdio.h>

typedef enum{
	LCDCMD_DISPLAY_ON_NO_CURSOR       = 0x0C,
	LCDCMD_DISPLAY_OFF                = 0x0A,
	LCDCMD_CLEAR_HOME                 = 0x01,
	LCDCMD_DISPLAY_CURSOR_ON          = 0x0E,
	LCDCMD_CURSOR_OFF                 = 0x0C,
	LCDCMD_CURSOR_BLINK               = 0x0D,
	LCDCMD_CURSOR_MOVE_RIGHT          = 0x14,
	LCDCMD_CURSOR_MOVE_LEFT           = 0x10,
	LCDCMD_CURSOR_HOME                = 0x02,
	LCDCMD_CURSOR_ALTERNATING         = 0x0F,
	LCDCMD_DIR_CURSOR_LEFT            = 0x04,
	LCDCMD_DIR_CURSOR_RIGHT           = 0x06,
	LCDCMD_DIR_MSG_LEFT               = 0x07,
	LCDCMD_DIR_MSG_RIGHT              = 0x05,
	LCDCMD_DIR_CHAR_LEFT              = 0x18,
	LCDCMD_DIR_CHAR_RIGHT             = 0x1C,
	LCDCMD_LINE1_POSITION0            = 0x80,
	LCDCMD_LINE2_POSITION0            = 0xC0,
	LCDCMD_ENABLE_WRITE_CMD           = 0x04,
	LCDCMD_ENABLE_WRITE_DATA          = 0x05,
	LCDCMD_DISABLE_WRITE              = 0x00,
	LCDCMD_2LINES_8BITS               = 0x38
} ComandosLCD;

void lcd_config(void);

void lcd_enviar_cmd(ComandosLCD cmd);
void lcd_escrever_data(uint8_t data);
void lcd_escrever_string(const char *str);
void lcd_exibir_linha(uint8_t linha, const char *texto);

#endif