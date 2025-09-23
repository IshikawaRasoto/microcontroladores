; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Defini��es de Valores

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
		IMPORT 	Configura_Interrupts

		import Escreve_Display_Decimo
		import Escreve_Display_Unitario
		import Escreve_LEDs
		import Acende_LED_N0
		import Apaga_LED_N0
		import Acende_LED_N1
		import Apaga_LED_N1


; -------------------------------------------------------------------------------
; Fun��o main()

; Definicao de registradores e suas funcionalidades estaticas

; R8	- Valor do display unitario
; R9	- Valor do display dezenas
; R10	- Valor da temperatura atual
; R11	- Valor da temperatura alvo
; R12	- Contador das inetracoes para atraso de 1s na atualizacao da temperatura

Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL Configura_Interrupts		 ;Chama a subrotina que configura as interrupcoes

	mov r10, #15
	mov r11, #25
	mov r12, #166
	

MainLoop
; ****************************************
; Escrever c�digo que l� o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************

	mov r12, #166

Loop_1s
	bl Escreve_Display_Decimo
	bl Escreve_Display_Unitario
	bl Escreve_LEDs
	
	sub r12, r12, #1
	cmp r12, #0
	bne Loop_1s ; Verifica se ja passou 1s
	
	; Atualiza temperatura
	cmp r10, r11
	beq Temp_igual
	bgt Temp_maior
	blt Temp_menor


	B MainLoop

Temp_maior
	sub r10, r10, #1
	bl Acende_LED_N1
	bl Apaga_LED_N0
	B MainLoop

Temp_igual
	bl Acende_LED_N0
	bl Acende_LED_N1
	B MainLoop
	

Temp_menor
	add r10, r10, #1
	bl Acende_LED_N0
	bl Apaga_LED_N1
	B MainLoop
	
	ALIGN
	END