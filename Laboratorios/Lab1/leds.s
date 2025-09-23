; leds.s
; Desenvolvido para a placa EK-TM4C1294XL
; Codigo que controla os leds da placa de apoio:

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------

	AREA    |.text|, CODE, READONLY, ALIGN=2

    export Escreve_LEDs
    export Acende_Leds
    export Apaga_Leds

    import SysTick_Wait1ms

    import PortA_Output
    import PortB_Output
    import PortN_Output			; Permite chamar PortN_Output de outro arquivo
    import PortP_Output
    import PortQ_Output

; Inputs para as proximas funcoes
; R11	- Valor dos leds

; Rotinas para controle dos leds

Escreve_LEDs
    push {r0, r1, r2, lr}

    ; chama as funcoes para escrever os valores nos LEDs
    and r2, r11, #2_00001111  ; isola os bits 0-3
    bl PortQ_Output
    and r2, r11, #2_11110000  ; isola os bits 4 - 7
    bl PortA_Output

    bl Acende_Leds
    mov r0, #1
    bl SysTick_Wait1ms
    bl Apaga_Leds
    mov r0, #1
    bl SysTick_Wait1ms

    pop {r0, r1, r2, lr}
    bx lr

Acende_Leds
    push {r0, r1, r2, lr}
    
    mov r2, #2_100000
    bl PortP_Output

    pop {r0, r1, r2, lr}
    bx lr

Apaga_Leds
    push {r0, r1, r2, lr}
    
    mov r2, #0x0
    bl PortP_Output

    pop {r0, r1, r2, lr}
    bx lr