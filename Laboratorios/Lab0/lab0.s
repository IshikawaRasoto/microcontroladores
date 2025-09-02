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
	mov r0, #0	; i: Numero do elemento atual
	mov r1, #0	; Numero de trocas
b_loop
	add r2, r0, #1				; r2 -> j: Numero do proximo elemento
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
	bgt		bubble		; Se houve troca, executa novamente
	
pg
	ldr		r12, =inicio
	mov 	r11, #30
	
	mov		r0, #0	; r0 -> i = 0
	mov 	r1, #0	; r1 -> j = 0
	mov 	r2, #0 	; r2 -> contador de itens na pilha
	mov		r3, #0	; r3 -> razao 
	mov		r4, #0	; r4 -> Item apontado por i
	mov 	r5, #0	; r5 -> Item apontado por j
	mov 	r6,	#0	; r6 -> Item apontado por k
	mov		r7, #0	; r7 -> Resto da divisao
	mov		r8, #0  ; r8 -> k = 0
	mov		r9, #0	; r9 -> Produto
	mov		r10,#0 	; r10 -> garbage
	
for_i
	cmp		r0, r11
	bge		fim_pg
	
	add r1, r0, #1
	
for_j
	cmp r1, r11
	bge	next_i
	
	ldrh r4, [r12, r0, lsl#1] ; v[i]
	ldrh r5, [r12, r1, lsl#1] ; v[j]
	

	cmp r4, #0
	beq next_i
	
	udiv 	r3, r5, r4		; r3 (razao) = r5 / r4
	mls		r7, r3, r4, r5	; r7 = r5 - (r3 * r4)
		
	cmp r7, #0	; se nao for divisor, proximo j
	bne next_j
	
	mov r2, #2	; contador = 2
	push {r4}
	push {r5}
	
	add r8, r1, #1
	mov r9, r5
	mul r9, r9, r3
	
for_k
	cmp r8, r11
	bge check_pg
	
	ldrh r6, [r12, r8, lsl#1] ; v[k]
	
	cmp r6, r9
	bne next_k
	
	push {r6}
	add r2, r2, #1
	mov r9, r6
	mul r9, r9, r3
	
next_k
	add r8, r8, #1
	b for_k
	
next_j
	add r1, r1, #1
	b for_j
next_i
	add r0, r0, #1
	b for_i
	
check_pg
	cmp r2, #5
	blt limpa_pilha
	b fim_alg
	
limpa_pilha
	cmp r2, #0
	
	popne {r10}
	subne r2, r2, #1
	bne limpa_pilha
	b next_j
	
fim_alg
	sub r0, r2, #1
	cmp r2, #0
	popne{r10}
	ldrne r12, =resultado
	strhne r10, [r12, r0, lsl#1]
	subne r2, r2, #1
	bne fim_alg
	b fim
	
fim_pg
	mov r2, #0x1234
		
fim
	b fim
	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
