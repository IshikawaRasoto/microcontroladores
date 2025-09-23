; display.s
; Desenvolvido para a placa EK-TM4C1294XL
; Codigo que controla os leds da placa de apoio:

; -------------------------------------------------------------------------------
        THUMB                        ; Instrucoes do tipo Thumb-2
; -------------------------------------------------------------------------------

	AREA    |.text|, CODE, READONLY, ALIGN=2

; Display 1 - Dezenas
; Display 2 - Unidades

    export Escreve_Display_Decimo
    export Escreve_Display_Unitario

    export Display1_Liga
    export Display1_Desliga
    export Display2_Liga
    export Display2_Desliga
    export Printa_0
    export Printa_1
    export Printa_2
    export Printa_3
    export Printa_4
    export Printa_5
    export Printa_6
    export Printa_7
    export Printa_8
    export Printa_9
    export Printa_A
    export Printa_B
    export Printa_C
    export Printa_D
    export Printa_E
    export Printa_F

    import SysTick_Wait1ms

    import PortA_Output
    import PortB_Output
    import PortN_Output			; Permite chamar PortN_Output de outro arquivo
    import PortP_Output
    import PortQ_Output
		
		

seg7_hex_tbl
	DCB 2_00111111   ; 0
	DCB 2_00000110   ; 1
	DCB 2_01011011   ; 2
	DCB 2_01001111   ; 3
	DCB 2_01100110   ; 4
	DCB 2_01101101   ; 5
	DCB 2_01111101   ; 6
	DCB 2_00000111	 ; 7
	DCB 2_01111111   ; 8
	DCB 2_01101111   ; 9
	DCB 2_01110111   ; A
	DCB 2_01111100   ; b
	DCB 2_00111001   ; C
	DCB 2_01011110   ; d
	DCB 2_01111001   ; E
	DCB 2_01110001   ; F

; Inputs para as proximas funcoes

; R10	- Valor a ser mostrado

; Rotinas para controle do display de 7 segmentos

; R8	- Valor do display unitario
; R9	- Valor do display dezenas

Escreve_Display_Decimo
    push {r0, r1, r2, r3, lr}

    ; atualiza o valor de r9 baseado em r10
	mov r0, #10
    udiv r9, r10, r0  ; r9 = r10 / 10

	and   r9, r9, #0xF        ; garante índice 0..F
    adr   r3, seg7_hex_tbl
    ldrb  r0, [r3, r9]        ; r4 = padrão de 7 segmentos

	and r2, r0, #2_00001111
	bl PortQ_Output
	
	and r2, r0, #2_11110000
	bl PortA_Output

    bl Display1_Liga
    mov r0, #1
    bl SysTick_Wait1ms
    bl Display1_Desliga
    mov r0, #1
    bl SysTick_Wait1ms

    pop {r0, r1, r2, r3, lr}
    bx lr


Escreve_Display_Unitario
    push {r0, r1, r2, lr}

    ; atualiza o valor de r8 baseado em r10
	
	mov   r0, #10          ; r0 = 10 (apoio)
    udiv  r8, r10, r0      ; r8 = r10 / 10
    mls   r8, r8, r0, r10  ; r8 = r10 - (r8 * 10)  => resto (r10 % 10)

    ; Escreve o valor do display unitario
    and   r8, r8, #0xF        ; garante índice 0..F
    adr   r3, seg7_hex_tbl
    ldrb  r0, [r3, r8]        ; r4 = padrão de 7 segmentos

	and r2, r0, #2_00001111
	bl PortQ_Output
	
	and r2, r0, #2_11110000
	bl PortA_Output

    bl Display2_Liga
    mov r0, #1
    bl SysTick_Wait1ms
    bl Display2_Desliga
    mov r0, #1
    bl SysTick_Wait1ms

    pop {r0, r1, r2, lr}
    bx lr


Display1_Liga 
    push {r0, r1, r2, lr}

    ; Ativa pino PB4
    mov r2, #2_10000
    bl PortB_Output

    pop {r0, r1, r2, lr}
    bx lr

Display1_Desliga
    push {r0, r1, r2, lr}
    
    ; Desativa pino PB4
    mov r2, #0x0
    bl PortB_Output

    pop {r0, r1, r2, lr}
    bx lr

Display2_Liga
    push {r0, r1, r2, lr}

    ; Ativa pino PB5
    mov r2, #2_100000
    bl PortB_Output

    pop {r0, r1, r2, lr}
    bx lr

Display2_Desliga
    push {r0, r1, r2, lr}
    
    ; Desativa pino PB5
    mov r2, #0x0
    bl PortB_Output

    pop {r0, r1, r2, lr}
    bx lr

; Controle dos segmentos dos displays
; a - PQ0
; b - PQ1
; c - PQ2
; d - PQ3
; e - PA4
; f - PA5
; g - PA6
; dp - PA7

Printa_0
; Registrado para enviar os valores para o display: r2
    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 0
    ; a, b, c, d, e, f -> true
    
    ; Ativando a, b, c, d
    mov r2, #2_1111
    bl PortQ_Output

    ; Ativando e, f
    mov r2, #2_00110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_1
; Registrado para enviar os valores para o display: r2
    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 1
    ; b, c -> true
    ; a, d -> false
    mov r2, #2_0110
    bl PortQ_Output

    ; e, f, g, dp -> false
    mov r2, #2_00000000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_2
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 2
    ; a, b, d -> true
    ; c -> false
    mov r2, #2_1011
    bl PortQ_Output

    ; e, g -> true
    ; f, dp -> false
    mov r2, #2_01010000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_3
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 3
    ; a, b, c, d -> true
    mov r2, #2_1111
    bl PortQ_Output

    ; g -> true
    ; e, f, dp -> false
    mov r2, #2_01000000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_4
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 4
    ; b, c -> true
    mov r2, #2_0110
    bl PortQ_Output

    ; f, g -> true
    ; a, d, e, dp -> false
    mov r2, #2_01100000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_5
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 5
    ; a, c, d -> true
    mov r2, #2_1101
    bl PortQ_Output

    ; e, f, g, dp -> false
    mov r2, #2_00000000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_6
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 6
    ; a, c, d -> true
    mov r2, #2_1101
    bl PortQ_Output

    ; e, f, g -> true
    ; dp -> false
    mov r2, #2_01110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_7
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 7
    ; a, b, c -> true
    mov r2, #2_0111
    bl PortQ_Output

    ; e, f, g, dp -> false
    mov r2, #2_00000000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_8
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 8
    ; a, b, c, d -> true
    mov r2, #2_1111
    bl PortQ_Output

    ; e, f, g -> true
    ; dp -> false
    mov r2, #2_01110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_9
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o 9
    ; a, b, c, d -> true
    mov r2, #2_1111
    bl PortQ_Output

    ; f, g -> true
    ; e, dp -> false
    mov r2, #2_01100000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_A
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o A
    ; a, b, c -> true
    mov r2, #2_0111
    bl PortQ_Output

    ; e, f, g -> true
    ; dp -> false
    mov r2, #2_01110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_B
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o B
    ; c, d -> true
    mov r2, #2_1100
    bl PortQ_Output

    ; e, f, g -> true
    ; a, dp -> false
    mov r2, #2_01110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_C
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o C
    ; a, d -> true
    mov r2, #2_1001
    bl PortQ_Output

    ; e, f -> true
    ; b, c, g, dp -> false
    mov r2, #2_00110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_D
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o D
    ; b, c, d -> true
    mov r2, #2_1110
    bl PortQ_Output

    ; e, g -> true
    ; f, dp -> false
    mov r2, #2_01010000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_E
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o E
    ; a, d -> true
    mov r2, #2_1001
    bl PortQ_Output

    ; e, f, g -> true
    ; dp -> false
    mov r2, #2_01110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr

Printa_F
; Registrado para enviar os valores para o display: r2

    push {r0, r1, r2, lr}

    ; Ativa os segmentos para o F
    ; a -> true
    mov r2, #2_0001
    bl PortQ_Output

    ; e, f, g -> true
    ; dp -> false
    mov r2, #2_01110000
    bl PortA_Output

    pop {r0, r1, r2, lr}
    bx lr
	
END