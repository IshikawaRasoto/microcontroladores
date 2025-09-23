; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports

; Port A
GPIO_PORTA_AHB_LOCK_R    	EQU    0x40058520
GPIO_PORTA_AHB_CR_R      	EQU    0x40058524
GPIO_PORTA_AHB_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_AHB_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_AHB_DIR_R     	EQU    0x40058400
GPIO_PORTA_AHB_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_AHB_DEN_R     	EQU    0x4005851C
GPIO_PORTA_AHB_PUR_R     	EQU    0x40058510
GPIO_PORTA_AHB_DATA_R    	EQU    0x400583FC
GPIO_PORTA               	EQU    2_000000000000001
; Port B
GPIO_PORTB_AHB_LOCK_R    	EQU    0x40059520
GPIO_PORTB_AHB_CR_R      	EQU    0x40059524
GPIO_PORTB_AHB_AMSEL_R   	EQU    0x40059528
GPIO_PORTB_AHB_PCTL_R    	EQU    0x4005952C
GPIO_PORTB_AHB_DIR_R     	EQU    0x40059400
GPIO_PORTB_AHB_AFSEL_R   	EQU    0x40059420
GPIO_PORTB_AHB_DEN_R     	EQU    0x4005951C
GPIO_PORTB_AHB_PUR_R     	EQU    0x40059510
GPIO_PORTB_AHB_DATA_R    	EQU    0x400593FC
GPIO_PORTB               	EQU    2_000000000000010
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
; Port P
GPIO_PORTP_LOCK_R    		EQU    0x40065520
GPIO_PORTP_CR_R      		EQU    0x40065524
GPIO_PORTP_AMSEL_R   		EQU    0x40065528
GPIO_PORTP_PCTL_R    		EQU    0x4006552C
GPIO_PORTP_DIR_R     		EQU    0x40065400
GPIO_PORTP_AFSEL_R   		EQU    0x40065420
GPIO_PORTP_DEN_R     		EQU    0x4006551C
GPIO_PORTP_PUR_R     		EQU    0x40065510
GPIO_PORTP_DATA_R    		EQU    0x400653FC
GPIO_PORTP               	EQU    2_010000000000000
; PORT Q
GPIO_PORTQ_LOCK_R    		EQU    0x40066520
GPIO_PORTQ_CR_R      		EQU    0x40066524
GPIO_PORTQ_AMSEL_R   		EQU    0x40066528
GPIO_PORTQ_PCTL_R    		EQU    0x4006652C
GPIO_PORTQ_DIR_R     		EQU    0x40066400
GPIO_PORTQ_AFSEL_R   		EQU    0x40066420
GPIO_PORTQ_DEN_R     		EQU    0x4006651C
GPIO_PORTQ_PUR_R     		EQU    0x40066510
GPIO_PORTQ_DATA_R    		EQU    0x400663FC
GPIO_PORTQ               	EQU    2_100000000000000
	
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
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        
		EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		
		export PortA_Output
		export PortB_Output
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
		export PortP_Output
		EXPORT PortQ_Output

		EXPORT Configura_Interrupts	
		EXPORT Desabilita_GPIOIM				
		export Configura_GPIOIS
		export Configura_GPIOIBE
		export Configura_GPIOIEV
		export Configura_GPIOICR
		export Habilita_GPIOIM
		export Ativa_NVIC			
		export GPIOPortJ_Handler

		export Acende_LED_N0
		export Apaga_LED_N0
		export Acende_LED_N1
		export Apaga_LED_N1
;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; ****************************************
; Escrever fun��o de inicializa��o dos GPIO
; Inicializar as portas J, N, A, Q
; ****************************************
	; Inicializa Clock dos GPIOs
	ldr r0, =SYSCTL_RCGCGPIO_R
	mov r1, #GPIO_PORTA
	orr r1, #GPIO_PORTB
	orr r1, #GPIO_PORTJ
	orr r1, #GPIO_PORTN
	orr r1, #GPIO_PORTP
	orr r1, #GPIO_PORTQ
	str r1, [r0]
	
	;Espera GPIOs
	ldr r0, =SYSCTL_PRGPIO_R
GPIO_Wait
	ldr r1, [r0]
	mov r2, #GPIO_PORTA
	orr r2, #GPIO_PORTB
	orr r2, #GPIO_PORTJ
	orr r2, #GPIO_PORTN
	orr r2, #GPIO_PORTP
	orr r2, #GPIO_PORTQ
	tst r1, r2
	beq GPIO_Wait
	
	; Limpa AMSEL para desabilitar Analogica
	mov r1, #0x0
	ldr r0, =GPIO_PORTA_AHB_AMSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTB_AHB_AMSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTJ_AHB_AMSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_AMSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTP_AMSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTQ_AMSEL_R
	str r1, [r0]
	
	; Limpar PCTL para selecionar o GPIO
	mov r1, #0x00
	ldr r0, =GPIO_PORTA_AHB_PCTL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTB_AHB_PCTL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTJ_AHB_PCTL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_PCTL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTP_PCTL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTQ_PCTL_R
	str r1, [r0]

	; Direcao dos GPIOs
	ldr r0, =GPIO_PORTA_AHB_DIR_R
	mov r1, #2_11110000
	str r1, [r0]
	ldr r0, =GPIO_PORTB_AHB_DIR_R
	mov r1, #2_110000
	str r1, [r0]
	ldr r0, =GPIO_PORTJ_AHB_DIR_R
	mov r1, #0x00
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_DIR_R
	mov r1, #2_11
	str r1, [r0]
	ldr r0, =GPIO_PORTP_DIR_R
	mov r1, #2_100000
	str r1, [r0]
	ldr r0, =GPIO_PORTQ_DIR_R
	mov r1, #2_1111
	str r1, [r0]
	
	; Limpa bits AFSEL para nao ter funcao alternativa
	mov r1, #0x0
	ldr r0, =GPIO_PORTA_AHB_AFSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTB_AHB_AFSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTJ_AHB_AFSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTN_AHB_AFSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTP_AFSEL_R
	str r1, [r0]
	ldr r0, =GPIO_PORTQ_AFSEL_R
	str r1, [r0]
	
	; Setar os bits de DEN para habilitar I/O digital
	ldr r0, =GPIO_PORTA_AHB_DEN_R
	mov r1, #2_11110000
	str r1, [r0]
	ldr r0, =GPIO_PORTB_AHB_DEN_R
	mov r1, #2_110000
	str r1, [r0]
	ldr r0, =GPIO_PORTJ_AHB_DEN_R
	mov r1, #2_11
	str r1, [r0]	
	ldr r0, =GPIO_PORTN_AHB_DEN_R
	mov r1, #2_11
	str r1, [r0]
	ldr r0, =GPIO_PORTP_DEN_R
	mov r1, #2_100000
	str r1, [r0]
	ldr r0, =GPIO_PORTQ_DEN_R
	mov r1, #2_1111
	str r1, [r0]
	
	; Para habilitar resistor de pull-up interno, setar PUR para 1
	ldr r0, = GPIO_PORTJ_AHB_PUR_R
	mov r1, #2_11
	str r1, [r0]
	
	BX LR


; -------------------------------------------------------------------------------
; Fun��o PortN_Output
; Par�metro de entrada: 
; Par�metro de sa�da: N�o tem
PortN_Output
; ****************************************
; Escrever fun��o que acende ou apaga o LED
; ****************************************
	
	BX LR

Acende_LED_N0
	ldr r0, =GPIO_PORTN_AHB_DATA_R
	ldr r1, [r0]
	orr r1, r1, #0x1
	str r1, [r0]
	bx lr

Apaga_LED_N0
	ldr r0, =GPIO_PORTN_AHB_DATA_R
	ldr r1, [r0]
	bic r1, r1, #0x1
	str r1, [r0]
	bx lr

Acende_LED_N1
	ldr r0, =GPIO_PORTN_AHB_DATA_R
	ldr r1, [r0]
	orr r1, r1, #0x2
	str r1, [r0]
	bx lr

Apaga_LED_N1
	ldr r0, =GPIO_PORTN_AHB_DATA_R
	ldr r1, [r0]
	bic r1, r1, #0x2
	str r1, [r0]
	bx lr

; -------------------------------------------------------------------------------
PortA_Output
; Parametro de entrada: R2
; Parametro de saida: Nao tem

	push{r1, r3}
	ldr r1, =GPIO_PORTA_AHB_DATA_R
	ldr r3, [r1]
	bic r3, #2_11110000
	orr r2, r2, r3
	str r2, [r1]
	pop{r1, r3}
	BX LR

PortB_Output
; Parametro de entrada: R2
; Parametro de saida: Nao tem

	push{r1, r3}
	ldr r1, =GPIO_PORTB_AHB_DATA_R
	ldr r3, [r1]
	bic r3, #2_110000
	orr r2, r2, r3
	str r2, [r1]
	pop{r1, r3}
	BX LR

PortP_Output
; Parametro de entrada: R2
; Parametro de saida: Nao tem

	push{r1, r3}
	ldr r1, =GPIO_PORTP_DATA_R
	ldr r3, [r1]
	bic r3, #2_100000
	orr r2, r2, r3
	str r2, [r1]
	pop{r1, r3}
	BX LR

PortQ_Output
; Parametro de entrada: R2
; Parametro de saida: Nao tem

	push{r1, r3}
	ldr r1, =GPIO_PORTQ_DATA_R
	ldr r3, [r1]
	bic r3, #2_1111
	orr r2, r2, r3
	str r2, [r1]
	pop{r1, r3}
	BX LR


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
	; Configura borda de descida para J1
	ldr r0, =GPIO_PORTJ_AHB_IEV_R
	mov r1, #2_00
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
	push{r0}
	ldr r0, =GPIO_PORTJ_AHB_RIS_R
	ldr r1, [r0]
	pop{r0}
	and r1, r1, #2_11
	push{lr}
	cmp r1, #2_01
	beq interrupt_J0
	cmp r1, #2_10
	beq interrupt_J1
	; Se chegar aqui, ninguem chamou a interrupcao
	push{r0}
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #2_11
	str r1, [r0]
	pop{r0}

Fim_Interrupt
	pop{lr}
	
	bx lr
	

interrupt_J0
	; Acknowledge da interrupcao
	push{r0}
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #0x1
	str r1, [r0]
	pop{r0}

	; Codigo Interrupcao SW1
	cmp 	r11, 	#50
	addlt 	r11, 	#1
	
	b Fim_Interrupt

interrupt_J1
	; Acknowledge da interrupcao
	push{r0}
	ldr r0, =GPIO_PORTJ_AHB_ICR_R
	mov r1, #2_10
	str r1, [r0]
	pop{r0}

	; Codigo Interrupcao SW2
	cmp 	r11, #5
	subgt 	r11, #1

	b Fim_Interrupt

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo