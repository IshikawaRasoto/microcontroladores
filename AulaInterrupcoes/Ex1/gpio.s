; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000	
	
; Registradores de Interrupcao
GPIO_PORTJ_AHB_IM_R     	EQU		0x40060410
GPIO_PORTJ_AHB_IS_R			EQU		0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU		0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU		0x4006040C
GPIO_PORTJ_AHB_ICR_R		EQU		0x4006041C
NVIC_EN1_R					EQU		0xE000E104
NVIC_PRI12_R				EQU		0xE000E430
GPIO_PORTJ_AHB_RIS_R    	EQU 	0x40060414

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT Configura_Interrupts	
		EXPORT Desabilita_GPIOIM				
		export Configura_GPIOIS
		export Configura_GPIOIBE
		export Configura_GPIOIEV
		export Configura_GPIOICR
		export Habilita_GPIOIM
		export Ativa_NVIC
			
		export GPIOPortJ_Handler
;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dos GPIO
; Inicializar as portas J e N
; ****************************************
	; Inicializa Clock dos GPIOs
	ldr r0, =SYSCTL_RCGCGPIO_R
	mov r1, #GPIO_PORTJ
	orr r1, #GPIO_PORTN
	str r1, [r0]
	
	;Espera GPIOs
	ldr r0, =SYSCTL_PRGPIO_R
GPIO_Wait
	ldr r1, [r0]
	mov r2, #GPIO_PORTJ
	orr r2, #GPIO_PORTN
	tst r1, r2
	beq GPIO_Wait
	
	; Limpa AMSEL para desabilitar Analogica
	mov r1, #0x0
	ldr r0, =GPIO_PORTJ_AHB_AMSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_AMSEL_R
	str r1, [r0]
	
	; Limpar PCTL para selecionar o GPIO
	mov r1, #0x00
	ldr r0, =GPIO_PORTJ_AHB_PCTL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_PCTL_R
	str r1, [r0]
	
	; Direcao dos GPIOs
	ldr r0, =GPIO_PORTJ_AHB_DIR_R
	mov r1, #0x00
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_DIR_R
	mov r1, #2_10
	str r1, [r0]
	
	; Limpa bits AFSEL para nao ter funcao alternativa
	mov r1, #0x0
	ldr r0, =GPIO_PORTJ_AHB_AFSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_AFSEL_R
	str r1, [r0]
	
	; Setar os bits de DEN para habilitar I/O digital
	ldr r0, =GPIO_PORTJ_AHB_DEN_R
	mov r1, #2_11
	str r1, [r0]
	
	ldr r0, =GPIO_PORTN_AHB_DEN_R
	mov r1, #2_10
	str r1, [r0]
	
	; Para habilitar resistor de pull-up interno, setar PUR para 1
	ldr r0, = GPIO_PORTJ_AHB_PUR_R
	mov r1, #2_11
	str r1, [r0]
	
	BX LR


; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortN_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	
	BX LR
; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	
	BX LR
	
Configura_Interrupts
	push{r0, r1, r2, lr}
	bl Desabilita_GPIOIM
	bl Configura_GPIOIS
	bl Configura_GPIOIBE
	bl Configura_GPIOIEV
	bl Configura_GPIOICR
	bl Habilita_GPIOIM
	bl Ativa_NVIC
	pop {r0, r1, r2, lr}
	bx lr


Desabilita_GPIOIM
	ldr r0, =GPIO_PORTJ_AHB_IM_R
	mov r1, #0x0
	str r1, [r0]
	BX LR
	
Configura_GPIOIS
	; Configura interrupcao como borda
	ldr r0, =GPIO_PORTJ_AHB_IS_R
	mov r1, #0x0
	str r1, [r0]
	bx lr
	
Configura_GPIOIBE
	; Configuracao de borda unica
	ldr r0, =GPIO_PORTJ_AHB_IBE_R
	mov r1, #0x0
	str r1, [r0]
	bx lr
	
Configura_GPIOIEV
	; Configura borda de descida para J0
	; Configura borda de subida para J1
	ldr r0, =GPIO_PORTJ_AHB_IEV_R
	mov r1, #2_10
	str r1, [r0]
	bx lr
	
Configura_GPIOICR
	; Garante que a interrupcao sera atendida limpando o GPIORIS e GPIOMIS
	; Realiza o ACK no registrador
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #2_11
	str r1, [r0]
	bx lr
	
Habilita_GPIOIM
	ldr r0, =GPIO_PORTJ_AHB_IM_R
	mov r1, #2_11
	str r1, [r0]
	bx lr
	
Ativa_NVIC
	ldr r0, =NVIC_EN1_R
	mov r1, #0x0
	movt r1, #2_1000
	str r1, [r0]
	
	ldr r0, =NVIC_PRI12_R
	mov r1, #5
	lsl r1, #29
	ldr r2, [r0]
	orr r1, r1, r2
	str r1, [r0]
	
	bx lr
	
; ********************************************
; Rotinas de Interrupcao
; ********************************************

GPIOPortJ_Handler
	ldr r0, =GPIO_PORTJ_AHB_RIS_R
	ldr r1, [r0]
	and r1, r1, #2_11
	push{lr}
	cmp r1, #2_01
	beq interrupt_J0
	cmp r1, #2_10
	beq interrupt_J1
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #2_11
	str r1, [r0]

Fim_Interrupt
	pop{lr}
	
	bx lr
	

interrupt_J0
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #0x1
	str r1, [r0]
	
	ldr r0, =GPIO_PORTN_AHB_DATA_R
	ldr r2, [r0]
	bic r2, #0x2
	mov r1, #2_10
	orr r1, r1, r2
	str r1, [r0]
	
	b Fim_Interrupt

interrupt_J1
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #2_10
	str r1, [r0]
	
	ldr r0, =GPIO_PORTN_AHB_DATA_R
	ldr r2, [r0]
	bic r2, #0x2
	mov r1, #2_00
	orr r1, r1, r2
	str r1, [r0]
	
	b Fim_Interrupt

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo