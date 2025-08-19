; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
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
	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
