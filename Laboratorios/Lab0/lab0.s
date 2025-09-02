; Lab0.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Aluno: Rafael Eijy Ishikawa Rasoto
; Lab0 - 02/09/2025

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
inicio 		EQU 0x20000400
resultado 	EQU 0x20000600

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função main()

Start  
; Comece o código aqui <======================================================


	ldr 	r12, =inicio
	mov 	r11, #30 		; Tamanho do Array
	
bubble
	mov r0, #0	; Numero do elemento atual
	mov r1, #0	; Numero de trocas
b_loop
	add r2, r0, #1				; r2 -> Numero do proximo elemento
	cmp r2, r11					; final do array?
	bge	b_check
	ldrh 	r4, [r12, r0, lsl #1]	; r4 -> valor atual 
	ldrh 	r5, [r12, r2, lsl #1]	; r5 -> proximo valor
	cmp 	r4, r5
	strhgt	r5, [r12, r0, lsl #1]	; se r4>r5 -> salva r5 no lugar atual
	strhgt	r4, [r12, r2, lsl #1]	; se r4>r5 -> salva r4 no lugar do proximo
	addgt	r1, r1, #1				; incrementa o contador de trocas em 1
	mov r0, r2
	b 	b_loop
b_check
	cmp 	r1, #0		; Houve alguma troca nessa interacao?
	subgt 	r1, r1, #1	; Otimiza pulando o ultimo valor do ultimo loop
	bgt		bubble		; Se houve troca, executa novamente
	
pg
        BL      pa_find_ap
        B       fim


; ---------- Config ----------
MIN_TERMS       EQU     5              ; mínimo de termos na PA (>=3)

; ---------- pa_find_ap ----------
; Procura a PRIMEIRA PA com razão d>0 e pelo menos MIN_TERMS termos.
; Entradas esperadas:
;   r12 = base do vetor (0x20000400)
;   r11 = N (=30)
; Efeitos:
;   Se achar: copia termos para PA_OUT (palavra cada) e PA_COUNT = qtd
;   Se não achar: PA_COUNT = 0
; Preserva: nada além do convenção via PUSH/POP
pa_find_ap
        PUSH    {r4-r11, lr}

        MOV     r10, r11              ; N
        MOVS    r8, #0                ; i = 0

.pa_outer_i
        CMP     r8, r10               ; i < N?
        BGE     .pa_not_found

        ; a0 = arr[i]
        LDRH    r4, [r12, r8, LSL #1]

        ; j = i+1
        ADDS    r9, r8, #1

.pa_inner_j
        CMP     r9, r10               ; j < N?
        BGE     .pa_next_i

        ; a1 = arr[j]
        LDRH    r5, [r12, r9, LSL #1]
        ; d = a1 - a0
        SUBS    r6, r5, r4
        BLE     .pa_j_next            ; d<=0 ? ignora (não crescente)

        ; -------- inicia sequência na pilha: push a0, a1 --------
        MOVS    r7, #0                ; count = 0

        SUB     sp, sp, #4
        UXTH    r0, r4
        STR     r0, [sp]
        ADDS    r7, r7, #1

        SUB     sp, sp, #4
        UXTH    r0, r5
        STR     r0, [sp]
        ADDS    r7, r7, #1

        ; last = a1; expected = last + d
        MOV     r3, r5                ; r3 = last
        ADDS    r2, r3, r6            ; r2 = expected = last + d

        ; k = j+1
        ADDS    r1, r9, #1

.pa_k_loop
        CMP     r1, r10               ; k < N?
        BGE     .pa_check_min

        ; val = arr[k]
        LDRH    r0, [r12, r1, LSL #1] ; r0 = val

        ; if val == expected ? push
        CMP     r0, r2
        BEQ     .pa_push_val

        ; if val < expected ? avança k
        BLO     .pa_k_next

        ; val > expected:
        ; delta = val - expected
        SUBS    r0, r0, r2            ; r0 = delta (>=0)
        ; resto = delta % d  (UDIV + MLS)
        MOV     r1, r6                ; r1 = d
        BL      mod_u32               ; r0 = delta % d
        CMP     r0, #0
        BNE     .pa_k_next            ; não está na classe (val != expected + m*d)

        ; Está alinhado na classe, mas só aceitamos passo 1*d:
        ; (val - last) deve ser == d
        ; Recarrega val para r0
        LDRH    r0, [r12, r1, LSL #1]
        SUBS    r0, r0, r3            ; r0 = val - last
        CMP     r0, r6
        BNE     .pa_k_next

        ; (val == last + d) ? push
.pa_push_val
        ; push val
        LDRH    r0, [r12, r1, LSL #1]
        SUB     sp, sp, #4
        UXTH    r0, r0
        STR     r0, [sp]
        ADDS    r7, r7, #1

        ; last = val; expected = last + d
        LDRH    r3, [r12, r1, LSL #1] ; last
        ADDS    r2, r3, r6            ; expected = last + d

        ; avança k
.pa_k_next
        ADDS    r1, r1, #1
        B       .pa_k_loop

.pa_check_min
        ; Checa se atingiu mínimo
        CMP     r7, #MIN_TERMS
        BLT     .pa_pop_discard

        ; Copia sequência encontrada (do topo da pilha) para PA_OUT
        LDR     r0, =PA_OUT
        MOV     r1, r7
.pa_copy_out
        CMP     r1, #0
        BEQ     .pa_store_and_ret
        LDR     r2, [sp]
        ADD     sp, sp, #4
        STR     r2, [r0], #4
        SUBS    r1, r1, #1
        BNE     .pa_copy_out

.pa_store_and_ret
        LDR     r0, =PA_COUNT
        STR     r7, [r0]              ; grava quantidade
        POP     {r4-r11, pc}

.pa_pop_discard
        ; Desempilha tudo o que foi empilhado para esta tentativa
        CMP     r7, #0
        BEQ     .pa_j_next
.pa_pop_loop
        LDR     r0, [sp]
        ADD     sp, sp, #4
        SUBS    r7, r7, #1
        BNE     .pa_pop_loop

.pa_j_next
        ADDS    r9, r9, #1            ; j++
        B       .pa_inner_j

.pa_next_i
        ADDS    r8, r8, #1            ; i++
        B       .pa_outer_i

.pa_not_found
        ; Não encontrou nenhuma PA
        LDR     r0, =PA_COUNT
        MOVS    r1, #0
        STR     r1, [r0]
        POP     {r4-r11, pc}


; ---------- mod_u32 ----------
; r0 % r1 usando UDIV + MLS
; Entrada: r0 = dividendo (u32), r1 = divisor (u32)
; Saída:   r0 = resto
mod_u32
        UDIV    r2, r0, r1
        MLS     r0, r2, r1, r0
        BX      lr
		
fim
	b fim
	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
