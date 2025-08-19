; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
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

; -------------------------------------------------------------------------------
; Fun��o main()
Start  
; Comece o c�digo aqui <======================================================
; Exercicio 3
	
	mov 	r12, #701
	lsrs	r0, r12, #5
	mov 	r12, #0x7d43 ; 32067
	neg 	r12, r12
	lsrs	r1, r12, #4
	mov 	r12, #701
	lsrs	r2, r12, #3
	mov 	r12, #0x7d43 ; 32067
	neg 	r12, r12
	lsrs	r3, r12, #5
	mov 	r12, #255
	lsls	r4, r12, #8
	mov 	r12, #0xE666 ; 58982
	neg		r12, r12
	lsls	r5, r12, #18
	mov		r12, #0x1234
	movt	r12, #0xFABC
	rors	r6, r12, #10
	mov 	r7, #0x4321
	rrxs	r7, r7
	rrxs	r7, r7
	nop
	

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
